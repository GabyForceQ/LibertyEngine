module liberty.world.components.mesh;

import derelict.opengl;

import liberty.core.utils.array : bufferSize;
import liberty.graphics.vertex : Vertex3;

class Mesh {
  private {
    uint _vboID;
    uint _iboID;
    uint _vaoID;
    int _size;
  }

  this() {
    glGenBuffers(1, &_vboID);
    glGenBuffers(1, &_iboID);
    glGenVertexArrays(1, &_vaoID);
    glBindVertexArray(_vaoID);
  }

  void addVertices(Vertex3[] vertices, int[] indices) {
    _size = cast(int)indices.length;

    glBindBuffer(GL_ARRAY_BUFFER, _vboID);
    glBufferData(GL_ARRAY_BUFFER, vertices.bufferSize(), vertices.ptr, GL_STATIC_DRAW);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _iboID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.bufferSize(), indices.ptr, GL_STATIC_DRAW);
  }

  void render() {
    // Bind the buffer object
    glBindBuffer(GL_ARRAY_BUFFER, _vboID);

    glEnableVertexAttribArray(0);

    glVertexAttribPointer(
      0,
      3,
      GL_FLOAT,
      GL_FALSE,
      Vertex3.sizeof, 
      null
      //cast(void*)Vertex3.position.offsetof
    );
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _iboID);
    glDrawElements(GL_TRIANGLES, _size, GL_UNSIGNED_INT, null);

    glDisableVertexAttribArray(0);
  }
}