/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/opengl/buffer.d, _buffer.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.vao;

import derelict.opengl : glGenVertexArrays, glDeleteVertexArrays, glBindVertexArray;

import liberty.graphics.engine : GfxEngine;

/**
 * OpenGL vertex array object.
**/
final class GfxVAO {
  private {
    uint handle;
  }

  /**
   * Create a vertex array object.
  **/
  this() {
    glGenVertexArrays(1, &handle);
    GfxEngine.runtimeCheck();
  }

  ~this() {
    glDeleteVertexArrays(1, &handle);
  }

  /**
   * Bind this vertex array object.
  **/
  void bind() {
    glBindVertexArray(handle);
    //GfxEngine.runtimeCheck();
  }

  /**
   * Unbind this vertex array object.
  **/
  void unbind() {
    glBindVertexArray(0);
    //GfxEngine.runtimeCheck();
  }

  /**
   * Returns wrapped OpenGL resource handle.
  **/
  uint getHandle() pure nothrow const {
    return handle;
  }
}