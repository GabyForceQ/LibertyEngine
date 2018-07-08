/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/opengl/buffer.d, _buffer.d)
 * Documentation:
 * Coverage:
 */
// TODO: optimize imports
module liberty.graphics.opengl.buffer;
version (__OpenGL__) :
import derelict.opengl;
import liberty.graphics.engine;
import liberty.graphics.video.buffer : VideoBuffer;
/// OpenGL Buffer.
final class GLBuffer : VideoBuffer {
    /// Creates an empty buffer.
    /// Throws $(D GLException) on error.
    this(uint target, uint usage) @trusted {
        _usage = usage;
        _target = target;
        _firstLoad = true;
        glGenBuffers(1, &_buffer);
        GraphicsEngine.get.backend.runtimeCheck();
        _initialized = true;
        _size = 0;
    }
    /// Creates a buffer already filled with data.
    /// Throws $(D GLException) on error.
    this(T)(uint target, uint usage, T[] buffer) @trusted {
        this(target, usage);
        data = buffer;
    }
    /// Releases the OpenGL buffer resource.
    ~this() @trusted {
        if (_initialized) {
            debug import liberty.core.memory : ensureNotInGC;
            debug ensureNotInGC("GLBuffer");
            glDeleteBuffers(1, &_buffer);
            _initialized = false;
        }
    }
    /// Returns the size of the buffer in bytes.
    override size_t size() pure nothrow const @safe @nogc @property {
        return _size;
    }
    /// Returns the copy bytes to the buffer.
    /// Throws $(D OpenGLException) on error.
    void data(T)(T[] buffer) @trusted {
        setData(buffer.length * T.sizeof, buffer.ptr);
    }
    /// Returns the copy bytes to the buffer.
    /// Throws $(D GLException) on error.
    override void setData(size_t size, void* data) @trusted {
        bind();
        _size = size;
        if (!_firstLoad) {
            glBufferData(_target, size, null, _usage);
            glBufferSubData(_target, 0, size, data);
        } else {
            glBufferData(_target, size, data, _usage);
		}
        GraphicsEngine.get.backend.runtimeCheck();
        _firstLoad = false;
    }
    /// Copies bytes to a sub-part of the buffer. You can't adress data beyond the buffer's size.
    /// Throws $(D GLException) on error.
    override void setSubData(size_t offset, size_t size, void* data) @trusted {
        bind();
        glBufferSubData(_target, offset, size, data);
        GraphicsEngine.get.backend.runtimeCheck();
    }

    /// Gets a sub-part of a buffer.
    /// Throws $(D GLException) on error.
    override void getSubData(size_t offset, size_t size, void* data) @trusted {
        bind();
        glGetBufferSubData(_target, offset, size, data);
        GraphicsEngine.get.backend.runtimeCheck();
    }

    /// Gets the whole buffer content in a newly allocated array.
    /// <b>This is intended for debugging purposes.</b>
    /// Throws $(D GLException) on error.
    override ubyte[] bytes() @trusted {
        auto buffer = new ubyte[_size];
        getSubData(0, _size, buffer.ptr);
        return buffer;
    }
    /// Binds this buffer.
    /// Throws $(D GLException) on error.
    override void bind() @trusted {
        glBindBuffer(_target, _buffer);
        GraphicsEngine.get.backend.runtimeCheck();
    }
    /// Unbinds this buffer.
    /// Throws $(D GLException) on error.
    override void unbind() @trusted {
        glBindBuffer(_target, 0);
    }
    /// Returns wrapped OpenGL resource handle.
    override uint handle() pure nothrow const @safe @nogc @property {
        return _buffer;
    }
}