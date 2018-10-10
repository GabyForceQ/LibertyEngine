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
import liberty.graphics.shader : GfxShader;
import liberty.graphics.shaders : CORE_VERTEX, CORE_FRAGMENT;
import liberty.graphics.texture.impl : Texture;

/**
 *
**/
final class Material {
  private {
    GfxShader shader; 
    Texture texture;
  }

  /**
   *
  **/
  this() {
    shader = (CoreEngine.getScene().shaderList["CoreShader"] = new GfxShader())
      .compileShaders(CORE_VERTEX, CORE_FRAGMENT)
      .linkShaders()
      .bindAttribute("lPosition")
      .bindAttribute("lNormal")
      .bindAttribute("lTexCoord")
      .bind()
      .addUniform("uProjectionMatrix")
      .addUniform("uViewMatrix")
      .addUniform("uModelMatrix")
      .addUniform("uMaterial.diffuse") 
      .addUniform("uMaterial.specular")
      .addUniform("uMaterial.shininess")
      .addUniform("uLight.position")
      .addUniform("uLight.direction")
      .addUniform("uLight.cutOff")
      .addUniform("uLight.outerCutOff")
      .addUniform("uLight.ambient")
      .addUniform("uLight.diffuse")
      .addUniform("uLight.specular")
      .addUniform("uLight.constant")
      .addUniform("uLight.linear")
      .addUniform("uLight.quadratic")
      .unbind();
  }

  ~this() {
    if (shader !is null) {
      shader.destroy();
      shader = null;
    }
  }

  /**
   *
  **/
  GfxShader getShader() pure nothrow {
    return shader;
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