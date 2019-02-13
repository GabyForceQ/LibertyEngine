/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/buffer/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.buffer.impl;

import bindbc.opengl;
import liberty.graphics.buffer.factory;
import liberty.graphics.engine;
import liberty.utils;

/// Vertex buffer class.
final class GfxBuffer : IGfxBufferFactory {
  ///
  uint handle;
  ///
  size_t size;
  ///
  uint target;
  ///
  uint usage;
  ///
  bool firstLoad = true;

  /// Create a vertex buffer object using target and usage.
  this(uint target, uint usage) {
    this.target = target;
    this.usage = usage;
    glGenBuffers(1, &handle);
    debug GfxEngine.runtimeCheckErr;
  }

  /// Create a vertex buffer object using target, usage and buffer.
  this(T)(uint target, uint usage, T[] buffer) {
    this(target, usage);
    setData(buffer);
  }

  /// Returns reference to this so it can be used in a stream.
  typeof(this) setData(T)(T[] buffer) {
    setData(buffer.bufferSize, buffer.ptr);
    return this;
  }

  /// Returns reference to this so it can be used in a stream.
  typeof(this) setData(size_t size, void* data) {
    bind;
    this.size = size;
    if (firstLoad)
      glBufferData(target, size, data, usage);
    else {
      glBufferData(target, size, null, usage);
      glBufferSubData(target, 0, size, data);
    }
    debug GfxEngine.runtimeCheckErr;
    firstLoad = false;
    return this;
  }

  /// Returns reference to this so it can be used in a stream.
  typeof(this) setSubData(size_t offset, size_t size, void* data) {
    bind;
    glBufferSubData(target, offset, size, data);
    debug GfxEngine.runtimeCheckErr;
    return this;
  }

  /// Returns reference to this so it can be used in a stream.
  typeof(this) getSubData(size_t offset, size_t size, void* data) {
    bind;
    glGetBufferSubData(target, offset, size, data);
    debug GfxEngine.runtimeCheckErr;
    return this;
  }

  /// Return the buffer number of bytes.
  ubyte[] getBytes() {
    auto buff = new ubyte[size];
    getSubData(0, size, buff.ptr);
    return buff;
  }

  /// Bind the buffer into video memory.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) bind() {
    glBindBuffer(target, handle);
    debug GfxEngine.runtimeCheckErr;
    return this;
  }

  /// Unbind the buffer from video memory.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) unbind() {
    glBindBuffer(target, 0);
    return this;
  }
}