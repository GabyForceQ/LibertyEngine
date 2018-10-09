/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/array.d, _array.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.array;

version (__OPENGL__)
  import derelict.opengl :
    glGenVertexArrays, glDeleteVertexArrays, glBindVertexArray;

import liberty.graphics.engine : GfxEngine;

/**
 * OpenGL vertex array object.
**/
final class GfxArray {
  private {
    uint handle;
  }

  /**
   * Create a vertex array object.
  **/
  this(bool shouldBind = true) {
    version (__OPENGL__)
      glGenVertexArrays(1, &handle);
    
    debug GfxEngine.runtimeCheck();
    if (shouldBind)
      bind();
  }

  ~this() {
    version (__OPENGL__)
      glDeleteVertexArrays(1, &handle);
  }

  /**
   * Bind this vertex array object.
  **/
  void bind() {
    version (__OPENGL__)
      glBindVertexArray(handle);
    
    debug GfxEngine.runtimeCheck();
  }

  /**
   * Unbind this vertex array object.
  **/
  void unbind() {
    version (__OPENGL__)
      glBindVertexArray(0);
    
    debug GfxEngine.runtimeCheck();
  }

  /**
   * Returns wrapped OpenGL resource handle.
  **/
  uint getHandle() pure nothrow const {
    return handle;
  }

  /**
   *
  **/
  static void releaseVertexArrays(uint[] buff) {
    version (__OPENGL__)
      glDeleteVertexArrays(buff.length, cast(uint*)buff);
  }
}