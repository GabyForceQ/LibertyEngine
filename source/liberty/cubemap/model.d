/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/cubemap/model.d)
 * Documentation:
 * Coverage:
**/
module liberty.cubemap.model;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.core.engine;
import liberty.graphics.constants;
import liberty.graphics.engine;
import liberty.graphics.material.impl;
import liberty.graphics.util;
import liberty.resource;
import liberty.model.impl;
import liberty.cubemap.vertex;

/**
 *
**/
final class CubeMapModel : Model {
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
  CubeMapModel build(CubeMapVertex[] vertices) {
    rawModel = ResourceManager.loadRawModel(vertices);
    build();
    return this;
  }

  /**
   *
  **/
  CubeMapModel build(CubeMapVertex[] vertices, uint[] indices) {
    hasIndices = true;
    rawModel = ResourceManager.loadRawModel(vertices, indices);
    build();
    return this;
  }

  private void build() {
    CoreEngine
      .getScene()
      .getCubeMapSystem()
      .getShader()
      .bind()
      .loadCubeMap(0)
      .unbind();
  }

  /**
   *
  **/
  void render() {
    if (shouldCull)
      GfxEngine.enableCulling();

    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_CUBE_MAP, materials[0].getTexture().getId());
    }

    version (__OPENGL__) {
      glBindVertexArray(rawModel.getVaoID());
      glEnableVertexAttribArray(0);
      glEnableVertexAttribArray(1);
    }

    if (hasIndices)
      GfxUtil.drawElements(
        GfxDrawMode.Triangles,
        GfxVectorType.UnsignedInt,
        rawModel.getVertexCount()
      );
    else
      GfxUtil.drawArrays(
        GfxDrawMode.Triangles,
        rawModel.getVertexCount()
      );
    
    version (__OPENGL__) {
      glDisableVertexAttribArray(0);
      glDisableVertexAttribArray(1);
      glBindVertexArray(0);
    }

    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_CUBE_MAP, 0);
    }

    if (shouldCull)
      GfxEngine.disableCulling();
  }
}