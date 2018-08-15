/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/surface/wrapper/util.d, _util.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.surface.wrapper.util;

import derelict.sdl2.sdl :
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

import liberty.core.system.surface.wrapper.types :
  SurfaceHandler, 
  PixelFormat, 
  SurfaceSuccess,
  Rect;

import liberty.core.system.surface.wrapper.errors:
  SurfaceException,
  SurfaceErrors;

import liberty.core.utils.singleton : Singleton;
import liberty.graphics.vertex : Color;

pragma (inline, true) :

/**
 *
**/
final class SurfaceUtil : Singleton!SurfaceUtil {
  /**
   * SDL2 surface wrapper function.
  **/
  void freeSurface(
    SurfaceHandler surfaceHandler
  ) @trusted {
    SDL_FreeSurface(
      surfaceHandler
    );
  }

  /**
   * SDL2 surface wrapper function.
  **/
  SurfaceHandler createRGBSurface(
    int width, 
    int height, 
    int depth, 
    Color mask
  ) @trusted {
    SurfaceHandler res = SDL_CreateRGBSurface(
      0, 
      width, 
      height, 
      depth, 
      mask.r, 
      mask.g, 
      mask.b, 
      mask.a
    );
    if (res is null) {
      throwException(SurfaceErrors.FailedToCreateRGBSurface);
    }
    return res;
  }

  /**
   * SDL2 surface wrapper function.
  **/
  SurfaceHandler createRGBSurfaceFrom(
    void* pixels, 
    int width, 
    int height, 
    int depth, 
    int pitch, 
    Color mask
  ) @trusted {
    SurfaceHandler res = SDL_CreateRGBSurfaceFrom(
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
    if (res is null) {
      throwException(SurfaceErrors.FailedToCreateRGBSurface);
    }
    return res;
  }

  /**
   * SDL2 surface wrapper function.
  **/
  SurfaceHandler convertSurface(
    SurfaceHandler surfaceHandler, 
    const PixelFormat pixelFormat
  ) @trusted {
    SurfaceHandler res = SDL_ConvertSurface(
      surfaceHandler, 
      pixelFormat, 
      0
    );
    if (res is null) {
      throwException(SurfaceErrors.FailedToConvertSurface);
    }
    return res;
  }

  /**
   * SDL2 surface wrapper function.
  **/
  void lockSurface(
    SurfaceHandler surfaceHandle
  ) @trusted {
    const res = SDL_LockSurface(surfaceHandle);
    if (res != SurfaceSuccess) {
      throwException(SurfaceErrors.FailedToLockSurface);
    }
  }

  /**
   * SDL2 surface wrapper function.
  **/
  void unlockSurface(
    SurfaceHandler surfaceHandle
  ) @trusted {
    const res = SDL_UnlockSurface(surfaceHandle);
    if (res != SurfaceSuccess) {
      throwException(SurfaceErrors.FailedToUnlockSurface);
    }
  }

  /**
   * SDL2 surface wrapper function.
   * Perform a fast surface copy to a destination surface.
  **/
  void blitSurface(
    SurfaceHandler sourceSurfaceHandle,
    SurfaceHandler destinationSurfaceHandle,
    Rect sourceRect,
    Rect destinationRect
  ) @trusted {
    const res = SDL_BlitSurface(
      sourceSurfaceHandle, 
      &sourceRect, 
      destinationSurfaceHandle, 
      &destinationRect
    );
    if (res != SurfaceSuccess) {
      throwException(SurfaceErrors.FailedToBlitSurface);
    }
  }

  /**
   * SDL2 surface wrapper function.
   * Perform a scaled surface copy to a destination surface.
  **/
  void blitScaled(
    SurfaceHandler sourceSurfaceHandle,
    SurfaceHandler destinationSurfaceHandle,
    Rect sourceRect,
    Rect destinationRect
  ) @trusted {
    const res = SDL_BlitScaled(
      sourceSurfaceHandle, 
      &sourceRect, 
      destinationSurfaceHandle, 
      &destinationRect
    );
    if (res != SurfaceSuccess) {
      throwException(SurfaceErrors.FailedToBlitScaled);
    }
  }

  /**
   *
  **/
  void doGetRGBA(
    uint* pixelData,
    const PixelFormat pixelFormat,
    ref Color mask
  ) @trusted {
    SDL_GetRGBA(
      *pixelData, 
      pixelFormat, 
      &mask.r, 
      &mask.g, 
      &mask.b, 
      &mask.a
    );
  }

  /**
   *
  **/
  void setColorKey(
    SurfaceHandler surfaceHandle,
    bool enabled,
    uint key
  ) @trusted {
    const res = SDL_SetColorKey(
      surfaceHandle, 
      enabled ? SDL_TRUE : SDL_FALSE, 
      key
    );
    if (res != SurfaceSuccess) {
      throwException(SurfaceErrors.FailedToSetColorKey);
    }
  }

  /**
   *
  **/
  uint mapRGBA(
    const PixelFormat pixelFormat,
    Color mask
  ) @trusted {
    const res = SDL_MapRGBA(
      pixelFormat, 
      mask.r, 
      mask.g, 
      mask.b, 
      mask.a
    );
    return res;
  }

  private void throwException(string name) @trusted {
    import std.format : format;
    string message = format("%s failed: %s", name, getErrorString());
    throw new SurfaceException(message);
  }

  /**
   * Returns last SDL error and clears it.
  **/
  const(char)[] getErrorString() @trusted {
    import std.string : fromStringz;
    const(char)* message = SDL_GetError();
    SDL_ClearError();
    return fromStringz(message);
  }
}