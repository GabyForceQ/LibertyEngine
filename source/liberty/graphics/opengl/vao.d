/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/opengl/vao.d, _vao.d)
 * Documentation:
 * Coverage:
 */
// TODO: Optimize imports.
module liberty.graphics.opengl.vao;
version (__OpenGL__) :
import derelict.opengl : glGenVertexArrays, glDeleteVertexArrays, glBindVertexArray;
import liberty.graphics.engine;
import liberty.graphics.video.vao : VertexArray;
/// OpenGL Vertex Array Object.
final class GLVertexArray : VertexArray {
    /// Creates a Vertex Array Object.
    /// Throws $(D GLException) on error.
    this() @trusted {
        glGenVertexArrays(1, &_handle);
        GraphicsEngine.get.backend.runtimeCheck();
        _initialized = true;
    }
    /// Releases the OpenGL Vertex Array Object resource.
    ~this() @trusted {
        if (_initialized)  {
            debug import liberty.core.memory : ensureNotInGC;
            debug ensureNotInGC("GLVertexArrayObject");
            glDeleteVertexArrays(1, &_handle);
            _initialized = false;
        }
    }
    /// Uses this Vertex Array Object.
    /// Throws $(D GLException) on error.
    override void bind() @trusted {
        glBindVertexArray(_handle);
        GraphicsEngine.get.backend.runtimeCheck();
    }
    /// Unuses this Vertex Array Object.
    /// Throws $(D GLException) on error.
    override void unbind() @trusted {
        glBindVertexArray(0);
        GraphicsEngine.get.backend.runtimeCheck();
    }
    /// Returns wrapped OpenGL resource handle.
    override uint handle() pure nothrow const @safe @nogc @property {
        return _handle;
    }
}