/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/window/wrapper/util.d, _util.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.window.wrapper.util;

import derelict.sdl2.sdl :
  SDL_CreateWindow,
  SDL_DestroyWindow,
  SDL_GetWindowID,
  SDL_WindowFlags;

import liberty.core.system.window.wrapper.constants;
import liberty.core.system.window.wrapper.errors;
import liberty.core.system.window.wrapper.types;
import liberty.core.utils.singleton : Singleton;
import liberty.core.logger.manager : Logger;

pragma (inline, true) :

/**
 *
**/
final class WindowUtil : Singleton!WindowUtil {
  /**
   *
  **/
  WindowHandler createWindow(
    string title,
    WindowPosition xPosition,
    WindowPosition yPosition,
    int width,
    int height,
    WindowFlags flags
  ) @trusted {
    import std.string : toStringz;

    // Create window internally
    WindowHandler res = SDL_CreateWindow(
      title.toStringz(),
      xPosition,
      yPosition,
      width,
      height,
      cast(SDL_WindowFlags)flags
    );

    // Check if window is created
    if (res is null) {
      Logger.self.error(
        WindowErrors.FailedToCreateWindow, 
        typeof(this).stringof
      );
    }

    // Return the window handler
    return res;
  }

  /**
   *
  **/
  void destroyWindow(
    WindowHandler windowHandle
  ) @trusted {
    if (windowHandle !is null) {
      SDL_DestroyWindow(windowHandle);
      windowHandle = null;
    } else {
      Logger.self.warning(
        "You are trying to destory a non-existent window",
        typeof(this).stringof
      );
    }
  }

  /**
   *
  **/
  uint getWindowId(
    WindowHandler windowHandle
  ) @trusted {
    if (windowHandle is null) {
      Logger.self.error(
        WindowErrors.FiledToAccessWindow, 
        typeof(this).stringof
      );
    }
    return SDL_GetWindowID(windowHandle);
  }
}