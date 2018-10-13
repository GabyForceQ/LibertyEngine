/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.model.impl;

import liberty.core.material.impl : Material;
import liberty.core.model.raw : RawModel;

/**
 *
**/
abstract class Model {
  protected {
    RawModel rawModel;
    Material material;
  }

  /**
   *
  **/
  this(Material material) {
    this.material = material;
  }

  /**
   *
  **/
  RawModel getRawModel() pure nothrow {
    return rawModel;
  }

  /**
   *
  **/
  Material getMaterial() pure nothrow {
    return material;
  }
}