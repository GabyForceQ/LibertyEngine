/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.model.impl;

import derelict.opengl;

import liberty.core.engine : CoreEngine;
import liberty.core.material : Material, Materials;
import liberty.core.math.vector : Vector3F;
import liberty.core.utils : bufferSize;
import liberty.graphics.vertex : Vertex;
import liberty.core.objects.bsp.constants : BSPVolumeType;
//import liberty.core.model.mesh : Mesh;
import liberty.core.resource.manager : ResourceManager;

import liberty.graphics.buffer : GfxBuffer;
import liberty.graphics.vao : GfxVAO;

import liberty.core.model.raw : RawModel;
import liberty.core.model.loader : ModelLoader;

/**
 *
**/
final class Model {
  private {
    RawModel rawModel;
    Material material;
    BSPVolumeType bspVolumeType;
  }

  /**
   *
  **/
  this(BSPVolumeType bspVolumeType, Material material = Materials.defaultMaterial) {
    this.bspVolumeType = bspVolumeType;
    this.material = material;
  }

  ~this() {}

  /**
   *
  **/
  Model build(Vertex[] vertices, string texturePath = "") {
    rawModel = ModelLoader.loadToVAO(vertices);
    build(texturePath);
    return this;
  }

  /**
   *
  **/
  Model build(Vertex[] vertices, uint[] indices, string texturePath = "") {
    rawModel = ModelLoader.loadToVAO(vertices, indices);
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
      material.texture = ResourceManager.loadTexture(texturePath);
      CoreEngine.getScene().shaderList["CoreShader"]
        .loadUniform("uMaterial.diffuse", 0);
    }

    // Unbind the core shader
    CoreEngine.getScene().shaderList["CoreShader"].unbind();
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
  void draw() {
    // Bind texture only if a texture is specified
    if (material.texture.getId()) {
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_2D, material.texture.getId());
    }

    glBindVertexArray(rawModel.getVaoID());
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);

    final switch (bspVolumeType) with (BSPVolumeType) {
      case TRIANGLE:
      case SQUARE:
        glDrawElements(GL_TRIANGLES, rawModel.getVertexCount(), GL_UNSIGNED_INT, null);
        break;

      case CUBE:
        glDrawArrays(GL_TRIANGLES, 0, rawModel.getVertexCount());
        break;
    }

    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    glDisableVertexAttribArray(2);
    glBindVertexArray(0);

    // Bind texture only if a texture is specified
    if (material.texture.getId()) {
      glActiveTexture(0);
      glBindTexture(GL_TEXTURE_2D, 0);
    }
  }
}