/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/skybox/texture.d)
 * Documentation:
 * Coverage:
**/
module liberty.skybox.texture;

/**
 *
**/
final class SkyboxTexture {
  private {
    int width;
    int height;
    byte[] buffer;
  }

  /**
   *
  **/
  this(in byte[] buffer, int width, int height) {
    this.buffer = buffer;
    this.width = width;
    this.height = height;
  }

  /**
   *
  **/
  int getWidth() pure nothrow const {
    return width;
  }

  /**
   *
  **/
  int getHeight() pure nothrow const {
    return height;
  }

  /**
   *
  **/
  byte[] getBuffer() pure nothrow const {
    return buffer;
  }

  package void decodeTextureFile(string path) {
    try {

    } catch (Exception e) {

    }
  }
}