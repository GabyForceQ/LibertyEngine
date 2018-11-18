/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/util.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.util;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.graphics.array;
import liberty.graphics.buffer.constants;
import liberty.graphics.buffer.impl;
import liberty.graphics.constants;

/**
 *
**/
final class GfxUtil {
  @disable this();

	/**
   *
  **/
  static GfxBuffer createBuffer(T)(GfxBufferTarget target, GfxDataUsage usage, T[] data = null) {
    uint _target, _usage;
    GfxBuffer buff = null;

    version (__OPENGL__) {
      final switch(target) with (GfxBufferTarget) {
        case Array: _target = GL_ARRAY_BUFFER; break;
        case AtomicCounter: _target = GL_ATOMIC_COUNTER_BUFFER; break;
        case CopyRead: _target = GL_COPY_READ_BUFFER; break;
        case CopyWrite: _target = GL_COPY_WRITE_BUFFER; break;
        case DispatchIndirect: _target = GL_DISPATCH_INDIRECT_BUFFER; break;
        case DrawIndirect: _target = GL_DRAW_INDIRECT_BUFFER; break;
        case ElementArray: _target = GL_ELEMENT_ARRAY_BUFFER; break;
        case PixelPack: _target = GL_PIXEL_PACK_BUFFER; break;
        case PixelUnpack: _target = GL_PIXEL_UNPACK_BUFFER; break;
        case Query: _target = GL_QUERY_BUFFER; break;
        case ShaderStorage: _target = GL_SHADER_STORAGE_BUFFER; break;
        case Texture: _target = GL_TEXTURE_BUFFER; break;
        case TransformFeedback: _target = GL_TRANSFORM_FEEDBACK_BUFFER; break;
        case Uniform: _target = GL_UNIFORM_BUFFER; break;
      }

      final switch(usage) with (GfxDataUsage) {
        case StreamDraw: _usage = GL_STREAM_DRAW; break;
        case StreamRead: _usage = GL_STREAM_READ; break;
        case StreamCopy: _usage = GL_STREAM_COPY; break;
        case StaticDraw: _usage = GL_STATIC_DRAW; break;
        case StaticRead: _usage = GL_STATIC_READ; break;
        case StaticCopy: _usage = GL_STATIC_COPY; break;
        case DynamicDraw: _usage = GL_DYNAMIC_DRAW; break;
        case DynamicRead: _usage = GL_DYNAMIC_READ; break;
        case DynamicCopy: _usage = GL_DYNAMIC_COPY; break;
      }
    }

    if (data is null)
      buff = new GfxBuffer(_target, _usage);
    else
      buff = new GfxBuffer(_target, _usage, data);

    return buff;
  }

  /**
   *
  **/
  static GfxArray createArray() {
    GfxArray vao = null;
    vao = new GfxArray();
    return vao;
  }

  /**
   *
  **/
  static void drawElements(GfxDrawMode drawMode, GfxVectorType type, size_t count) {
    version (__OPENGL__) {
      GLenum _drawMode, _type;

      final switch (drawMode) with (GfxDrawMode) {
        case Triangles: _drawMode = GL_TRIANGLES;
      }

      final switch (type) with (GfxVectorType) {
        case UnsignedInt: _type = GL_UNSIGNED_INT;
      }
      
      glDrawElements(_drawMode, cast(int)count, _type, null);
    }
  }

  /**
   *
  **/
  static void drawArrays(GfxDrawMode drawMode, size_t count) {
    version (__OPENGL__) {
      GLenum _drawMode;

      final switch (drawMode) with (GfxDrawMode) {
        case Triangles: _drawMode = GL_TRIANGLES;
      }
      
      glDrawArrays(_drawMode, 0, cast(int)count);
    }
  }
}