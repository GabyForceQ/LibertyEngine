/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/buffer/factory.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.buffer.factory;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.graphics.buffer.array;
import liberty.graphics.buffer.constants;
import liberty.graphics.buffer.impl;

/**
 * Video buffers factory interface is implemented and used by video buffer objects.
**/
interface IGfxBufferFactory {
  private {
    static uint[] vaos;
    static uint[] vbos;
  }

  /**
   * Create a new video buffer instance using target, usage and buffer data.
   * See $(D GfxBufferTarget) and $(D GfxDataUsage) enumerations.
  **/
  static GfxBuffer createBuffer(T)(GfxBufferTarget target, GfxDataUsage usage, T[] data = null) {
    uint _target, _usage;
    GfxBuffer buff = null;

    version (__OPENGL__) {
      final switch(target) with (GfxBufferTarget) {
        case ARRAY: _target = GL_ARRAY_BUFFER; break;
        case ATOMIC_COUNTER: _target = GL_ATOMIC_COUNTER_BUFFER; break;
        case COPY_READ: _target = GL_COPY_READ_BUFFER; break;
        case COPY_WRITE: _target = GL_COPY_WRITE_BUFFER; break;
        case DISPATCH_INDIRECT: _target = GL_DISPATCH_INDIRECT_BUFFER; break;
        case DRAW_INDIRECT: _target = GL_DRAW_INDIRECT_BUFFER; break;
        case ELEMENT_ARRAY: _target = GL_ELEMENT_ARRAY_BUFFER; break;
        case PIXEL_PACK: _target = GL_PIXEL_PACK_BUFFER; break;
        case PIXEL_UNPACK: _target = GL_PIXEL_UNPACK_BUFFER; break;
        case QUERY: _target = GL_QUERY_BUFFER; break;
        case SHADER_STORAGE: _target = GL_SHADER_STORAGE_BUFFER; break;
        case TEXTURE: _target = GL_TEXTURE_BUFFER; break;
        case TRANSFORM_FEEDBACK: _target = GL_TRANSFORM_FEEDBACK_BUFFER; break;
        case UNIFORM: _target = GL_UNIFORM_BUFFER; break;
      }

      final switch(usage) with (GfxDataUsage) {
        case STREAM_DRAW: _usage = GL_STREAM_DRAW; break;
        case STREAM_READ: _usage = GL_STREAM_READ; break;
        case STREAM_COPY: _usage = GL_STREAM_COPY; break;
        case STATIC_DRAW: _usage = GL_STATIC_DRAW; break;
        case STATIC_READ: _usage = GL_STATIC_READ; break;
        case STATIC_COPY: _usage = GL_STATIC_COPY; break;
        case DYNAMIC_DRAW: _usage = GL_DYNAMIC_DRAW; break;
        case DYNAMIC_READ: _usage = GL_DYNAMIC_READ; break;
        case DYNAMIC_COPY: _usage = GL_DYNAMIC_COPY; break;
      }
    }

    buff = (data is null)
      ? new GfxBuffer(_target, _usage)
      : new GfxBuffer(_target, _usage, data);

    return buff;
  }

  /**
   * Create a new video vertex array object instance.
  **/
  static GfxVertexArray createArray() {
    GfxVertexArray vao = null;
    vao = new GfxVertexArray();
    return vao;
  }

  /**
   * Release buffers from video memory.
  **/
  static void releaseBuffers(uint[] buff) {
    version (__OPENGL__)
      glDeleteBuffers(cast(int)buff.length, cast(uint*)buff);
  }
  
  /**
   * Release vertex array objects from video memory.
  **/
  static void releaseVertexArrays(uint[] buff) {
    version (__OPENGL__)
      glDeleteVertexArrays(cast(int)buff.length, cast(uint*)buff);
  }

  /**
   * Append a buffer id to the buffer list.
  **/
  static appendToVBOs(uint vboId) {
    vbos ~= vboId;
  }

  /**
   * Append a vertex array id to the vertex array list.
  **/
  static appendToVAOs(uint vaoId) {
    vaos ~= vaoId;
  }

  /**
   * Release vertex array objecs and vertex buffer objects.
  **/
  static void release() {
    releaseVertexArrays(vaos);
    releaseBuffers(vbos);
  }
}