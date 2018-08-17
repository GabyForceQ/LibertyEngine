module liberty.graphics.buffer.utils;

///
import derelict.opengl;

///
import liberty.graphics;

pragma (inline, true) :
package(liberty.graphics):
 
GfxBuffer _createGfxBuffer(T)(
  BufferTarget target, 
  DataUsage usage, 
  T[] data = null
) @safe {
  // Init
  uint _target, _usage;
  GfxBuffer buff = null;
  
  // Fill target
  final switch(target) with (BufferTarget) {
    case Array:
      _target = GL_ARRAY_BUFFER;
      break;

    case AtomicCounter:
      _target = GL_ATOMIC_COUNTER_BUFFER;
      break;

    case CopyRead:
      _target = GL_COPY_READ_BUFFER;
      break;

    case CopyWrite:
      _target = GL_COPY_WRITE_BUFFER;
      break;

    case DispatchIndirect:
      _target = GL_DISPATCH_INDIRECT_BUFFER;
      break;

    case DrawIndirect:
      _target = GL_DRAW_INDIRECT_BUFFER;
      break;

    case ElementArray:
      _target = GL_ELEMENT_ARRAY_BUFFER;
      break;

    case PixelPack:
      _target = GL_PIXEL_PACK_BUFFER;
      break;

    case PixelUnpack:
      _target = GL_PIXEL_UNPACK_BUFFER;
      break;

    case Query:
      _target = GL_QUERY_BUFFER;
      break;

    case ShaderStorage:
      _target = GL_SHADER_STORAGE_BUFFER;
      break;

    case Texture:
      _target = GL_TEXTURE_BUFFER;
      break;

    case TransformFeedback:
      _target = GL_TRANSFORM_FEEDBACK_BUFFER;
      break;

    case Uniform:
      _target = GL_UNIFORM_BUFFER;
      break;
  }

  // Fill usage
  final switch(usage) with (DataUsage) {
    case StreamDraw:
      _usage = GL_STREAM_DRAW;
      break;

    case StreamRead:
      _usage = GL_STREAM_READ;
      break;
      
    case StreamCopy:
      _usage = GL_STREAM_COPY;
      break;

    case StaticDraw:
      _usage = GL_STATIC_DRAW;
      break;

    case StaticRead:
      _usage = GL_STATIC_READ;
      break;

    case StaticCopy:
      _usage = GL_STATIC_COPY;
      break;

    case DynamicDraw:
      _usage = GL_DYNAMIC_DRAW;
      break;

    case DynamicRead:
      _usage = GL_DYNAMIC_READ;
      break;

    case DynamicCopy:
      _usage = GL_DYNAMIC_COPY;
      break;
  }

  // Create the buffer
  if (data is null) {
    buff = new GLBuffer(_target, _usage);
  } else {
    buff = new GLBuffer(_target, _usage, data);
  }

  // Return the buffer
  return buff;
}