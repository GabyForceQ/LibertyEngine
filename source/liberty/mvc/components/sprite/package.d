module liberty.mvc.components.sprite;

import derelict.opengl;

import liberty.core.utils.array : bufferSize;
import liberty.graphics.vertex;

//
import liberty.core.image.bitmap : Bitmap;
import liberty.graphics.texture.data : Texture;
import liberty.core.system.resource.manager : ResourceManager;

class Sprite {

  private {
    float _x;
    float _y;
    float _width;
    float _height;

    GLuint _vboID;
    GLuint _vaoID;

    Texture _texture;
  }

  this() {
    _vboID = 0;
  }

  ~this() {
    if (_vboID != 0) {
      glDeleteBuffers(1, &_vboID);
    }
  }

  void initialize(float x, float y, float width, float height, string texturePath) {
    _x = x;
    _y = y;
    _width = width;
    _height = height;

    _texture = ResourceManager.self.texture(texturePath);

    if (_vboID == 0) {
      glGenBuffers(1, &_vboID);
    }

    glGenVertexArrays(1, &_vaoID);
    glBindVertexArray(_vaoID);

    Vertex2[6] vertexData = [
      Vertex2(Position2( 0.5f, -0.5f), Color(0, 255, 255, 0), TexCoords(1.0f, 1.0f)),
      Vertex2(Position2(-0.5f, -0.5f), Color(0, 255, 255, 0), TexCoords(0.0f, 1.0f)),
      Vertex2(Position2(-0.5f,  0.5f), Color(0, 255, 255, 0), TexCoords(0.0f, 0.0f)),

      Vertex2(Position2(-0.5f,  0.5f), Color(0, 255, 255, 0), TexCoords(0.0f, 0.0f)),
      Vertex2(Position2( 0.5f,  0.5f), Color(0, 255, 255, 0), TexCoords(1.0f, 0.0f)),
      Vertex2(Position2( 0.5f, -0.5f), Color(0, 255, 255, 0), TexCoords(1.0f, 1.0f))
    ];

    glBindBuffer(GL_ARRAY_BUFFER, _vboID);
    glBufferData(GL_ARRAY_BUFFER, vertexData.bufferSize, vertexData.ptr, GL_STATIC_DRAW);
  }

  void render() {
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture.id);

    glEnableVertexAttribArray(0);

    // Bind the buffer object
    glBindBuffer(GL_ARRAY_BUFFER, _vboID);

    // Position
    glVertexAttribPointer(
      0, 
      2,
      GL_FLOAT, 
      GL_FALSE, 
      Vertex2.sizeof, 
      cast(void*)Vertex2.position.offsetof
    );

    // Color
    glVertexAttribPointer(
      1, 
      4, 
      GL_UNSIGNED_BYTE, 
      GL_TRUE, 
      Vertex2.sizeof, 
      cast(void*)Vertex2.color.offsetof
    );

    // TexCoords
    glVertexAttribPointer(
      2, 
      2, 
      GL_FLOAT, 
      GL_TRUE, 
      Vertex2.sizeof, 
      cast(void*)Vertex2.texCoords.offsetof
    );

    glDrawArrays(GL_TRIANGLES, 0, 6);        

    // Unbind the buffer object
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    glDisableVertexAttribArray(0);
  }
}