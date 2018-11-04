/**
 * Copyright:     Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:       $(Gabriel Gheorghe)
 * License:       $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:        $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/material/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.material.impl;

import liberty.core.engine : CoreEngine;
import liberty.graphics.shader.impl : Shader;
import liberty.graphics.texture.impl : Texture;

import liberty.resource.manager : ResourceManager;

/**
 *
**/
final class Material {
  private {
    Texture texture;

    static Material defaultMaterial;
  }

  /**
   *
  **/
  this(string texturePath) {
    setTexture(ResourceManager.loadTexture(texturePath));
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
  static void initializeMaterials() {
    defaultMaterial = new Material("res/textures/default.bmp");
  }

  /**
   *
  **/
  static Material getDefault() {
    return defaultMaterial;
  }
}