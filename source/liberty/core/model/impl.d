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
import liberty.core.model.mesh : Mesh;
import liberty.core.resource.manager : ResourceManager;

import liberty.graphics.buffer : GfxBuffer;
import liberty.graphics.vao : GfxVAO;

/**
 *
**/
final class Model {
  private {
    Mesh mesh;
    Material material;

    uint verticesCount;
    uint indicesCount;

    Vertex[] vertices;
    uint[] indices;

    BSPVolumeType bspVolumeType;
  }

  /**
   *
  **/
  this(BSPVolumeType bspVolumeType, Material material = Materials.defaultMaterial) {
    mesh.vao = new GfxVAO();
    mesh.vao.bind();
    this.bspVolumeType = bspVolumeType;
    this.material = material;
  }

  ~this() {
    mesh.clear();
  }

  /**
   *
  **/
  Model build(Vertex[] vertices, string texturePath = "") {
    mesh.vbo = new GfxBuffer(GL_ARRAY_BUFFER, GL_STATIC_DRAW, vertices[]);
    this.vertices = vertices;
    build(texturePath);
    return this;
  }

  /**
   *
  **/
  Model build(Vertex[] vertices, uint[] indices, string texturePath = "") {
    mesh.vbo = new GfxBuffer(GL_ARRAY_BUFFER, GL_STATIC_DRAW, vertices);
    mesh.ebo = new GfxBuffer(GL_ELEMENT_ARRAY_BUFFER, GL_STATIC_DRAW, indices);
    this.vertices = vertices;
    this.indices = indices;
    indicesCount = cast(int)indices.length;
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

    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.normal.offsetof);
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.texCoord.offsetof);
  }

  /**
   *
  **/
  Mesh getMesh() {
    return mesh;
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

    final switch (bspVolumeType) with (BSPVolumeType) {
	    case TRIANGLE:
	    case SQUARE:
		    glDrawElements(GL_TRIANGLES, indicesCount, GL_UNSIGNED_INT, null);
		    break;

	    case CUBE:
		    glDrawArrays(GL_TRIANGLES, 0, 36);
		    break;
	  }

    // Bind texture only if a texture is specified
    if (material.texture.getId()) {
      glActiveTexture(0);
      glBindTexture(GL_TEXTURE_2D, 0);
    }
  }
}