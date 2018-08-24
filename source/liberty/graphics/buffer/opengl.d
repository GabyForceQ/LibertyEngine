/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/buffer/opengl.d, _opengl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.buffer.opengl;

import derelict.opengl;

import liberty.graphics;

import liberty.graphics.buffer.gfx : GfxBuffer;

/**
 * OpenGL Buffer.
**/
final class GLBuffer : GfxBuffer {
  /**
   * Create an empty buffer.
  **/
  this(uint target, uint usage) @trusted {
    _usage = usage;
    _target = target;
    _firstLoad = true;
    glGenBuffers(1, &_buffer);
    GraphicsEngine.self.getBackend().runtimeCheck();
    _initialized = true;
    _size = 0;
  }

  /**
   * Creates a buffer already filled with data.
  **/
  this(T)(uint target, uint usage, T[] buffer) @trusted {
    this(target, usage);
    data = buffer;
  }

  /**
   * Releases the OpenGL buffer resource.
  **/
  ~this() @trusted {
    if (_initialized) {
      glDeleteBuffers(1, &_buffer);
      _initialized = false;
    }
  }

  /**
   * Returns the size of the buffer in bytes.
  **/
  override size_t getSize() pure nothrow const @safe {
    return _size;
  }
  
  /**
   * Returns the copy bytes to the buffer.
  **/
  void setData(T)(T[] buffer) @trusted {
    setData(buffer.length * T.sizeof, buffer.ptr);
  }

  /**
   * Returns the copy bytes to the buffer.
  **/
  override void setData(size_t size, void* data) @trusted {
    bind();
    _size = size;
    if (!_firstLoad) {
      glBufferData(_target, size, null, _usage);
      glBufferSubData(_target, 0, size, data);
    } else {
      glBufferData(_target, size, data, _usage);
    }
    GraphicsEngine.self.getBackend().runtimeCheck();
    _firstLoad = false;
  }
  
  /**
   * Copy bytes to a sub-part of the buffer. 
   * You can't adress data beyond the buffer's size.
  **/
  override void setSubData(size_t offset, size_t size, void* data) @trusted {
    bind();
    glBufferSubData(_target, offset, size, data);
    GraphicsEngine.self.getBackend().runtimeCheck();
  }

  /**
   * Get a sub-part of a buffer.
  **/
  override void getSubData(size_t offset, size_t size, void* data) @trusted {
    bind();
    glGetBufferSubData(_target, offset, size, data);
    GraphicsEngine.self.getBackend().runtimeCheck();
  }

  /**
   * Returns the whole buffer content in a newly allocated array.
  **/
  override ubyte[] getBytes() @trusted {
    auto buffer = new ubyte[_size];
    getSubData(0, _size, buffer.ptr);
    return buffer;
  }

  /**
   * Binds the buffer.
  **/
  override void bind() @trusted {
    glBindBuffer(_target, _buffer);
    GraphicsEngine.self.getBackend().runtimeCheck();
  }
  
  /**
   * Unbind the buffer.
  **/
  override void unbind() @trusted {
    glBindBuffer(_target, 0);
  }
  
  /**
   * Returns wrapped OpenGL resource handle.
  **/
  override uint getHandle() pure nothrow const @safe {
    return _buffer;
  }
}