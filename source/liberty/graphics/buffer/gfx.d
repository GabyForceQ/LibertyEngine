/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/buffer/gfx.d, _gfx.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.buffer.gfx;

/**
 *
**/
package(liberty.graphics) abstract class GfxBuffer {
	protected {
    uint _buffer;
    size_t _size;
    uint _target;
    uint _usage;
    bool _firstLoad;
    bool _initialized;
  }

  /**
   *
  **/
  size_t getSize() pure nothrow const @safe;

  /**
   *
  **/
	void setData(T)(T[] buffer) @trusted {
    import liberty.core.utils.array : bufferSize;
		setData(buffer.bufferSize, buffer.ptr);
	}

  /**
   *
  **/
	void setData(size_t size, void* data) @trusted;

  /**
   *
  **/
	void setSubData(size_t offset, size_t size, void* data) @trusted;

  /**
   *
  **/
	void getSubData(size_t offset, size_t size, void* data) @trusted;

  /**
   *
  **/
	ubyte[] getBytes() @trusted;

  /**
   *
  **/
	void bind() @trusted;

  /**
   *
  **/
	void unbind() @trusted;

  /**
   *
  **/
	uint getHandle() pure nothrow const @safe;
}