/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/image/manager.d, _manager.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.image.manager;

import derelict.freeimage.freeimage :
    DerelictFI, FreeImage_GetVersion, 
    FreeImage_GetCopyrightMessage;

import liberty.core.logger.impl : Logger;
import liberty.core.image.loader : ImageLoader;

/**
 *
**/
final class ImageManager {
  /**
   * Loads the FreeImage library.
   * Starts the ImageLoader service.
  **/
  static void load() {
    try {
      DerelictFI.load();
    } catch (Exception e) {
      Logger.error(
        "Failed to load FreeImage library",
        typeof(this).stringof
      );
    }
  }

	/**
   *
  **/
  static const(char)[] version_() {
    import std.string : fromStringz;
    
    const(char)* versionZ = FreeImage_GetVersion();
    return fromStringz(versionZ);
  }
    
	/**
   *
  **/
  static const(char)[] copyright_()  {
    import std.string : fromStringz;

    const(char)* copyrightZ = FreeImage_GetCopyrightMessage();
    return fromStringz(copyrightZ);
  }
}