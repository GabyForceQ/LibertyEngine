/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/context.d, _context.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.context;

import derelict.sdl2.sdl :
  SDL_GLContext, 
  SDL_GL_CreateContext, 
  SDL_GL_MakeCurrent;

import liberty.core.logger.manager : Logger;
import liberty.core.system.window : Window;

/**
 *
**/
final class VideoContext {
	private {
    SDL_GLContext _videoContext;
		Window _window;
    bool _initialized;
	}

  /**
   * Creates an OpenGL context for a given SDL window.
  **/
  this(Window window) {
    _window = window;
    _videoContext = SDL_GL_CreateContext(window.getHandle());
    _initialized = true;
  }

  ~this() {
    close();
  }

  /**
   *
  **/
  void close() {
    if (_initialized) {
      _initialized = false;
    }
  }

  /**
   * Makes this graphics context current.
  **/
  void makeCurrent() {
    if (0 != SDL_GL_MakeCurrent(_window.getHandle(), _videoContext)) {
      Logger.self.error(
        "Cannot bind OpenGL graphics context",
        typeof(this).stringof
      );
    }
  }
}