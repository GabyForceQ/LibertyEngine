/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/opengl/traits.d, _traits.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.opengl.traits;
version (__OpenGL__) :
import derelict.opengl;
import std.string, std.typetuple, std.typecons, std.traits;
import liberty.math.vector : Vector;
///
bool isVideoIntegerType(uint t) pure nothrow @safe @nogc {
	return (t == GL_BYTE || t == GL_UNSIGNED_BYTE || t == GL_SHORT || t == GL_UNSIGNED_SHORT || t == GL_INT || t == GL_UNSIGNED_INT);
}
///
alias VideoVectorTypes = TypeTuple!(byte, ubyte, short, ushort, int, uint, float, double);
///
enum uint[] GLVectorTypes = [GL_BYTE, GL_UNSIGNED_BYTE, GL_SHORT, GL_UNSIGNED_SHORT, GL_INT, GL_UNSIGNED_INT, GL_FLOAT, GL_DOUBLE];
///
template isSupportedScalarType(T) {
	enum isSupportedScalarType = staticIndexOf!(Unqual!T, GLVectorTypes) != -1;
}
///
template typeToGLScalar(T) {
	alias U = Unqual!T;
	enum index = staticIndexOf!(U, VectorTypes);
	static if (index == -1) {
        static assert(0, "Could not use " ~ T.stringof ~ " in a vertex description!");
    } else {
        enum typeToGLScalar = VectorTypesGL[index];
    }
}
///
void toGLTypeAndSize(T)(out uint type, out int n) {
    static if (isSupportedScalarType!T) {
        type = typeToGLScalar!T;
        n = 1;
    } else static if (isStaticArray!T) {
        type = typeToGLScalar!(typeof(T.init[0]));
        n = T.length;
    } else {
        alias U = Unqual!T;
        foreach(int t, S ; VideoVectorTypes) {
            static if (is (U == Vector!(S, 2))) {
                type = GLVectorTypes[t];
                n = 2;
                return;
            }
            static if (is (U == Vector!(S, 3))) {
                type = GLVectorTypes[t];
                n = 3;
                return;
            }
            static if (is (U == Vector!(S, 4))) {
                type = GLVectorTypes[t];
                n = 4;
                return;
            }
        }
        assert(false, "Could not use " ~ T.stringof ~ " in a vertex description.");
    }
}