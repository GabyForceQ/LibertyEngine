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

// test
import liberty.core.system.engine : CoreEngine;
import liberty.core.system.video.renderer : Renderer;
import liberty.core.system.logic : Logic;
import derelict.opengl;

/**
 *
**/
final class GraphicsEngine : Singleton!GraphicsEngine {
  mixin(ManagerBody);

  private {
    GfxBackend _backend;
  }

	private static immutable startBody = q{
		version (__OpenGL__) {
      _backend = new GLBackend();
    }
	};

  private static immutable stopBody = q{
    _backend.destroy();
    _backend = null;
  };

  /**
   *
  **/
  GfxBackend getBackend() {
    return _backend;
  }

  /**
   *
  **/
	void render() @trusted {
    _backend.render();

    // EXPERIMENTS
    Renderer.self._colorProgram.use();

    int textureLocation = Renderer.self._colorProgram.getUniformLocation("uTexture");
    glUniform1i(textureLocation, 0);

    //uint timeLocation = Renderer.self._colorProgram.getUniformLocation("uTime");
    //glUniform1f(timeLocation, Logic.self.elapsedTime * 10);

    Logic.self
      .getViewport()
      .getActiveScene()
      .render();
    
    glBindTexture(GL_TEXTURE_2D, 0);
    Renderer.self._colorProgram.unuse();
	}
}