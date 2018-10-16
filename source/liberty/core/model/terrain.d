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
  this(Material material = Material.getDefault()) {
    super(material);
  }

  /**
   *
  **/
  TerrainModel build(TerrainVertex[] vertices, uint[] indices, string texturePath = "") {
    rawModel = ResourceManager.loadRawModel(vertices, indices);
    build(texturePath);
    return this;
  }

  private void build(string texturePath) {
    // Add material only if a texture is specified
    //if (texturePath != "") {

    material.setBackgroundTexture(ResourceManager.loadTexture("res/textures/grass.bmp"));
    CoreEngine.getScene().getTerrainShader().loadBackgroundTexture(0);

    material.setRTexture(ResourceManager.loadTexture("res/textures/mud.bmp"));
    CoreEngine.getScene().getTerrainShader().loadRTexture(1);

    material.setGTexture(ResourceManager.loadTexture("res/textures/grassFlowers.bmp"));
    CoreEngine.getScene().getTerrainShader().loadGTexture(2);

    material.setBTexture(ResourceManager.loadTexture("res/textures/path.bmp"));
    CoreEngine.getScene().getTerrainShader().loadBTexture(3);

    material.setBlendMap(ResourceManager.loadTexture("res/textures/blendMap.bmp"));
    CoreEngine.getScene().getTerrainShader().loadBlendMap(4);

    //}
  }

  /**
   *
  **/
  void draw() {
    CoreEngine.getScene().getTerrainShader().bind();

    if (shouldCull)
      GfxEngine.enableCulling();

    // Bind texture only if a texture is specified
    //if (material.getTexture().getId()) {
      version (__OPENGL__) {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, material.getBackgroundTexture().getId());

        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, material.getRTexture().getId());

        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, material.getGTexture().getId());

        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, material.getBTexture().getId());

        glActiveTexture(GL_TEXTURE4);
        glBindTexture(GL_TEXTURE_2D, material.getBlendMap().getId());
      }
    //}

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

    // Bind texture only if a texture is specified
    //if (material.getTexture().getId()) {
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
    //}

    if (shouldCull)
      GfxEngine.disableCulling();

    CoreEngine.getScene().getTerrainShader().unbind();
  }
}