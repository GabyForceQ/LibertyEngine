/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model/generic.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.model.generic;

version (__OPENGL__)
  import derelict.opengl;

import liberty.core.model.impl : Model;
import liberty.core.engine : CoreEngine;
import liberty.core.resource.manager : ResourceManager;
import liberty.core.material.impl : Material;
import liberty.graphics.constants : GfxDrawMode, GfxVectorType;
import liberty.graphics.engine : GfxEngine;
import liberty.graphics.util : GfxUtil;
import liberty.graphics.vertex : GenericVertex;

/**
 *
**/
final class GenericModel : Model {
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
  GenericModel build(GenericVertex[] vertices) {
    rawModel = ResourceManager.loadRawModel(vertices);
    build();
    return this;
  }

  /**
   *
  **/
  GenericModel build(GenericVertex[] vertices, uint[] indices) {
    hasIndices = true;
    rawModel = ResourceManager.loadRawModel(vertices, indices);
    build();
    return this;
  }

  private void build() {
    CoreEngine.getScene().getGenericShader().loadTexture(0);
  }

  /**
   *
  **/
  void draw() {
    CoreEngine.getScene().getGenericShader().bind();

    if (shouldCull)
      GfxEngine.enableCulling();

    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, materials[0].getTexture().getId());
    }

    if (hasTransparency)
      GfxEngine.disableCulling();

    version (__OPENGL__) {
      glBindVertexArray(rawModel.getVaoID());
      glEnableVertexAttribArray(0);
      glEnableVertexAttribArray(1);
      glEnableVertexAttribArray(2);
    }

    if (hasIndices)
      GfxUtil.drawElements(GfxDrawMode.Triangles, GfxVectorType.UnsignedInt, rawModel.getVertexCount());
    else
      GfxUtil.drawArrays(GfxDrawMode.Triangles, rawModel.getVertexCount());

    version (__OPENGL__) {
      glDisableVertexAttribArray(0);
      glDisableVertexAttribArray(1);
      glDisableVertexAttribArray(2);
      glBindVertexArray(0);
    }

    version (__OPENGL__) {
      glActiveTexture(0);
      glBindTexture(GL_TEXTURE_2D, 0);
    }

    if (!hasTransparency)
      GfxEngine.disableCulling();

    if (shouldCull)
      GfxEngine.disableCulling();

    CoreEngine.getScene().getGenericShader().unbind();
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