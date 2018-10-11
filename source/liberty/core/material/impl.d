/**
 * Copyright:     Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:       $(Gabriel Gheorghe)
 * License:       $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:        $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/material/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.material.impl;

import liberty.core.engine : CoreEngine;
import liberty.graphics.shader.impl : GfxShader;
import liberty.graphics.texture.impl : Texture;

/**
 *
**/
final class Material {
  private {
    Texture texture;
  }

  /**
   *
  **/
  this() {
 
  }

  /**
   *
  **/
  void setTexture(Texture texture) pure nothrow {
    this.texture = texture;
  }

  /**
   *
  **/
  Texture getTexture() pure nothrow {
    return texture;
  }

  /**
   *
  **/
  static Material getDefault() {
    return new Material();
  }
}