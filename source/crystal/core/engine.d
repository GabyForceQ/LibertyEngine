/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.core.engine;
import crystal.graphics.renderer;
import crystal.core.input;
import crystal.core.scenegraph;
import crystal.graphics.opengl;
import derelict.sdl2.sdl;
import crystal.core.input;
import crystal.math;
import crystal.graphics.postprocessing;
import std.math, std.random;
import derelict.util.loader;
import crystal.core.imaging;
import crystal.core.time : getTime;
import crystal.core.model : Models;
import crystal.graphics.material : Materials;
import crystal.core.system;
///
class CoreEngineException : Exception {
    ///
    @safe pure nothrow this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
        super(message, file, line, next);
    }
}
private {
    Platform _platformApi;
    SDL2Window _mainWindow;
}
Platform getPlatform() {
	return _platformApi;
}
SDL2Window getMainWindow() {
	return _mainWindow;
}
///
struct WindowInfo {
	///
	string title = "Crystal Studio " ~ import("ENGINE.VER");
    ///
    int width = 1280;
    ///
    int height = 720;
    ///
    double ratio() { return width / cast(double)height; }
}
///
class CoreEngine {
	static:
    private {
        float deltaTime = 0.0f;
        float lastFrame = 0.0f;
        WindowInfo _windowInfo;
        Scene _activeScene;
        Image _imageAPI; // TODO.
    }
    ///
    void setActiveScene(Scene scene) nothrow { // TODO: package.
        _activeScene = scene;
    }
    ///
    Scene getActiveScene() nothrow {
        return _activeScene;
    }
    Platform getPlatform() { return _platformApi; }
    SDL2Window getMainWindow() { return _mainWindow; }
    Image getImageAPI() { return _imageAPI; }
    ///
    void startService() {
        version (__Logger__) {
            Logger.startService();
        }
        GraphicsEngine.startService();

        _initWindow();
        _mainWindow.setTitle(_windowInfo.title);
        _imageAPI = new Image(); // TODO.
        Materials.load();
        Models.load();
    }
    ///
    void stopService() {
        GraphicsEngine.stopService();
        version (__Logger__) {
            Logger.stopService();
        }
        collectGarbage();
    }
    ///
    void restartServic() {
        stopService();
        startService();
    }
    ///
    void setWindowInfo(WindowInfo win_info = WindowInfo()) {
        _windowInfo = win_info;
    }
    ///
    void setWindowInfo(int width, int height) {
        _windowInfo.width = width;
        _windowInfo.height = height;
    }
    ///
    WindowInfo getWindowInfo() {
        return _windowInfo;
    }
    ///
    void runMainLoop() {
        while(!_platformApi.getShouldQuit()) {
            if (_shouldQuitOnKey && Input.isKeyDown(KeyCode.Esc)) {
                break;
            }
						Input._isMouseMoving = false;
						Input._isMouseWheeling = false;
            _platformApi.processEvents();
            const float currentFrame = getTime();
            deltaTime = currentFrame - lastFrame;
            lastFrame = currentFrame;
			if (_activeScene.isRegistered()) {
                _activeScene.update(deltaTime);
				_activeScene.process();
                GraphicsEngine.render();
            }
        }
    }
    bool _shouldQuitOnKey;
    ///
    void shouldQuitOnKey(KeyCode key) {
        _shouldQuitOnKey = true;
    }
    ///
    float getDeltaTime() nothrow {
        return deltaTime;
    }
    private void _initWindow() {
        _platformApi = new Platform(SharedLibVersion(2, 0, 6));
        _platformApi.subSystemInit(SDL_INIT_VIDEO);
        _platformApi.subSystemInit(SDL_INIT_EVENTS);
        version (__OpenGL__) {
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 5);
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
	        _mainWindow = new SDL2Window(
	            _platformApi,
	            SDL_WINDOWPOS_CENTERED,
	            SDL_WINDOWPOS_CENTERED,
	            _windowInfo.width,
	            _windowInfo.height,
	            SDL_WINDOW_OPENGL
	        );
	        GraphicsEngine.getBackend().reload();
        } else version (__Vulkan__) {
            _mainWindow = new SDL2Window(
                _platformApi,
                SDL_WINDOWPOS_CENTERED,
                SDL_WINDOWPOS_CENTERED,
                _windowInfo.width,
                _windowInfo.height,
                SDL_WINDOW_VULKAN
            );
        }
    }
    ///
    void setGCEnabled(bool enabled = true) {
        import core.memory : GC;
        enabled ? GC.enable() : GC.disable();
    }
    ///
    void collectGarbage() {
        import core.memory : GC;
        GC.collect();
    }
}
///
immutable NativeServices = q{
    void main() {
	CoreEngine.startService();
        initSettings();
        initScene();
        CoreEngine.runMainLoop();
	CoreEngine.stopService();
    }
};
