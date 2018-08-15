/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/window.d, _window.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.window;

import derelict.sdl2.sdl :
    SDL_Window,
    SDL_CreateWindow,
    SDL_DestroyWindow,
    SDL_WINDOWPOS_CENTERED,
    SDL_WINDOW_OPENGL,
    SDL_WINDOW_ALLOW_HIGHDPI,
    SDL_WINDOW_RESIZABLE,
    SDL_WindowFlags,
    SDL_GetWindowID;

import liberty.core.math.vector : Vector2I;
import liberty.core.logger.constants : ErrorMessage;
import liberty.core.logger.manager : Logger;
import liberty.core.system.video.renderer : Renderer;
import liberty.core.system.video.context : VideoContext;
import liberty.core.system.platform : Platform;
import liberty.core.system.surface : Surface;

/**
 *
**/
final class Window {
  private {
    SDL_Window* _window;
    Platform _platform;
    Surface _surface;
    VideoContext _videoContext;
    Vector2I _size = Vector2I(1280, 1024);
    uint _id;
    bool _surfaceNeedRenew;
  }
  
  /**
   *
  **/
  this(Platform platform, SDL_WindowFlags flags) {
    // Bind platform to this
    _platform = platform;

    // If you use OpenGL and SDL_WINDOW_OPENGL is not set
    // Then throw OpenGLContextNotFound error
    version (__OpenGL__) {
      if (!(flags & SDL_WINDOW_OPENGL)) {
        Logger.self.error(ErrorMessage.OpenGLContextNotFound, typeof(this).stringof);
      }
    }

    // Set window flags
    flags |= SDL_WINDOW_ALLOW_HIGHDPI;
    flags |= SDL_WINDOW_RESIZABLE;

    // Create the application window
    _window = SDL_CreateWindow(
      "Liberty Engine v0.0.15-beta.1",
      SDL_WINDOWPOS_CENTERED,
      SDL_WINDOWPOS_CENTERED,
      _size.x,
      _size.y,
      flags
    );
    if (_window is null) {
      Logger.self.error("Coudn't be created", typeof(this).stringof);
    }

    // Store the window id
    _id = SDL_GetWindowID(_window);

    // Attach this window to the renderer
    Renderer.self.window = this;

    // Create a new video context using this window
    _videoContext = new VideoContext(this);

    Logger.self.info("Created", typeof(this).stringof);
  }

  ~this() {
    if (_videoContext !is null) {
      _videoContext.destroy();
      _videoContext = null;
    }
    if (_window !is null) {
      SDL_DestroyWindow(_window);
      _window = null;
    }
  }

  /**
   *
  **/
  Vector2I getSize() pure nothrow const @safe {
    return _size;
  }

  /**
   * Returns the current platform.
  **/
  Platform getPlatform() {
    return _platform;
  }

  /**
   * Returns video context.
  **/
  VideoContext getVideoContext() {
    return _videoContext;
  }

  /**
   * Returns a handle to the current window.
  **/
  package SDL_Window* getHandle() {
    return _window;
  }

  private bool _hasValidSurface() { 
    return !_surfaceNeedRenew && _surface !is null; 
  }
}