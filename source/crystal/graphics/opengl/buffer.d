/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
// TODO: optimize imports
module crystal.graphics.opengl.buffer;
version (__OpenGL__) :
import derelict.opengl;
import crystal.graphics.renderer;
import crystal.graphics.video.buffer : VideoBuffer;
/// OpenGL Buffer.
final class GLBuffer : VideoBuffer {
    /// Creates an empty buffer.
    /// Throws: $(D GLException) on error.
    this(uint target, uint usage) {
        _usage = usage;
        _target = target;
        _firstLoad = true;
        glGenBuffers(1, &_buffer);
        GraphicsEngine.getBackend().runtimeCheck();
        _initialized = true;
        _size = 0;
    }
    /// Creates a buffer already filled with data.
    /// Throws: $(D GLException) on error.
    this(T)(uint target, uint usage, T[] buffer) {
        this(target, usage);
        setData(buffer);
    }
    /// Releases the OpenGL buffer resource.
    ~this() {
        if (_initialized) {
            debug import crystal.core.memory : ensureNotInGC;
            debug ensureNotInGC("GLBuffer");
            glDeleteBuffers(1, &_buffer);
            _initialized = false;
        }
    }
    /// Returns the size of the buffer in bytes.
    override size_t getSize() pure const nothrow {
        return _size;
    }
    /// Returns the copy bytes to the buffer.
    /// Throws: $(D OpenGLException) on error.
    void setData(T)(T[] buffer) {
        setData(buffer.length * T.sizeof, buffer.ptr);
    }
    /// Returns the copy bytes to the buffer.
    /// Throws: $(D GLException) on error.
    override void setData(size_t size, void* data) {
        bind();
        _size = size;
        if (!_firstLoad) {
            glBufferData(_target, size, null, _usage);
            glBufferSubData(_target, 0, size, data);
        } else {
            glBufferData(_target, size, data, _usage);
		}
        GraphicsEngine.getBackend().runtimeCheck();
        _firstLoad = false;
    }
    /// Copies bytes to a sub-part of the buffer. You can't adress data beyond the buffer's size.
    /// Throws: $(D GLException) on error.
    override void setSubData(size_t offset, size_t size, void* data) {
        bind();
        glBufferSubData(_target, offset, size, data);
        GraphicsEngine.getBackend().runtimeCheck();
    }

    /// Gets a sub-part of a buffer.
    /// Throws: $(D GLException) on error.
    override void getSubData(size_t offset, size_t size, void* data) {
        bind();
        glGetBufferSubData(_target, offset, size, data);
        GraphicsEngine.getBackend().runtimeCheck();
    }

    /// Gets the whole buffer content in a newly allocated array.
    /// <b>This is intended for debugging purposes.</b>
    /// Throws: $(D GLException) on error.
    override ubyte[] getBytes() {
        auto buffer = new ubyte[_size];
        getSubData(0, _size, buffer.ptr);
        return buffer;
    }
    /// Binds this buffer.
    /// Throws: $(D GLException) on error.
    override void bind() {
        glBindBuffer(_target, _buffer);
        GraphicsEngine.getBackend().runtimeCheck();
    }
    /// Unbinds this buffer.
    /// Throws: $(D GLException) on error.
    override void unbind() {
        glBindBuffer(_target, 0);
    }
    /// Returns: Wrapped OpenGL resource handle.
    override uint getHandle() pure const nothrow {
        return _buffer;
    }
}