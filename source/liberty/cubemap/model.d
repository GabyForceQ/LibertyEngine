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
import liberty.graphics.engine;
import liberty.material.impl;
import liberty.model.impl;
import liberty.model.io;
import liberty.cubemap.vertex;

/**
 *
**/
final class CubeMapModel : Model {
  /**
   *
  **/
  this(Material[] materials) {
    super(materials);
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(CubeMapVertex[] vertices) {
    rawModel = ModelIO.loadRawModel(vertices);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(CubeMapVertex[] vertices, uint[] indices) {
    useIndices = true;
    rawModel = ModelIO.loadRawModel(vertices, indices);
    return this;
  }

  /**
   *
  **/
  override void render() {
    glDepthMask(GL_FALSE);
    
    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_CUBE_MAP, materials[0].getTexture().getId());
    
      glBindVertexArray(rawModel.getVaoID());
      glEnableVertexAttribArray(0);
    }

    super.render();
    
    version (__OPENGL__) {
      glDisableVertexAttribArray(0);
      glBindVertexArray(0);
    
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_CUBE_MAP, 0);
    }

    glDepthMask(GL_TRUE);
  }
}