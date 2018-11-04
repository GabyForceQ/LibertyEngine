/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/model.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.model;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.model.impl;
import liberty.core.engine;
import liberty.resource.manager;
import liberty.graphics.material.impl;
import liberty.model.raw;
import liberty.graphics.constants;
import liberty.graphics.engine;
import liberty.graphics.util;
import liberty.graphics.vertex;

/**
 *
**/
final class SurfaceModel : Model {
  private {
    bool hasIndices;
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
  SurfaceModel build(UIVertex[] vertices) {
    rawModel = ResourceManager.loadRawModel(vertices);
    build();
    return this;
  }

  /**
   *
  **/
  SurfaceModel build(UIVertex[] vertices, uint[] indices) {
    hasIndices = true;
    rawModel = ResourceManager.loadRawModel(vertices, indices);
    build();
    return this;
  }

  private void build() {
    CoreEngine.getScene().getSurfaceShader().loadTexture(0);
  }

  /**
   *
  **/
  void draw() {
    CoreEngine.getScene().getSurfaceShader().bind();

    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, materials[0].getTexture().getId());
    }

    if (shouldCull)
      GfxEngine.enableCulling();
    
    GfxEngine.enableAlphaBlend();
    //GfxEngine.disableDepthTest();

    version (__OPENGL__) {
      glBindVertexArray(rawModel.getVaoID());
      glEnableVertexAttribArray(0);
      glEnableVertexAttribArray(1);
    }

    if (hasIndices)
      GfxUtil.drawElements(GfxDrawMode.Triangles, GfxVectorType.UnsignedInt, rawModel.getVertexCount());
    else
      GfxUtil.drawArrays(GfxDrawMode.Triangles, rawModel.getVertexCount());

    version (__OPENGL__) {
      glDisableVertexAttribArray(0);
      glDisableVertexAttribArray(1);
      glBindVertexArray(0);
    }

    version (__OPENGL__) {
      glActiveTexture(0);
      glBindTexture(GL_TEXTURE_2D, 0);
    }

    //GfxEngine.enableDepthTest();
    GfxEngine.disableBlend();

    if (shouldCull)
      GfxEngine.disableCulling();

    CoreEngine.getScene().getSurfaceShader().unbind();
  }

  /**
   *
  **/
  bool usesIndices() pure nothrow const {
    return hasIndices;
  }
}