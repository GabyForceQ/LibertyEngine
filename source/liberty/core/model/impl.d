/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.model.impl;

version (__OPENGL__)
  import derelict.opengl;

import liberty.core.engine : CoreEngine;
import liberty.core.resource.manager : ResourceManager;
import liberty.core.material.impl : Material;
import liberty.core.math.vector : Vector3F;
import liberty.core.model.raw : RawModel;
import liberty.core.utils : bufferSize;
import liberty.graphics.constants : GfxDrawMode, GfxVectorType;
import liberty.graphics.util : GfxUtil;
import liberty.graphics.vertex : Vertex;

/**
 *
**/
final class Model {
  private {
    RawModel rawModel;
    Material material;
    bool hasIndices;
  }

  /**
   *
  **/
  this(Material material = Material.getDefault()) {
    this.material = material;
  }

  /**
   *
  **/
  Model build(Vertex[] vertices, string texturePath = "") {
    rawModel = ResourceManager.loadRawModel(vertices);
    build(texturePath);
    return this;
  }

  /**
   *
  **/
  Model build(Vertex[] vertices, uint[] indices, string texturePath = "") {
    hasIndices = true;
    rawModel = ResourceManager.loadRawModel(vertices, indices);
    build(texturePath);
    return this;
  }

  private void build(string texturePath) {
    // Bind the core shader
    CoreEngine.getScene().shaderList["CoreShader"].bind();

    CoreEngine.getScene().shaderList["CoreShader"]
      .loadUniform("uMaterial.specular", Vector3F(0.5f, 0.5f, 0.5f))
      .loadUniform("uMaterial.shininess", 32.0f);

    // Add material only if a texture is specified
    if (texturePath != "") {
      material.setTexture(ResourceManager.loadTexture(texturePath));
      CoreEngine.getScene().shaderList["CoreShader"]
        .loadUniform("uMaterial.diffuse", 0);
    }

    // Unbind the core shader
    CoreEngine.getScene().shaderList["CoreShader"].unbind();
  }

  /**
   *
  **/
  void draw() {
    // Bind texture only if a texture is specified
    if (material.getTexture().getId()) {
      version (__OPENGL__) {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, material.getTexture().getId());
      }
    }

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

    // Bind texture only if a texture is specified
    if (material.getTexture().getId()) {
      version (__OPENGL__) {
        glActiveTexture(0);
        glBindTexture(GL_TEXTURE_2D, 0);
      }
    }
  }

  /**
   *
  **/
  RawModel getRawModel() pure nothrow {
    return rawModel;
  }

  /**
   *
  **/
  Material getMaterial() pure nothrow {
    return material;
  }

  /**
   *
  **/
  bool usesIndices() pure nothrow const {
    return hasIndices;
  }
}