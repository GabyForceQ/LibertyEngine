/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/surface.d, _surface.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.surface;

import derelict.sdl2.sdl :
  SDL_Rect,
  SDL_Surface,
  SDL_PixelFormat,
  SDL_FreeSurface,
  SDL_CreateRGBSurface, 
  SDL_CreateRGBSurfaceFrom,
  SDL_ConvertSurface,
  SDL_LockSurface, 
  SDL_UnlockSurface,
  SDL_GetError, 
  SDL_ClearError,
  SDL_BlitSurface, 
  SDL_BlitScaled,
  SDL_GetRGBA, 
  SDL_MapRGBA, 
  SDL_SetColorKey,
  SDL_TRUE,
  SDL_FALSE;

import liberty.core.system.constants : Owned;
import liberty.core.system.platform : Platform;
import liberty.core.logger.manager : Logger;
import liberty.graphics.color : Color;

/**
 *
**/
final class Surface {
  private {
    SDL_Surface* _surfaceHandle;
    Platform _platform;
    Owned _handleOwned;
    bool _locked;
  }

  /**
   *
  **/
  this(
    Platform platform, 
    SDL_Surface* surface, 
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
    _surfaceHandle = SDL_CreateRGBSurface(
      0, 
      width, 
      height, 
      depth, 
      mask.r, 
      mask.g, 
      mask.b, 
      mask.a
    );
    if (_surfaceHandle is null) {
      Logger.self.error(
        "Failed to create the RGB surface",
        typeof(this).stringof
      );
    }
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
    _surfaceHandle = SDL_CreateRGBSurfaceFrom(
      pixels, 
      width, 
      height, 
      depth, 
      pitch, 
      mask.r, 
      mask.g, 
      mask.b, 
      mask.a
    );
    if (_surfaceHandle is null) {
      Logger.self.error(
        "Failed to create the RGB surface",
        typeof(this).stringof
      );
    }
    _handleOwned = Owned.Yes;
  }

  ~this() @trusted {
    if (_surfaceHandle !is null) {
      if (_handleOwned == Owned.Yes) {
        SDL_FreeSurface(_surfaceHandle);
      }
      _surfaceHandle = null;
    }
  }

  /**
   *
  **/
  Surface convert(const SDL_PixelFormat* newFormat) @trusted {
    // Covert the surface internally
    SDL_Surface* surface = SDL_ConvertSurface(
      _surfaceHandle,
      newFormat,
      0
    );
    if (surface is null) {
      Logger.self.error(
        "Failed to convert the surface to the new format",
        typeof(this).stringof
      );
    }

    // Surface shoudn't be equal with this handle
    if (surface != _surfaceHandle) {
      Logger.self.error(
        "New surface should not be the same as surface handle",
        typeof(this).stringof
      );
    }

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
    const state = SDL_LockSurface(_surfaceHandle);
    if (state != SDL_FALSE) {
      Logger.self.error(
        "Failed to lock the surface",
        typeof(this).stringof
      );
    }
    _locked = true;
  }

  /**
   * Unlock the surface.
  **/
  void unlock() @trusted {
    const state = SDL_UnlockSurface(_surfaceHandle);
    if (state != SDL_FALSE) {
      Logger.self.error(
        "Failed to unlock the surface",
        typeof(this).stringof
      );
    }
    _locked = false;
  }

  /**
   * Returns surface pixel format.
  **/
  SDL_PixelFormat* getPixelFormat() pure nothrow @safe {
    return _surfaceHandle.format;
  }

  /**
   *
  **/
  Color rgba(int x, int y) @trusted {
    // x should be in interval [0, width)
    if (x < 0 || x >= getWidth()) {
      assert(0, "Out of image!");
    }

    // y should be in interval [0, height)
    if (y < 0 || y >= getHeight()) {
      assert(0, "Out of image!");
    }

    // Init data
    SDL_PixelFormat* format = _surfaceHandle.format;
    ubyte* pixels = cast(ubyte*)_surfaceHandle.pixels;
    immutable int pitch = _surfaceHandle.pitch;
    uint* pixel = cast(uint*)(pixels + y * pitch + x * format.BytesPerPixel);
    Color mask;

    // Fill color channels with values.
    SDL_GetRGBA(
      *pixel, 
      format, 
      &mask.r, 
      &mask.g, 
      &mask.b, 
      &mask.a
    );

    // Return the new color
    return mask;
  }

  /**
   *
  **/
  void setColorKey(bool enabled,uint key) @trusted {
    const state = SDL_SetColorKey(
      _surfaceHandle, 
      enabled ? SDL_TRUE : SDL_FALSE, 
      key
    );
    if (state != SDL_FALSE) {
      Logger.self.error(
        "Failed to set color key",
        typeof(this).stringof
      );
    }
  }

  /**
   *
  **/
  void setColorKey(bool enabled, Color mask) @trusted {
    const key = SDL_MapRGBA(
      _surfaceHandle.format, 
      mask.r, 
      mask.g, 
      mask.b, 
      mask.a
    );
    this.setColorKey(enabled, key);
  }

  /**
   * Perform a fast surface copy to a destination surface.
  **/
  void blit(
    SDL_Surface* source, 
    SDL_Rect srcRect, 
    SDL_Rect dstRect
  ) @trusted {
    if (!_locked) {
      const res = SDL_BlitSurface(
        source, 
        &srcRect, 
        _surfaceHandle, 
        &dstRect
      );
      if (res != SDL_FALSE) {
        Logger.self.error(
          "Failed to blit surface",
          typeof(this).stringof
        );
      }
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
    SDL_Surface* source, 
    SDL_Rect srcRect, 
    SDL_Rect dstRect
  ) @trusted {
    if (!_locked) {
      const state = SDL_BlitScaled(
        source, 
        &srcRect, 
        _surfaceHandle, 
        &dstRect
      );
      if (state != SDL_FALSE) {
        Logger.self.error(
          "Failed to blit scaled",
          typeof(this).stringof
        );
      }
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
  package SDL_Surface* getHandle() pure nothrow @safe {
    return _surfaceHandle;
  }
}