/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/window/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.window.impl;

import derelict.sdl2.sdl :
  SDL_Window,
  SDL_CreateWindow,
  SDL_DestroyWindow,
  SDL_GetWindowID,
  SDL_WindowFlags;

import liberty.core.math.vector : Vector2I;
import liberty.core.logger.constants : ErrorMessage;
import liberty.core.logger.constants : InfoMessage;
import liberty.core.logger.manager : Logger;
import liberty.core.system.context : VideoContext;
import liberty.core.system.platform : Platform;
import liberty.core.system.surface : Surface;
import liberty.core.system.window.constants : WindowFlags, WindowPosition;
import liberty.graphics.engine : GraphicsEngine;

/**
 *
**/
final class Window {
  private {
    SDL_Window* windowHandle;
    Platform platform;
    Surface surface;
    VideoContext videoContext;
    Vector2I size;
    uint id;
    bool surfaceNeedRenew;
  }
  
  /**
   *
  **/
  this(Platform platform, Vector2I size, WindowFlags flags) {
    Logger.self.info(
      InfoMessage.Creating,
      typeof(this).stringof
    );

    // Bind platform to this
    this.platform = platform;

    // Set window size
    this.size = size;

    // If you use OpenGL and WindowFlags.OpenGL is not set
    // Then throw OpenGLContextNotFound error
    if (!(flags & WindowFlags.OpenGL)) {
      Logger.self.error(
        ErrorMessage.OpenGLContextNotFound, 
        typeof(this).stringof
      );
    }

    // Set window flags
    flags |= WindowFlags.AllowHighDPI;
    flags |= WindowFlags.Resizable;

    // Create window internally
    this.windowHandle = SDL_CreateWindow(
      "Liberty Engine v0.0.15-beta.1",
      WindowPosition.Centered,
      WindowPosition.Centered,
      this.size.x,
      this.size.y,
      cast(SDL_WindowFlags)flags
    );

    // Check if window is created
    if (this.windowHandle is null) {
      Logger.self.error(
        "Failed to create window", 
        typeof(this).stringof
      );
    }

    // Store the window id
    this.id = this.getWindowId();

    // Attach this window to the renderer
    GraphicsEngine.self.attachWindow(this);

    // Create a new video context using this window
    this.videoContext = new VideoContext(this);

    Logger.self.info(
      InfoMessage.Created,
      typeof(this).stringof
    );
  }

  ~this() {
    Logger.self.info(
      InfoMessage.Destroying,
      typeof(this).stringof
    );

    if (this.windowHandle !is null) {
      SDL_DestroyWindow(windowHandle);
      this.windowHandle = null;
    } else {
      Logger.self.warning(
        "You are trying to destory a non-existent window",
        typeof(this).stringof
      );
    }

    if (this.videoContext !is null) {
      this.videoContext.destroy();
      this.videoContext = null;
    }

    Logger.self.info(
      InfoMessage.Destroyed,
      typeof(this).stringof
    );
  }

  /**
   *
  **/
  Vector2I getSize() pure nothrow const @safe {
    return this.size;
  }

  /**
   * Returns the current platform.
  **/
  Platform getPlatform() {
    return this.platform;
  }

  /**
   * Returns video context.
  **/
  VideoContext getVideoContext() {
    return this.videoContext;
  }

  /**
   * Returns a handle to the current window.
  **/
  SDL_Window* getHandle() {
    return this.windowHandle;
  }

  private bool _hasValidSurface() { 
    return !this.surfaceNeedRenew && this.surface !is null; 
  }

  private uint getWindowId() @trusted {
    if (this.windowHandle is null) {
      Logger.self.error(
        "Failed to access window. Window does not exist", 
        typeof(this).stringof
      );
    }
    return SDL_GetWindowID(windowHandle);
  }
}