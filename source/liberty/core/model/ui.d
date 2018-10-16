/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model/ui.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.model.ui;

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
import liberty.graphics.vertex : UIVertex;

/**
 *
**/
final class UIModel : Model {
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
  UIModel build(UIVertex[] vertices, string texturePath = "") {
    rawModel = ResourceManager.loadRawModel(vertices);
    build(texturePath);
    return this;
  }

  /**
   *
  **/
  UIModel build(UIVertex[] vertices, uint[] indices, string texturePath = "") {
    hasIndices = true;
    rawModel = ResourceManager.loadRawModel(vertices, indices);
    build(texturePath);
    return this;
  }

  private void build(string texturePath) {
    // Add material only if a texture is specified
    if (texturePath != "") {
      materials[0].setTexture(ResourceManager.loadTexture(texturePath));
      CoreEngine.getScene().getUIShader().loadTexture(0);
    }
  }

  /**
   *
  **/
  void draw() {
    CoreEngine.getScene().getUIShader().bind();

    version (__OPENGL__) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, materials[0].getTexture().getId());
    }

    //GfxEngine.enableCulling();

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

    //GfxEngine.disableCulling();

    CoreEngine.getScene().getUIShader().unbind();
  }

  /**
   *
  **/
  bool usesIndices() pure nothrow const {
    return hasIndices;
  }
}