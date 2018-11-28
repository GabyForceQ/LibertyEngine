/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/terrain/model.d)
 * Documentation:
 * Coverage:
**/
module liberty.terrain.model;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.model.impl;
import liberty.core.engine;
import liberty.material.impl;
import liberty.model.io;
import liberty.graphics.constants;
import liberty.graphics.engine;
import liberty.terrain.vertex;

/**
 *
**/
final class TerrainModel : Model {
  /**
   *
  **/
  this(Material[] materials) {
    super(materials);
  }

  /**
   *
  **/
  TerrainModel build(TerrainVertex[] vertices, uint[] indices) {
    rawModel = ModelIO.loadRawModel(vertices, indices);
    build();
    return this;
  }

  private void build() {
    CoreEngine
      .getScene()
      .getTerrainSystem()
      .getShader()
      .bind()
      .loadBackgroundTexture(0)
      .loadRTexture(1)
      .loadGTexture(2)
      .loadBTexture(3)
      .loadBlendMap(4)
      .unbind();
  }

  /**
   *
  **/
  void render() {
    if (shouldCull)
      GfxEngine
        .getBackend()
        .setCullingEnabled();

    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, materials[0].getTexture().getId());
      glActiveTexture(GL_TEXTURE1);
      glBindTexture(GL_TEXTURE_2D, materials[2].getTexture().getId());
      glActiveTexture(GL_TEXTURE2);
      glBindTexture(GL_TEXTURE_2D, materials[3].getTexture().getId());
      glActiveTexture(GL_TEXTURE3);
      glBindTexture(GL_TEXTURE_2D, materials[4].getTexture().getId());
      glActiveTexture(GL_TEXTURE4);
      glBindTexture(GL_TEXTURE_2D, materials[1].getTexture().getId());

      glBindVertexArray(rawModel.getVaoID());
      glEnableVertexAttribArray(0);
      glEnableVertexAttribArray(1);
      glEnableVertexAttribArray(2);
    }

    drawElements(GfxDrawMode.TRIANGLES, GfxVectorType.UINT, rawModel.getVertexCount());

    version (__OPENGL__) {
      glDisableVertexAttribArray(0);
      glDisableVertexAttribArray(1);
      glDisableVertexAttribArray(2);
      glBindVertexArray(0);

      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, 0);
      glActiveTexture(GL_TEXTURE1);
      glBindTexture(GL_TEXTURE_2D, 0);
      glActiveTexture(GL_TEXTURE2);
      glBindTexture(GL_TEXTURE_2D, 0);
      glActiveTexture(GL_TEXTURE3);
      glBindTexture(GL_TEXTURE_2D, 0);
      glActiveTexture(GL_TEXTURE4);
      glBindTexture(GL_TEXTURE_2D, 0);
    }

    if (shouldCull)
      GfxEngine
        .getBackend()
        .setCullingEnabled(false);
  }
}