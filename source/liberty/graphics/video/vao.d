/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/video/vao.d, _vao.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.video.vao;
/// Vertex Array Object.
abstract class VertexArray {
	protected {
        uint _handle;
        bool _initialized;
    }
    /// Uses this Vertex Array Object.
    void bind() @trusted;
    /// Unuses this Vertex Array Object.
    void unbind() @trusted;
    /// Returns resource handle.
    uint handle() pure nothrow const @safe @nogc @property;
}