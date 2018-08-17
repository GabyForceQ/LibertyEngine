/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/mvc/components/sprite/package.d, _package.d)
 * Documentation:
 * Coverage:
**/
module liberty.mvc.components.sprite;

import derelict.opengl;

import liberty.core.utils.array : bufferSize;
import liberty.graphics.vertex;

//
import liberty.core.math;
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

    _texture = ResourceManager.self.getTexture(texturePath);

    if (_vboID == 0) {
      glGenBuffers(1, &_vboID);
    }

    glGenVertexArrays(1, &_vaoID);
    glBindVertexArray(_vaoID);

    Vertex2[6] vertexData = [
      Vertex2(Position2(_x + _width, _y + _height), Color(0, 255, 255, 0), TexCoords(1.0f, 1.0f)),
      Vertex2(Position2(_x, _y + _height), Color(0, 255, 255, 0), TexCoords(0.0f, 1.0f)),
      Vertex2(Position2(_x, _y), Color(0, 255, 255, 0), TexCoords(0.0f, 0.0f)),
      
      Vertex2(Position2(_x,  _y), Color(0, 255, 255, 0), TexCoords(0.0f, 0.0f)),
      Vertex2(Position2(_x + _width, _y), Color(0, 255, 255, 0), TexCoords(1.0f, 0.0f)),
      Vertex2(Position2(_x + _width, _y + _height), Color(0, 255, 255, 0), TexCoords(1.0f, 1.0f))
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

class Camera2D {
  private {
    Vector2F _position = Vector2F(1.0f, 1.0f);
    Matrix4F _cameraMatrix = Matrix4F.identity();
    float _scale = 1.0f;
    bool _needsMatrixUpdate = true;
    Matrix4F _orthoMatrix = Matrix4F.identity();
  }

  this() {
    _orthoMatrix = Matrix4F.orthographic(
      0.0f,
      1280.0f,
      720.0f,
      0.0f
    );
  }

  void setPosition(Vector2F newPosition) {
    _position = newPosition;
    _needsMatrixUpdate = true;
  }

  Vector2F getPosition() {
    return _position;
  }

  void setScale(float newScale) {
    _scale = newScale;
    _needsMatrixUpdate = true;
  }

  float getScale() {
    return _scale;
  }

  ref Matrix4F getCameraMatrix() {
    return _cameraMatrix;
  }

  void update() {
    if (_needsMatrixUpdate) {
      Matrix4F orthoAux = _orthoMatrix;
      orthoAux.translate(
        Vector3F(_position.x, _position.y, 0.0f)
      );
      _cameraMatrix = orthoAux;
      _cameraMatrix.scale(Vector3F(_scale, _scale, 0.0f));
      _needsMatrixUpdate = false;
    }
  }
}