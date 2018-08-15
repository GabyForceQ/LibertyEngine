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

import liberty.core.utils : Singleton;
import liberty.core.manager : ManagerBody;
import liberty.core.logger.meta : ExceptionConstructor;
import liberty.core.image.loader : ImageLoader;

/**
 *
**/
class ImageException : Exception {
  mixin(ExceptionConstructor);
}

/**
 *
**/
final class ImageManager : Singleton!ImageManager {
  mixin(ManagerBody);

  /**
   * Loads the FreeImage library.
   * Starts the ImageLoader service.
   * Throws $(D ImageException) on error.
  **/
  private static immutable startBody = q{
    try {
      DerelictFI.load();
    } catch (Exception e) {
      throw new ImageException(e.msg);
    }
    ImageLoader.self.startService();
  };

  /**
   * Stops the ImageLoader service.
  **/
  private static immutable stopBody = q{
    ImageLoader.self.stopService();
  };

	/**
   *
  **/
  const(char)[] version_() {
    import std.string : fromStringz;
    
    // Check if service is running
    if (checkService()) {
      const(char)* versionZ = FreeImage_GetVersion();
      return fromStringz(versionZ);
    }
    
    return null;
  }
    
	/**
   *
  **/
  const(char)[] copyright_()  {
    import std.string : fromStringz;

    // Check if service is running
    if (checkService()) {
      const(char)* copyrightZ = FreeImage_GetCopyrightMessage();
      return fromStringz(copyrightZ);
    }

    return null;
  }
}