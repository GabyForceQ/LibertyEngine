/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
// TODO: Optimize imports.
module crystal.graphics.opengl.vao;
version (__OpenGL__) :
import derelict.opengl : glGenVertexArrays, glDeleteVertexArrays, glBindVertexArray;
import crystal.graphics.renderer;
import crystal.graphics.video.vao : VertexArray;
/// OpenGL Vertex Array Object.
final class GLVertexArray : VertexArray {
    /// Creates a Vertex Array Object.
    /// Throws $(D GLException) on error.
    this() {
        glGenVertexArrays(1, &_handle);
        GraphicsEngine.getBackend().runtimeCheck();
        _initialized = true;
    }
    /// Releases the OpenGL Vertex Array Object resource.
    ~this() {
        if (_initialized)  {
            debug import crystal.core.memory : ensureNotInGC;
            debug ensureNotInGC("GLVertexArrayObject");
            glDeleteVertexArrays(1, &_handle);
            _initialized = false;
        }
    }
    /// Uses this Vertex Array Object.
    /// Throws $(D GLException) on error.
    override void bind() {
        glBindVertexArray(_handle);
        GraphicsEngine.getBackend().runtimeCheck();
    }
    /// Unuses this Vertex Array Object.
    /// Throws $(D GLException) on error.
    override void unbind() {
        glBindVertexArray(0);
        GraphicsEngine.getBackend().runtimeCheck();
    }
    /// Returns wrapped OpenGL resource handle.
    override uint handle() pure const nothrow {
        return _handle;
    }
}