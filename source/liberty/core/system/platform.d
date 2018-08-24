/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/platform/package.d, _package.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.platform;

import derelict.sdl2.sdl :
  DerelictSDL2,
  SharedLibVersion, 
  SDL_Init,
  SDL_INIT_EVERYTHING;

import liberty.core.system;

import liberty.core.utils : Singleton;
import liberty.core.logger.constants : InfoMessage;
import liberty.core.logger.manager : Logger;
import liberty.core.system.window : Window;
import liberty.core.system.window.constants : WindowFlags;
import liberty.core.math.vector : Vector2I;
import liberty.graphics.engine : GraphicsEngine;

/**
 * A platform represents the root system for windows manager.
 * Currently it supports only one window.
 * GraphicsEngine service should be running before attemping to initialize the platform.
**/
final class Platform : Singleton!Platform {
  private {
    Window _window;
  }

  /**
   * Get current platform window.
  **/
  Window getWindow() pure nothrow @safe {
    return _window;
  }

  /**
   * Initialize current platform.
   * It loads the SDL2 library.
   * Application fails if library coudn't be loaded.
  **/
  void initialize() {
    Logger.self.info(
      InfoMessage.Creating, 
      typeof(this).stringof
    );

    // Load SDL2 Library
    try {
      DerelictSDL2.load(SharedLibVersion(2, 0, 8));
    } catch (Exception e) {
      Logger.self.error(
        "Failed to load SDL2 library",
        typeof(this).stringof
      );
    }

    // Init all SDL2 capabilities
    SDL_Init(SDL_INIT_EVERYTHING);

    // Initialize video context
    GraphicsEngine.self.initGLContext(4, 5);

    // Create main window
    _window = new Window(
      this,
      Vector2I(1600, 900),
      WindowFlags.OpenGL
    );

    // Reload video context
    GraphicsEngine.self.reloadGLContext();

    // Init shaders
    GraphicsEngine.self.initShaders();

    Logger.self.info(
      InfoMessage.Created, 
      typeof(this).stringof
    );
  }

  /**
   * Deinitialize current platform.
  **/
  void deinitialize() {
    Logger.self.info(
      InfoMessage.Destroying,
      typeof(this).stringof
    );
    
    // Check if window exists before destroying it
    if (_window !is null) {
      _window.destroy();
      _window = null;
    }

    Logger.self.info(
      InfoMessage.Destroyed,
      typeof(this).stringof
    );
  }
}