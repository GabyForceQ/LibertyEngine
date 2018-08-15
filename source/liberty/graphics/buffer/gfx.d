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