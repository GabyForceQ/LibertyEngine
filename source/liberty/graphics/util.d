/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/util.d, _util.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.util;

import liberty.core.utils.singleton : Singleton;
import liberty.graphics.buffer.gfx : GfxBuffer;
import liberty.graphics.buffer.utils : _createGfxBuffer;
import liberty.graphics.vao.utils : _createGfxVertexArrayObject;

import derelict.opengl :
  glEnable, glDisable, GL_TEXTURE_2D;

///
import liberty.graphics;

/**
 *
**/
class RenderUtil : Singleton!RenderUtil {
  /**
   *
  **/
  GfxBuffer createGfxBuffer(T)(
    BufferTarget target, 
    DataUsage usage, 
    T[] data = null
  ) @safe {
    _createGfxBuffer(
      target, 
      usage, 
      data
    );
  }

  /**
   *
  **/
  GfxVertexArrayObject createGfxVertexArrayObject() @safe {
    return _createGfxVertexArrayObject();
  }

  /**
   *
  **/
  GfxShaderProgram createGfxShaderProgram(
    string vertexCode,
    string fragmentCode
  ) @safe {
    return _createGfxShaderProgram(
      vertexCode,
      fragmentCode
    );
  }
}