/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model/terrain.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.model.terrain;

version (__OPENGL__)
  import derelict.opengl;

import liberty.core.model.impl : Model;
import liberty.core.engine : CoreEngine;
import liberty.core.resource.manager : ResourceManager;
import liberty.core.material.impl : Material;
import liberty.core.model.raw : RawModel;
import liberty.graphics.constants : GfxDrawMode, GfxVectorType;
import liberty.graphics.engine : GfxEngine;
import liberty.graphics.util : GfxUtil;
import liberty.graphics.vertex : TerrainVertex;

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
    rawModel = ResourceManager.loadRawModel(vertices, indices);
    build();
    return this;
  }

  private void build() {
    CoreEngine.getScene().getTerrainShader().loadBackgroundTexture(0);
    CoreEngine.getScene().getTerrainShader().loadRTexture(1);
    CoreEngine.getScene().getTerrainShader().loadGTexture(2);
    CoreEngine.getScene().getTerrainShader().loadBTexture(3);
    CoreEngine.getScene().getTerrainShader().loadBlendMap(4);
  }

  /**
   *
  **/
  void draw() {
    CoreEngine.getScene().getTerrainShader().bind();

    if (shouldCull)
      GfxEngine.enableCulling();

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
    }

    version (__OPENGL__) {
      glBindVertexArray(rawModel.getVaoID());
      glEnableVertexAttribArray(0);
      glEnableVertexAttribArray(1);
      glEnableVertexAttribArray(2);
    }

    GfxUtil.drawElements(GfxDrawMode.Triangles, GfxVectorType.UnsignedInt, rawModel.getVertexCount());

    version (__OPENGL__) {
      glDisableVertexAttribArray(0);
      glDisableVertexAttribArray(1);
      glDisableVertexAttribArray(2);
      glBindVertexArray(0);
    }

    version (__OPENGL__) {
      glActiveTexture(0);
      glBindTexture(GL_TEXTURE_2D, 0);

      glActiveTexture(1);
      glBindTexture(GL_TEXTURE_2D, 1);

      glActiveTexture(2);
      glBindTexture(GL_TEXTURE_2D, 2);

      glActiveTexture(3);
      glBindTexture(GL_TEXTURE_2D, 3);

      glActiveTexture(4);
      glBindTexture(GL_TEXTURE_2D, 4);
    }

    if (shouldCull)
      GfxEngine.disableCulling();

    CoreEngine.getScene().getTerrainShader().unbind();
  }
}