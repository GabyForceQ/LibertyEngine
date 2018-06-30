/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.graphics.video.vertex;
///
abstract class VertexSpec(VERTEX) {
	///
	void use(uint divisor = 0);
	///
	void unuse();
	/// Returns the size of the Vertex.
    /// The size can be computed after you added all your attributes.
    size_t vertexSize() pure const nothrow @nogc @safe {
        return VERTEX.sizeof;
    }
}