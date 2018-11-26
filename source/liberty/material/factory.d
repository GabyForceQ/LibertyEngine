/**
 * Copyright:     Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:       $(Gabriel Gheorghe)
 * License:       $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:        $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/material/factory.d)
 * Documentation:
 * Coverage:
**/
module liberty.material.factory;

import liberty.material.impl;

/**
 *
**/
interface IDefaultMaterialsFactory {
  private {
    static Material defaultMaterial;
  }

  /**
   *
  **/
  static void initializeMaterials() {
    defaultMaterial = new Material("res/textures/default2.bmp");
  }

  /**
   *
  **/
  static Material getDefault() nothrow {
    return defaultMaterial;
  }
}