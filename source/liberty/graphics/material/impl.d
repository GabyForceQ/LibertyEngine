/**
 * Copyright:     Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:       $(Gabriel Gheorghe)
 * License:       $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:        $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/material/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.material.impl;

import liberty.core.engine;
import liberty.graphics.shader;
import liberty.graphics.texture.impl;
import liberty.resource;

/**
 *
**/
final class Material {
  private {
    Texture texture;
    Texture cubeMapTextures;

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
  this(string[6] texturesPath) {
    cubeMapTextures = ResourceManager.loadCubeMapTexture(texturesPath);
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
  Texture getCubeMapTextures() pure nothrow {
    return cubeMapTextures;
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
  static Material getDefault() {
    return defaultMaterial;
  }
}