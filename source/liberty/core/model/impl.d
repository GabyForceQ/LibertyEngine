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

/**
 *
**/
final class Model {
  private {
    static Mesh mesh;
    Material material;

    uint verticesCount;
    uint indicesCount;

    BSPVolumeType bspVolumeType;
  }

  /**
   *
  **/
  this(BSPVolumeType bspVolumeType, Material material = Materials.defaultMaterial) {
    glGenBuffers(1, &mesh.vboID);
    glGenBuffers(1, &mesh.eboID);
    glGenVertexArrays(1, &mesh.vaoID);
    glBindVertexArray(mesh.vaoID);

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
	  glBindVertexArray(mesh.vaoID);

    // Bind the buffer object
    glBindBuffer(GL_ARRAY_BUFFER, mesh.vboID);
    glBufferData(GL_ARRAY_BUFFER, vertices.bufferSize(), vertices.ptr, GL_STATIC_DRAW);

    build(texturePath);

    return this;
  }

  /**
   *
  **/
  Model build(Vertex[] vertices, uint[] indices, string texturePath = "") {
	  glBindVertexArray(mesh.vaoID);

    // Bind the buffer object
    glBindBuffer(GL_ARRAY_BUFFER, mesh.vboID);
		glBufferData(GL_ARRAY_BUFFER, vertices.bufferSize(), vertices.ptr, GL_STATIC_DRAW);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mesh.eboID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.bufferSize(), indices.ptr, GL_STATIC_DRAW);

    indicesCount = cast(int)indices.length;

    build(texturePath);

    return this;
  }

  private void build(string texturePath) {    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.normal.offsetof);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.texCoord.offsetof);
    glBindVertexArray(0);

    if (texturePath != "") {
      material.texture = ResourceManager.loadTexture(texturePath);
      CoreEngine.getScene().shaderList["CoreShader"].bind();
      CoreEngine.getScene().shaderList["CoreShader"].loadUniform("uMaterial.diffuse", 0);
      CoreEngine.getScene().shaderList["CoreShader"].unbind();
    }
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

  void draw() {
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, material.texture.getId());

    CoreEngine.getScene().shaderList["CoreShader"]
      .loadUniform("uMaterial.specular", Vector3F(0.5f, 0.5f, 0.5f))
      .loadUniform("uMaterial.shininess", 32.0f);

    glBindVertexArray(mesh.vaoID);

    final switch (bspVolumeType) with (BSPVolumeType) {
	    case TRIANGLE:
	    case SQUARE:
		    glDrawElements(GL_TRIANGLES, indicesCount, GL_UNSIGNED_INT, null);
		    break;

	    case CUBE:
		    glDrawArrays(GL_TRIANGLES, 0, 36);
		    break;
	  }

    // Unbind texture
    glActiveTexture(0);
    glBindTexture(GL_TEXTURE_2D, 0);
  }
}