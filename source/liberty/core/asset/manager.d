/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/asset/manager.d, _manager.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.asset.manager;

import derelict.assimp3.assimp;

import liberty.core.logger.impl : Logger;

/**
 *
**/
final class AssetManager {

  /**
   *
  **/
  static void initialize() {
    try {
      DerelictASSIMP3.load();
    } catch (Exception e) {
      Logger.error(
        "Failed to load Assimp library",
        typeof(this).stringof
      );
    }
  }
}