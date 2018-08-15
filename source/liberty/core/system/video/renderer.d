module liberty.core.system.video.renderer;

import derelict.sdl2.sdl :
  SDL_GL_CONTEXT_MAJOR_VERSION,
  SDL_GL_CONTEXT_MINOR_VERSION,
  SDL_GL_CONTEXT_PROFILE_MASK,
  SDL_GL_CONTEXT_PROFILE_CORE,
  SDL_GL_DOUBLEBUFFER,
  SDL_GL_SetAttribute,
  SDL_GL_SwapWindow;

import liberty.core.utils : Singleton;
import liberty.core.logger.manager : Logger;
import liberty.graphics.engine : GraphicsEngine;
import liberty.core.system.window : Window;

// test
import liberty.graphics.shader.constants;
import liberty.graphics.shader.opengl : GLShaderProgram;

/**
 *
**/
final class Renderer : Singleton!Renderer {
  private {
    Window _window;
  }

  GLShaderProgram _colorProgram;

  /**
   *
  **/
  void init() {
    GraphicsEngine.self.startService();
    Logger.self.info("Initialized", typeof(this).stringof);
  }

  /**
   *
  **/
  void deinit() {
    GraphicsEngine.self.stopService();
    Logger.self.info("Deinitialized", typeof(this).stringof);
  }

  /**
   *
  **/
  void initShaders() {
    _colorProgram = new GLShaderProgram();
    _colorProgram.compileShaders(vertexColor, fragmentColor);
    _colorProgram.addAttribute("vertexPosition");
    _colorProgram.addAttribute("vertexColor");
    _colorProgram.addAttribute("texCoords");
    _colorProgram.linkShaders();
  }

  /**
   *
  **/
  void window(Window window) {
      _window = window;
  }

  /**
   *
  **/
  void render() {
    GraphicsEngine.self.render();
    SDL_GL_SwapWindow(_window.getHandle());
  }

  version (__OpenGL__) {
    /**
     *
    **/
    void reloadGLContext() {
        GraphicsEngine.self.backend.reloadContext();
        GraphicsEngine.self.backend.clearColor(0.0f, 0.0f, 1.0f, 1.0f);
    }

    /**
     *
    **/
    void initGLContext(int majorVersion, int minorVersion) @trusted {
      SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, majorVersion);
      SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, minorVersion);
      SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
      SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
    }
  }
}