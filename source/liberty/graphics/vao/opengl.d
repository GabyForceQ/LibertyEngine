/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/vao/opengl.d, _opengl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.vao.opengl;

import derelict.opengl : glGenVertexArrays, glDeleteVertexArrays, glBindVertexArray;

import liberty.graphics.engine;
import liberty.graphics.vao.gfx : GfxVertexArrayObject;

/**
 * OpenGL Vertex Array Object.
**/
final class GLVertexArrayObject : GfxVertexArrayObject {

  /**
   * Create a Vertex Array Object.
  **/
  this() @trusted {
    glGenVertexArrays(1, &_handle);
    GraphicsEngine.self.getBackend().runtimeCheck();
    _initialized = true;
  }

  /**
   * Release the OpenGL Vertex Array Object resource.
  **/
  ~this() @trusted {
    if (_initialized)  {
      glDeleteVertexArrays(1, &_handle);
      _initialized = false;
    }
  }

  /**
   * Use this Vertex Array Object.
  **/
  override void bind() @trusted {
    glBindVertexArray(_handle);
    GraphicsEngine.self.getBackend().runtimeCheck();
  }

  /**
   * Unuse this Vertex Array Object.
  **/
  override void unbind() @trusted {
    glBindVertexArray(0);
    GraphicsEngine.self.getBackend().runtimeCheck();
  }
  
  /**
   * Returns wrapped OpenGL resource handle.
  **/
  override uint getHandle() pure nothrow const @safe {
    return _handle;
  }
}