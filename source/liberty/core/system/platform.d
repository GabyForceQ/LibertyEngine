/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/platform.d, _platform.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.platform;

import derelict.sdl2.sdl :
  DerelictSDL2, SharedLibVersion, 
  SDL_Init, SDL_INIT_VIDEO, SDL_INIT_EVENTS,
  SDL_GetError, SDL_ClearError,
  SDL_WINDOW_OPENGL;

import liberty.core.utils : Singleton;
import liberty.core.logger.manager : Logger;
import liberty.core.logger.meta : ExceptionConstructor;
import liberty.core.system.window : Window;
import liberty.core.system.video.renderer : Renderer;

/**
 * A failing Platform function should <b>always</b> throw a $(D PlatformException).
**/
final class PlatformException : Exception {
  mixin(ExceptionConstructor);
}

/**
 *
**/
final class Platform : Singleton!Platform {
  private {
    Window _window;
  }

  /**
   *
  **/
  Window getWindow() pure nothrow @safe {
    return _window;
  }

  package void initialize() {
    // Initialize SDL2 Library
    try {
      DerelictSDL2.load(SharedLibVersion(2, 0, 8));
    } catch (Exception e) {
      throw new PlatformException(e.msg);
    }
    SDL_Init(SDL_INIT_VIDEO);
    SDL_Init(SDL_INIT_EVENTS);

    version (__OpenGL__) {
      // Initialize video context
      Renderer.self.initGLContext(4, 5);

      // Create main window
      _window = new Window(this, SDL_WINDOW_OPENGL);

      // Reload video context
      Renderer.self.reloadGLContext();

      // Init shaders
      Renderer.self.initShaders();
    }

    Logger.self.info("Initialized", typeof(this).stringof);
  }

  package void deinitialize() {
    if (_window !is null) {
      _window.destroy();
      _window = null;
    }
    Logger.self.info("Deinitialized", typeof(this).stringof);
  }

  package void throwPlatformException(string call_name) {
    import std.format : format;
    string message = format("%s failed: %s", call_name, errorString());
    throw new PlatformException(message);
  }

  /**
   * Returns last SDL error and clears it.
  **/
  const(char)[] errorString() {
    import std.string : fromStringz;
    const(char)* message = SDL_GetError();
    SDL_ClearError();
    return fromStringz(message);
  }
}