/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/video/renderer.d, _renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.video.renderer;

import derelict.sdl2.sdl :
  SDL_GL_CONTEXT_MAJOR_VERSION,
  SDL_GL_CONTEXT_MINOR_VERSION,
  SDL_GL_CONTEXT_PROFILE_MASK,
  SDL_GL_CONTEXT_PROFILE_CORE,
  SDL_GL_DOUBLEBUFFER,
  SDL_GL_SetAttribute,
  SDL_GL_SwapWindow,
  SDL_GL_SetSwapInterval;

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

  /**
   *
  **/
  GLShaderProgram _colorProgram;

  /**
   *
  **/
  void initialize() {
    GraphicsEngine.self.startService();
    Logger.self.info("Initialized", typeof(this).stringof);
  }

  /**
   *
  **/
  void deinitialize() {
    GraphicsEngine.self.stopService();
    Logger.self.info("Deinitialized", typeof(this).stringof);
  }

  /**
   *
  **/
  void initShaders() {
    _colorProgram = new GLShaderProgram();
    _colorProgram.compileShaders(vertex3Color, fragmentColor);
    _colorProgram.addAttribute("position");
    //_colorProgram.addAttribute("vertexColor");
    //_colorProgram.addAttribute("texCoords");
    _colorProgram.linkShaders();
    _colorProgram.addUniform("uTransform");
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

  /**
   *
  **/
  void reloadGLContext() {
      GraphicsEngine.self.getBackend().reloadContext();
      GraphicsEngine.self.getBackend().clearColor(0.0f, 0.0f, 1.0f, 1.0f);
      GraphicsEngine.self.getBackend().enable3DCapabilities();
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

  /**
   *
  **/
  void enableVSync() {
    SDL_GL_SetSwapInterval(1);
  }

  /**
   *
  **/
  void disableVSync() {
    SDL_GL_SetSwapInterval(0);
  }

  /**
   *
  **/
  void enableAlphaBlend() {
    import derelict.opengl;
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  }
}