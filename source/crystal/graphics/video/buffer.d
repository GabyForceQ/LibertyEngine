/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.graphics.video.buffer;
/// Represents the target to which the buffer object is bound.
enum BufferTarget : byte {
	/// Vertex attributes.
	Array = 0x00,
	/// Atomic counter storage.
	AtomicCounter = 0x01,
	/// Buffer copy source.
	CopyRead = 0x02,
	/// Buffer copy destination.
	CopyWrite = 0x03,
	/// Indirect compute dispatch commands.
	DispatchIndirect = 0x04,
	/// Indirect command arguments.
	DrawIndirect = 0x05,
	/// Vertex array indices.
	ElementArray = 0x06,
	/// Pixel read target.
	PixelPack = 0x07,
	/// Texture data source.
	PixelUnpack = 0x08,
	/// Query result buffer.
	Query = 0x09,
	/// Read-write storage for shaders.
	ShaderStorage = 0x0A,
	/// Texture data buffer.
	Texture = 0x0B,
	/// Transform feedback buffer.
	TransformFeedback = 0x0C,
	/// Uniform block storage.
	Uniform = 0x0D
}
///
abstract class VideoBuffer {
	protected {
        uint _buffer;
        size_t _size;
        uint _target;
        uint _usage;
        bool _firstLoad;
        bool _initialized;
    }
    ///
    size_t getSize() pure const nothrow;
	///
	void setData(T)(T[] buffer) {
		setData(buffer.length * T.sizeof, buffer.ptr);
	}
	///
	void setData(size_t size, void* data);
	///
	void setSubData(size_t offset, size_t size, void* data);
	///
	void getSubData(size_t offset, size_t size, void* data);
	///
	ubyte[] getBytes();
	///
	void bind();
	///
	void unbind();
	///
	uint getHandle() pure const nothrow;
}