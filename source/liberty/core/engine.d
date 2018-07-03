/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/engine.d, _engine.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.engine;
import liberty.graphics.renderer;
import liberty.core.input;
import liberty.core.world;
import liberty.graphics.opengl;
import derelict.sdl2.sdl;
import liberty.core.input;
import liberty.math;
import liberty.graphics.postprocessing;
import std.math, std.random;
import derelict.util.loader;
import liberty.core.imaging;
import liberty.core.time : time;
import liberty.core.model : Models;
import liberty.graphics.material : Materials;
import liberty.core.system;
import liberty.core.utils : Singleton, IService;
///
class CoreEngineException : Exception {
    ///
    this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) pure nothrow @safe {
        super(message, file, line, next);
    }
}
private {
    Platform _platformApi;
    SDL2Window _mainWindow;
}
///
Platform platform() {
	return _platformApi;
}
///
SDL2Window mainWindow() {
	return _mainWindow;
}
///
struct WindowInfo {
	///
	string title = "Liberty Engine " ~ import("ENGINE.VER");
    ///
    int width = 1280;
    ///
    int height = 720;
    ///
    double ratio() { return width / cast(double)height; }
}
///
final class CoreEngine : Singleton!CoreEngine, IService {
    private {
        bool _serviceRunning;
        float _deltaTime = 0.0f;
        float lastFrame = 0.0f;
        WindowInfo _windowInfo;
        Scene _activeScene;
        Image _imageAPI; // TODO.
    }
    ///
    void activeScene(Scene scene) nothrow { // TODO: package.
        _activeScene = scene;
    }
    ///
    Scene activeScene() nothrow {
        return _activeScene;
    }
    ///
    Platform platform() { return _platformApi; }
    ///
    SDL2Window mainWindow() { return _mainWindow; }
    ///
    Image imageAPI() { return _imageAPI; }
    /// Start CoreEngine service.
    void startService() @trusted {
        version (__Logger__) {
            Logger.startService();
        }
        GraphicsEngine.get.startService();
        _initWindow();
        _mainWindow.title = _windowInfo.title;
        _imageAPI = new Image(); // TODO.
        Materials.get.load();
        Models.get.load();
        _serviceRunning = true;
    }
    /// Stop CoreEngine service.
    void stopService() @trusted {
        GraphicsEngine.get.stopService();
        version (__Logger__) {
            Logger.stopService();
        }
        collectGarbage();
        _serviceRunning = false;
    }
    /// Restart CoreEngine service.
    void restartService() @trusted {
        stopService();
        startService();
    }
    /// Returns true if CoreEngine service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
    ///
    void windowInfo(WindowInfo win_info = WindowInfo()) {
        _windowInfo = win_info;
    }
    ///
    void windowInfo(int width, int height) {
        _windowInfo.width = width;
        _windowInfo.height = height;
    }
    ///
    WindowInfo windowInfo() nothrow @safe @nogc @property {
        return _windowInfo;
    }
    ///
    void runMainLoop() {
        while(!_platformApi.shouldQuit()) {
            if (_shouldQuitOnKey && Input.get.isKeyDown(KeyCode.Esc)) {
                break;
            }
            Input.get._isMouseMoving = false;
            Input.get._isMouseWheeling = false;
            _platformApi.processEvents();
            const float currentFrame = time();
            _deltaTime = currentFrame - lastFrame;
            lastFrame = currentFrame;
			if (_activeScene.isRegistered()) {
                _activeScene.update(_deltaTime);
				_activeScene.process();
                GraphicsEngine.get.render();
            }
        }
    }
    bool _shouldQuitOnKey;
    ///
    void shouldQuitOnKey(KeyCode key) {
        _shouldQuitOnKey = true;
    }
    ///
    float deltaTime() nothrow {
        return _deltaTime;
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
	        GraphicsEngine.get.backend.reload();
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
    void gcEnabled(bool enabled = true) {
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
	    CoreEngine.get.startService();
        initSettings();
        initScene();
        CoreEngine.get.runMainLoop();
	    CoreEngine.get.stopService();
    }
};
