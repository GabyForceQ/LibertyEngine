/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/components/sprite/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.components.sprite.impl;

import derelict.opengl;
import derelict.sdl2.sdl;

import liberty.core.utils.array : bufferSize;
import liberty.graphics.vertex;

//
import liberty.core.math;
import liberty.core.image.bitmap : Bitmap;
import liberty.graphics.texture.data : Texture;
import liberty.core.system.resource.manager : ResourceManager;
import liberty.core.system.input.manager : Input;

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

  ~this() {
    if (_vboID != 0) {
      glDeleteBuffers(1, &_vboID);
    }
    if (_vaoID != 0) {
      glDeleteBuffers(1, &_vaoID);
    }
    glDeleteTextures(1, &_texture.id);
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

    // Bind the buffer object
    glBindBuffer(GL_ARRAY_BUFFER, _vboID);

    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);

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

    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    glDisableVertexAttribArray(2);

    // Unbind the buffer object
    glBindBuffer(GL_ARRAY_BUFFER, 0);
  }
}

class Camera2D {
  private {
    Vector2F _position = Vector2F(0.0f, 0.0f);
    Matrix4F _cameraMatrix = Matrix4F.identity();
    float _scale = 1.0f;
    Matrix4F _orthoMatrix = Matrix4F.identity();
  }

  this() {
    _orthoMatrix = Matrix4F.orthographic(
      -640.0f,
      640.0f,
      360.0f,
      -360.0f,
      1.0f,
      1000.0f
    );
    updateMatrix();
  }

  void setPosition(Vector2F newPosition) {
    _position = newPosition;
    updateMatrix();
  }

  Vector2F getPosition() {
    return _position;
  }

  void setScale(float newScale) {
    _scale = newScale;
    updateMatrix();
  }

  float getScale() {
    return _scale;
  }

  ref Matrix4F getCameraMatrix() {
    return _cameraMatrix;
  }

  void update() {
    if (Input.self.isKeyDown(SDLK_w)) {
      setPosition(Vector2F.up);
    }
        
    if (Input.self.isKeyDown(SDLK_s)) {
      setPosition(Vector2F.down);
    }

    if (Input.self.isKeyDown(SDLK_a)) {
      setPosition(Vector2F.left);
    }

    if (Input.self.isKeyDown(SDLK_d)) {
      setPosition(Vector2F.right);
    }
  }

  private void updateMatrix() {
    _orthoMatrix.translate(
      Vector3F(-_position.x, _position.y, 0.0f)
    );
    
    // todo: tut21

    _cameraMatrix = _orthoMatrix;
    _cameraMatrix.scale(Vector3F(_scale, _scale, 0.0f));
  }

  Vector2F getWorldCoordsFromScreen(Vector2F screenCoords) {
    // Zero is the center
    screenCoords -= Vector2F(1280.0f / 2.0f, 720.0f / 2.0f);

    // Scale the coordinates
    screenCoords /= _scale;

    // Translate with the camera position
    screenCoords += _position;

    return screenCoords;
  }
}