module liberty.core.system.video.context;

import derelict.sdl2.sdl :
    SDL_GLContext, SDL_GL_CreateContext, SDL_GL_MakeCurrent;

import liberty.core.system.window : Window;

/**
 *
 */
final class VideoContext {

	private {
        version (__OpenGL__) {
		    SDL_GLContext _videoContext;
        } else version (__Vulkan__) {
            // TODO.
        }
		Window _window;
        bool _initialized;
	}

    /**
     * Creates an OpenGL context for a given SDL window.
     */
    this(Window window) {
        _window = window;
        version (__OpenGL__) {
            _videoContext = SDL_GL_CreateContext(window.handle);
        }
        _initialized = true;
    }

    ~this() {
        close();
    }

    /**
     *
     */
    void close() {
        if (_initialized) {
            _initialized = false;
        }
    }

    /**
     * Makes this graphics context current.
     * Throws $(D PlatformException) on error.
     */
    void makeCurrent() {
        version (__OpenGL__) {
            if (0 != SDL_GL_MakeCurrent(_window.handle, _videoContext)) {
                _window.platform.throwPlatformException("SDL_GL_MakeCurrent");
            }
        }
    }

}