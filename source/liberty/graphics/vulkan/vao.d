/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/vulkan/vao.d, _vao.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.vulkan.vao;
version (__Vulkan__) :
import liberty.graphics.video.vao : VertexArray;
/// Vulkan Vertex Array Object.
final class VKVertexArray : VertexArray {
    /// Creates a Vertex Array Object.
    /// Throws $(D VKException) on error.
    this() @trusted {
        GraphicsEngine.get.backend.runtimeCheck();
        _initialized = true;
    }
    /// Releases the Vulkan Vertex Array Object resource.
    ~this() @trusted {
        if (_initialized)  {
            debug import liberty.core.memory : ensureNotInGC;
            debug ensureNotInGC("VKVertexArrayObject");
            _initialized = false;
        }
    }
    /// Uses this Vertex Array Object.
    /// Throws $(D VKException) on error.
    override void bind() @trusted {
        GraphicsEngine.get.backend.runtimeCheck();
    }
    /// Unuses this Vertex Array Object.
    /// Throws $(D VKException) on error.
    override void unbind() @trusted {
        GraphicsEngine.get.backend.runtimeCheck();
    }
    /// Returns wrapped Vulkan resource handle.
    override uint handle() pure nothrow const @safe @nogc @property {
        return _handle;
    }
}