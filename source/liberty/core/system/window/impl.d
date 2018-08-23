/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/window/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.window.impl;

import liberty.core.system.window.wrapper;
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
    WindowHandler _windowHandle;
    Platform _platform;
    Surface _surface;
    VideoContext _videoContext;
    Vector2I _size;
    uint _id;
    bool _surfaceNeedRenew;
  }
  
  /**
   *
  **/
  this(Platform platform, Vector2I size, WindowFlags flags) {
    // Bind platform to this
    _platform = platform;

    // Set window size
    _size = size;

    // If you use OpenGL and WindowFlags.OpenGL is not set
    // Then throw OpenGLContextNotFound error
    version (__OpenGL__) {
      if (!(flags & WindowFlags.OpenGL)) {
        Logger.self.error(ErrorMessage.OpenGLContextNotFound, typeof(this).stringof);
      }
    }

    // Set window flags
    flags |= WindowFlags.AllowHighDPI;
    flags |= WindowFlags.Resizable;

    // Create the application window
    _windowHandle = WindowUtil.self.createWindow(
      "Liberty Engine v0.0.15-beta.1",
      WindowPosition.Centered,
      WindowPosition.Centered,
      _size.x,
      _size.y,
      flags
    );

    // Store the window id
    _id = WindowUtil.self.getWindowId(
      _windowHandle
    );

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
    WindowUtil.self.destroyWindow(
      _windowHandle
    );
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
  package(liberty.core.system) WindowHandler getHandle() {
    return _windowHandle;
  }

  private bool _hasValidSurface() { 
    return !_surfaceNeedRenew && _surface !is null; 
  }
}