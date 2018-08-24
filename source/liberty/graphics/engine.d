/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/engine.d, _engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.engine;

import liberty.core.utils : Singleton;
import liberty.core.manager.meta : ManagerBody;

import liberty.graphics.backend.gfx : GfxBackend;
import liberty.graphics.backend.opengl : GLBackend;
import liberty.graphics.shader.gfx : GfxShaderProgram;
import liberty.graphics.shader.opengl : GLShaderProgram;
import liberty.graphics.shader.constants;

import liberty.core.system.window : Window;

// test
import liberty.core.system.engine : CoreEngine;
import liberty.core.system.viewport : Viewport;
import derelict.opengl;

import derelict.sdl2.sdl :
  SDL_GL_CONTEXT_MAJOR_VERSION,
  SDL_GL_CONTEXT_MINOR_VERSION,
  SDL_GL_CONTEXT_PROFILE_MASK,
  SDL_GL_CONTEXT_PROFILE_CORE,
  SDL_GL_DOUBLEBUFFER,
  SDL_GL_SetAttribute,
  SDL_GL_SwapWindow,
  SDL_GL_SetSwapInterval;

/**
 *
**/
final class GraphicsEngine : Singleton!GraphicsEngine {
  mixin(ManagerBody);

  //private {
    Window window;
    GfxBackend backend;
    GfxShaderProgram shaderProgram;
  //}

	private static immutable startBody = q{
    // Create graphics backend
    this.backend = new GLBackend();
	};

  private static immutable stopBody = q{
    this.backend.destroy();
    this.backend = null;
  };

  void attachWindow(Window window) {
    this.window = window;
  }

  /**
   *
  **/
  GfxBackend getBackend() {
    return this.backend;
  }

  /**
   *
  **/
  void initShaders() {
    // Create the main shader
    this.shaderProgram = new GLShaderProgram();
    this.shaderProgram.compileShaders(VertexColor, FragmentColor);
    this.shaderProgram.addAttribute("lPosition");
    this.shaderProgram.addAttribute("lTexCoord");
    this.shaderProgram.linkShaders();
    this.shaderProgram.addUniform("uModel");
    this.shaderProgram.addUniform("uView");
    this.shaderProgram.addUniform("uProjection");
    this.shaderProgram.addUniform("uTextureSampler");
    this.shaderProgram.addUniform("uColor");
  }

  /**
   *
  **/
	void render() @trusted {
    this.backend.clearScreen();

    // EXPERIMENTS
    this.shaderProgram.bind();

    CoreEngine.self
      .getViewport()
      .getScene()
      .render();
    
    glBindTexture(GL_TEXTURE_2D, 0);
    this.shaderProgram.unbind();

    SDL_GL_SwapWindow(this.window.getHandle());
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