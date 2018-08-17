/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/platform/wrapper/util.d, _util.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.platform.wrapper.util;

import derelict.sdl2.sdl :
  DerelictSDL2,
  SharedLibVersion, 
  SDL_Init,
  SDL_INIT_EVERYTHING,
  SDL_GetError,
  SDL_ClearError;

import liberty.core.system;

import liberty.core.utils.singleton : Singleton;
import liberty.core.logger.manager : Logger;

pragma (inline, true) :

/**
 *
**/
final class PlatformUtil : Singleton!PlatformUtil {
  /**
   *
  **/
  void loadLibrary() {
    try {
      DerelictSDL2.load(
        SharedLibVersion(2, 0, 8)
      );
    } catch (Exception e) {
      throwPlatformException(
        PlatformErrors.FailedToLoadLibrary,
      );
    }
    SDL_Init(
      SDL_INIT_EVERYTHING
    );
  }

  package(liberty.core.system) void throwPlatformException(string call_name) {
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