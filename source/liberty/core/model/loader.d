/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/model/mesh.d, _mesh.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.model.loader;

import derelict.opengl;

//import liberty.graphics.buffer : GfxBuffer;
//import liberty.graphics.vao : GfxVAO;
import liberty.core.utils : bufferSize;
import liberty.core.model.raw : RawModel;
import liberty.graphics.vertex : Vertex;

/**
 *
**/
final class ModelLoader {

  private {
    static uint[] vaos;
    static uint[] vbos;
  }

  @disable this();

  static RawModel loadToVAO(Vertex[] data) {
    uint vaoID = createVAO();
    storeDataInAttributeList(0, data);
    storeDataInAttributeList(1, data);
    storeDataInAttributeList(2, data);
    unbindVAO();
    return new RawModel(vaoID, data.length);
  }

  static RawModel loadToVAO(Vertex[] data, uint[] indices) {
    uint vaoID = createVAO();
    bindElementBuffer(indices);
    storeDataInAttributeList(0, data);
    storeDataInAttributeList(1, data);
    storeDataInAttributeList(2, data);
    unbindVAO();
    return new RawModel(vaoID, indices.length);
  }

  static void clean() {
    glDeleteVertexArrays(vaos.length, cast(uint*)vaos);
    glDeleteBuffers(vbos.length, cast(uint*)vbos);
  }

  private static uint createVAO() {
    uint vaoID;
    glGenVertexArrays(1, &vaoID);
    vaos ~= vaoID;
    glBindVertexArray(vaoID);
    return vaoID;
  }

  private static void storeDataInAttributeList(uint attrNumber, Vertex[] data) {
    uint vboID;
    glGenBuffers(1, &vboID);
    vbos ~= vboID;
    glBindBuffer(GL_ARRAY_BUFFER, vboID);
    glBufferData(GL_ARRAY_BUFFER, data.bufferSize(), data.ptr, GL_STATIC_DRAW);
    if (attrNumber == 0)
      glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);
    if (attrNumber == 1)
      glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.normal.offsetof);
    if (attrNumber == 2)
      glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.texCoord.offsetof);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
  }

  private static void unbindVAO() {
    glBindVertexArray(0);
  }

  private static void bindElementBuffer(uint[] indices) {
    uint eboID;
    glGenBuffers(1, &eboID);
    vbos ~= eboID;
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, eboID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.bufferSize(), indices.ptr, GL_STATIC_DRAW);

  }
}