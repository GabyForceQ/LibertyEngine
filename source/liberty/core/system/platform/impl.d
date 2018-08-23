/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/platform/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.platform.impl;

import derelict.sdl2.sdl :
  DerelictSDL2,
  SharedLibVersion, 
  SDL_Init;

import liberty.core.system;

import liberty.core.utils : Singleton;
import liberty.core.logger.manager : Logger;
import liberty.core.logger.meta : ExceptionConstructor;
import liberty.core.system.window : Window;
import liberty.core.system.video.renderer : Renderer;
import liberty.core.system.window.wrapper.constants : WindowFlags;
import liberty.core.math.vector : Vector2I;

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

  package(liberty.core.system) void initialize() {
    // Load SDL2 Library
    PlatformUtil.self.loadLibrary();

    version (__OpenGL__) {
      // Initialize video context
      Renderer.self.initGLContext(4, 5);

      // Create main window
      _window = new Window(this, Vector2I(1600, 900), WindowFlags.OpenGL);

      // Reload video context
      Renderer.self.reloadGLContext();

      // Init shaders
      Renderer.self.initShaders();
    }

    Logger.self.info("Initialized", typeof(this).stringof);
  }

  package(liberty.core.system) void deinitialize() {
    if (_window !is null) {
      _window.destroy();
      _window = null;
    }
    Logger.self.info("Deinitialized", typeof(this).stringof);
  }
}