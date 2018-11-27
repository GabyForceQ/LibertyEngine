/**
 * Copyright:     Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:       $(Gabriel Gheorghe)
 * License:       $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:        $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/material/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.material.impl;

import liberty.image.format.bmp;
import liberty.core.engine;
import liberty.material.factory;
import liberty.graphics.shader;
import liberty.graphics.texture.impl;
import liberty.graphics.texture.io;

/**
 *
**/
final class Material : IDefaultMaterialsFactory {
  private {
    Texture texture;
  }

  /**
   *
  **/
  this(BMPImage image) {
    setTexture(TextureIO.loadBMP(image));
  }

  /**
   *
  **/
  this(string texturePath) {
    setTexture(TextureIO.loadTexture(texturePath));
  }

  /**
   *
  **/
  this(string[6] texturesPath) {
    texture = TextureIO.loadCubeMapTexture(texturesPath);
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
}