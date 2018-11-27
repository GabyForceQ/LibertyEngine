/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/primitive/model.d)
 * Documentation:
 * Coverage:
**/
module liberty.primitive.model;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.model;
import liberty.core.engine;
import liberty.material.impl;
import liberty.model.io;
import liberty.graphics.constants;
import liberty.graphics.engine;
import liberty.primitive.vertex;

/**
 *
**/
final class PrimitiveModel : Model {
  private {
    bool hasIndices;
    bool hasTransparency;
    bool useFakeLighting;
  }

  /**
   *
  **/
  this(Material[] materials) {
    super(materials);
  }

  /**
   *
  **/
  PrimitiveModel build(PrimitiveVertex[] vertices) {
    rawModel = ModelIO.loadRawModel(vertices);
    build();
    return this;
  }

  /**
   *
  **/
  PrimitiveModel build(PrimitiveVertex[] vertices, uint[] indices) {
    hasIndices = true;
    rawModel = ModelIO.loadRawModel(vertices, indices);
    build();
    return this;
  }

  private void build() {
    CoreEngine
      .getScene()
      .getPrimitiveSystem()
      .getShader()
      .bind()
      .loadTexture(0)
      .unbind();
  }

  /**
   *
  **/
  void render() {
    if (shouldCull)
      GfxEngine.enableCulling();

    //if (hasTransparency)
    //  GfxEngine.();

    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, materials[0].getTexture().getId());

      glBindVertexArray(rawModel.getVaoID());
      glEnableVertexAttribArray(0);
      glEnableVertexAttribArray(1);
      glEnableVertexAttribArray(2);
    }

    hasIndices
      ? drawElements(GfxDrawMode.TRIANGLES, GfxVectorType.UINT, rawModel.getVertexCount())
      : drawArrays(GfxDrawMode.TRIANGLES, rawModel.getVertexCount());

    version (__OPENGL__) {
      glDisableVertexAttribArray(0);
      glDisableVertexAttribArray(1);
      glDisableVertexAttribArray(2);
      glBindVertexArray(0);

      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, 0);
    }

    //if (!hasTransparency)
    //  GfxEngine.();

    if (shouldCull)
      GfxEngine.disableCulling();
  }

  /**
   *
  **/
  bool usesIndices() pure nothrow const {
    return hasIndices;
  }

  /**
   *
  **/
  void setHasTransparency(bool transparency) {
    hasTransparency = transparency;
  }

  /**
   *
  **/
  bool getHasTransparency() {
    return hasTransparency;
  }

  /**
   *
  **/
  void setUseFakeLighting(bool isFake) {
    useFakeLighting = isFake;
  }

  /**
   *
  **/
  bool getUseFakeLighting() {
    return useFakeLighting;
  }
}