/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/video/vertex.d, _vertex.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.video.vertex;
///
abstract class VertexSpec(VERTEX) {
	///
	void use(uint divisor = 0) @safe;
	///
	void unuse() @safe;
	/// Returns the size of the Vertex.
    /// The size can be computed after you added all your attributes.
    size_t vertexSize() pure nothrow const @safe @nogc {
        return VERTEX.sizeof;
    }
}