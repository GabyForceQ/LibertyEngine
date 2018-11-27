/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/buffer/array.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.buffer.array;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.graphics.buffer.factory;
import liberty.graphics.engine;

/**
 * Vertex array object class.
**/
final class GfxVertexArray : IGfxBufferFactory {
  private {
    uint handle;
  }

  /**
   * Create a vertex array object.
  **/
  this(bool shouldBind = true) {
    version (__OPENGL__)
      glGenVertexArrays(1, &handle);
    
    debug GfxEngine.runtimeCheckErr();
    
    if (shouldBind)
      bind();
  }

  /**
   * Bind this vertex array object.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) bind() {
    version (__OPENGL__)
      glBindVertexArray(handle);
    
    debug GfxEngine.runtimeCheckErr();
    return this;
  }

  /**
   * Unbind this vertex array object.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) unbind() {
    version (__OPENGL__)
      glBindVertexArray(0);
    
    debug GfxEngine.runtimeCheckErr();
    return this;
  }

  /**
   * Returns wrapped video resource handle.
  **/
  uint getHandle() pure nothrow const {
    return handle;
  }
}