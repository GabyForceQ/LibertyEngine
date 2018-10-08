/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/texture/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.texture.impl;

import derelict.opengl;

/**
 *
**/
struct Texture {
  private {
    uint _id;
  }
  
  uint width;
  uint height;

  this(uint id) {
    _id = id;
  }

  void generateTextures() {
    glGenTextures(1, &_id);
  }

  void deleteTextures() {
    glDeleteTextures(1, &_id);
  }

  void bind() {
    glBindTexture(GL_TEXTURE_2D, _id);
  }

  int getId() {
    return _id;
  }
}