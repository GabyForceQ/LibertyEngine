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

import liberty.model;
import liberty.core.engine;
import liberty.resource;
import liberty.material.impl;
import liberty.graphics.constants;
import liberty.graphics.engine;
import liberty.surface.vertex;

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
  SurfaceModel build(SurfaceVertex[] vertices) {
    rawModel = ResourceManager.loadRawModel(vertices);
    build();
    return this;
  }

  /**
   *
  **/
  SurfaceModel build(SurfaceVertex[] vertices, uint[] indices) {
    hasIndices = true;
    rawModel = ResourceManager.loadRawModel(vertices, indices);
    build();
    return this;
  }

  private void build() {
    CoreEngine
      .getScene()
      .getSurfaceSystem()
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

    GfxEngine.enableAlphaBlend();
    
    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, materials[0].getTexture().getId());

      glBindVertexArray(rawModel.getVaoID());
      glEnableVertexAttribArray(0);
      glEnableVertexAttribArray(1);
    }

    hasIndices
      ? drawElements(GfxDrawMode.TRIANGLES, GfxVectorType.UINT, rawModel.getVertexCount())
      : drawArrays(GfxDrawMode.TRIANGLES, rawModel.getVertexCount());

    version (__OPENGL__) {
      glDisableVertexAttribArray(0);
      glDisableVertexAttribArray(1);
      glBindVertexArray(0);

      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, 0);
    }

    GfxEngine.disableBlend();

    if (shouldCull)
      GfxEngine.disableCulling();
  }

  /**
   *
  **/
  bool usesIndices() pure nothrow const {
    return hasIndices;
  }
}