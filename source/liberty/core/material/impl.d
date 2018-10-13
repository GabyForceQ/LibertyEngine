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

    Texture backgroundTexture;
    Texture rTexture;
    Texture gTexture;
    Texture bTexture;
    Texture blendMap;
  }

  /**
   *
  **/
  this() {
 
  }

  /**
   *
  **/
  this(Texture backgroundTexture, Texture rTexture, Texture gTexture, Texture bTexture, Texture blendMap) {
    this.backgroundTexture = backgroundTexture;
    this.rTexture = rTexture;
    this.gTexture = gTexture;
    this.bTexture = bTexture;
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

  void setBackgroundTexture(Texture texture) {
    backgroundTexture = texture;
  }

  void setRTexture(Texture texture) {
    rTexture = texture;
  }
  
  void setGTexture(Texture texture) {
    gTexture = texture;
  }
  
  void setBTexture(Texture texture) {
    bTexture = texture;
  }

  void setBlendMap(Texture texture) {
    blendMap = texture;
  }

  Texture getBackgroundTexture() {
    return backgroundTexture;
  }

  Texture getRTexture() {
    return rTexture;
  }
  
  Texture getGTexture() {
    return gTexture;
  }
  
  Texture getBTexture() {
    return bTexture;
  }

  Texture getBlendMap() {
    return blendMap;
  }
}