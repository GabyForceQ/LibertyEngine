/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/surface/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.surface.impl;

import liberty.core.system.surface.wrapper.types : 
  SurfaceHandler, 
  PixelFormat, 
  Rect;

import liberty.core.system.constants : Owned;
import liberty.core.system.platform : Platform;
import liberty.core.system.surface.wrapper.util : SurfaceUtil;
import liberty.core.logger.manager : Logger;
import liberty.graphics.vertex : Color;

/**
 *
**/
final class Surface {
  private {
    SurfaceHandler _surfaceHandle;
    Platform _platform;
    Owned _handleOwned;
    bool _locked;
  }

  /**
   *
  **/
  this(
    Platform platform, 
    SurfaceHandler surface, 
    Owned owned
  ) pure @trusted
  in {
    assert (surface !is null, "Surface is null");
  } do {
    _platform = platform;
    _surfaceHandle = surface;
    _handleOwned = owned;
  }

  /**
   *
  **/
  this(
    Platform platform, 
    int width, 
    int height, 
    int depth, 
    Color mask
  ) @trusted {
    _platform = platform;
    _surfaceHandle = SurfaceUtil.self.createRGBSurface(
      width, 
      height, 
      depth, 
      mask
    );
    _handleOwned = Owned.Yes;
  }

  /**
   *
  **/
  this(
    Platform platform, 
    void* pixels, 
    int width, 
    int height, 
    int depth, 
    int pitch, 
    Color mask
  ) @trusted {
    _platform = platform;
    _surfaceHandle = SurfaceUtil.self.createRGBSurfaceFrom(
      pixels, 
      width, 
      height, 
      depth, 
      pitch, 
      mask
    );
    _handleOwned = Owned.Yes;
  }

  ~this() @trusted {
    if (_surfaceHandle !is null) {
      if (_handleOwned == Owned.Yes) {
        SurfaceUtil.self.freeSurface(
          _surfaceHandle
        );
      }
      _surfaceHandle = null;
    }
  }

  /**
   *
  **/
  Surface convert(
    const PixelFormat newFormat
  ) @trusted {
    // Covert the surface internally
    SurfaceHandler surface = SurfaceUtil.self.convertSurface(
      _surfaceHandle, 
      newFormat
    );

    // Surface shoudn't be equal with this handle
    assert (
      surface != _surfaceHandle, 
      "It should not be the same handle!"
    );

    // Returns the converted surface
    return new Surface(_platform, surface, Owned.Yes);
  }

  /**
   *
  **/
  Surface clone() @safe {
    return convert(getPixelFormat());
  }

  /**
   * Returns surface width.
  **/
  int getWidth() pure nothrow const @safe {
    return _surfaceHandle.w;
  }

  /**
   * Returns surface height.
  **/
  int getHeight() pure nothrow const @safe {
    return _surfaceHandle.h;
  }

  /**
   * Returns surface pixels.
  **/
  ubyte* getPixels() pure nothrow const @trusted {
    return cast(ubyte*)_surfaceHandle.pixels;
  }

  /**
   * Returns surface pitch.
  **/
  size_t getPitch() pure nothrow const @safe {
    return _surfaceHandle.pitch;
  }

  /**
   * Lock the surface.
  **/
  void lock() @trusted {
    SurfaceUtil.self.lockSurface(_surfaceHandle);
    _locked = true;
  }

  /**
   * Unlock the surface.
  **/
  void unlock() @trusted {
    SurfaceUtil.self.unlockSurface(_surfaceHandle);
    _locked = false;
  }

  /**
   * Returns surface pixel format.
  **/
  PixelFormat getPixelFormat() pure nothrow @safe {
    return _surfaceHandle.format;
  }

  /**
   *
  **/
  Color rgba(
    int x, 
    int y
  ) @trusted {
    // x should be in interval [0, width)
    if (x < 0 || x >= getWidth()) {
      assert(0, "Out of image!");
    }

    // y should be in interval [0, height)
    if (y < 0 || y >= getHeight()) {
      assert(0, "Out of image!");
    }

    // Init data
    PixelFormat format = _surfaceHandle.format;
    ubyte* pixels = cast(ubyte*)_surfaceHandle.pixels;
    immutable int pitch = _surfaceHandle.pitch;
    uint* pixel = cast(uint*)(pixels + y * pitch + x * format.BytesPerPixel);
    Color mask;

    // Fill color channels with values.
    SurfaceUtil.self.doGetRGBA(
      pixel,
      format,
      mask
    );

    // Return the new color
    return mask;
  }

  /**
   *
  **/
  void setColorKey(
    bool enabled,
    uint key
  ) @trusted {
    SurfaceUtil.self.setColorKey(
      _surfaceHandle,
      enabled,
      key
    );
  }

  /**
   *
  **/
  void setColorKey(
    bool enabled, 
    Color mask
  ) @trusted {
    const key = SurfaceUtil.self.mapRGBA(
      _surfaceHandle.format,
      mask
    );
    this.setColorKey(
      enabled, 
      key
    );
  }

  /**
   * Perform a fast surface copy to a destination surface.
  **/
  void blit(
    SurfaceHandler source, 
    Rect srcRect, 
    Rect dstRect
  ) @trusted {
    if (!_locked) {
      SurfaceUtil.self.blitSurface(
        source,
        _surfaceHandle,
        srcRect,
        dstRect
      );
    } else {
      Logger.self.warning(
        "The surface is locked. Function call does noething",
        typeof(this).stringof
      );
    }
  }
  
  /**
   * Perform a scaled surface copy to a destination surface.
  **/
  void blitScaled(
    SurfaceHandler source, 
    Rect srcRect, 
    Rect dstRect
  ) @trusted {
    if (!_locked) {
      SurfaceUtil.self.blitScaled(
        source,
        _surfaceHandle,
        srcRect,
        dstRect
      );
    } else {
      Logger.self.warning(
        "The surface is locked. Function call does noething",
        typeof(this).stringof
      );
    }
  }

  /**
   * Returns a handle to the current surface.
  **/
  package SurfaceHandler getHandle() pure nothrow @safe {
    return _surfaceHandle;
  }
}