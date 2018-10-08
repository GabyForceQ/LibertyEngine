module liberty.core.expd;

import derelict.opengl;

import liberty.core.utils;
import liberty.graphics.vertex;
import liberty.graphics.texture;

class ExpMesh {
  uint vao, vbo, ebo;

  Vertex[] vertices;
  uint[] indices;
  Texture[] textures;

  this(Vertex[] vertices, uint[] indices, Texture[] textures) {
    this.vertices = vertices;
    this.indices = indices;
    this.textures = textures;
    build();
  }

  void draw() {
    // draw mesh
    glBindVertexArray(vao);
    glDrawElements(GL_TRIANGLES, indices.length, GL_UNSIGNED_INT, null);
    glBindVertexArray(0);
  }

  private void build() {
    glGenVertexArrays(1, &vao);
    glGenBuffers(1, &vbo);
    glGenBuffers(1, &ebo);
  
    glBindVertexArray(vao);

    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, vertices.bufferSize(), vertices.ptr, GL_STATIC_DRAW);  

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.bufferSize(), indices.ptr, GL_STATIC_DRAW);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.normal.offsetof);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.texCoord.offsetof);

    glBindVertexArray(0);
  }
}