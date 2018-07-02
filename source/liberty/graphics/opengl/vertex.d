/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/opengl/vertex.d, _vertex.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.opengl.vertex;
version (__OpenGL__) :
import derelict.opengl;
import liberty.graphics.renderer;
import liberty.graphics.opengl.traits;
import std.string, std.typetuple, std.typecons, std.traits;
import liberty.math.vector;
import liberty.graphics.opengl.shader;
import liberty.graphics.video.vertex : VertexSpec;
/// Specify an attribute which has to be normalized.
struct Normalized;
/// Describe a Vertex structure.
/// You must instantiate it with a compile-time struct describing your vertex format.
final class GLVertexSpec(VERTEX) : VertexSpec!VERTEX {
	private {
		VertexAttribute[] _attributes;
	}
	/// Creates a vertex specification.
	this(GLShaderProgram shader_program) {
		alias TT = FieldTypeTuple!VERTEX;
		foreach (member; __traits(allMembers, VERTEX)) { // TODO: static foreach?
			static assert(member != "this", `Found a 'this' member in vertex struct. Use a 'static struct' instead.`);
			enum fullName = "VERTEX." ~ member;
			mixin("alias T = typeof(" ~ fullName ~ ");");
			static if (staticIndexOf!(T, TT) != -1) {
				int location = shader_program.attribute(member).location;
				mixin("enum size_t offset = VERTEX." ~ member ~ ".offsetof;");
				enum UDAs = __traits(getAttributes, member);
				bool normalize = false; //(staticIndexOf!(Normalized, UDAs) == -1); // TODO: -> not working @Normalized.
				int n;
				uint type;
				toGLTypeAndSize!T(type, n);
				_attributes ~= VertexAttribute(location, n, type, normalize ? 1 : 0, offset);
			}
		}
	}
	/// Use this vertex specification.
	override void use(uint divisor = 0) {
		for (uint i = 0; i < _attributes.length; i++) {
			_attributes[i].use(cast(int)vertexSize, divisor);
		}
	}
	/// Unuse this vertex specification.
	/// If you are using a VAO, you don't need to call it, since the attributes would be tied to the VAO activation.
    /// Throws: $(D GLException) on error.
	override void unuse() {
	    for (uint i = 0; i < _attributes.length; i++) {
	        _attributes[i].unuse();
	    }
	}
}
/// Represent an OpenGL program attribute.
final class GLAttribute {
	private {
        int _location;
        uint _type;
        int _size;
        string _name;
        bool _disabled;
    }
    ///
    enum int fakeLocation = -1;
    ///
    this(string name, int location, uint type, GLsizei size) {
        _name = name;
        _location = location;
        _type = type;
        _size = size;
        _disabled = false;
    }
    /// Creates a fake disabled attribute, designed to cope with attribute
    /// that have been optimized out by the OpenGL driver, or those which do not exist.
    this(string name) {
        _disabled = true;
        _location = fakeLocation;
        _type = GL_FLOAT; // whatever
        _size = 1;
        //s_gl._logger.warningf("Faking attribute '%s' which either does not exist in the shader program, or was discarded by the driver as unused", name);
    }
    ///
    int location() pure nothrow const @safe @nogc @property {
        return _location;
    }
	///
    string name() pure nothrow const @safe @nogc @property {
        return _name;
    }
}
/// Describes a single attribute in a vertex entry.
struct VertexAttribute {
	private {
		int _location;
		int _n;
		uint _type;
		ubyte _normalize; // boolean
		size_t _offset;
		bool _divisorSet;
	}
	/// Use this attribute.
    /// Throws: $(D GLException) on error.
	void use(int vertex_size, uint divisor) {
		if (_location == GLAttribute.fakeLocation) {
			return;
		}
		if (divisor != 0) {
			_divisorSet = true;
		}
		glEnableVertexAttribArray(_location);
		if (isVideoIntegerType(_type)) {
			glVertexAttribIPointer(_location, _n, _type, vertex_size, cast(void*)_offset);
		} else {
			glVertexAttribPointer(_location, _n, _type, _normalize, vertex_size, cast(void*)_offset);
		}
		GraphicsEngine.get.backend.runtimeCheck();
	}
	/// Unuse this attribute.
    /// Throws: $(D GLException) on error.
    void unuse() {
        if (_divisorSet) {
            glVertexAttribDivisor(_location, 0);
        }
        _divisorSet = false;
        glDisableVertexAttribArray(_location);
        GraphicsEngine.get.backend.runtimeCheck();
    }
}
/// Define a simple vertex type from a vector type.
align(1) struct VertexPosition(VECTOR, string FIELD_NAME = "position") if (isVector!VECTOR) {
	align(1):
	mixin("VECTOR " ~ FIELD_NAME ~ ";");
	static assert(VertexPosition.sizeof == VECTOR.sizeof);
}
///
unittest {
	static struct VertexTest {
		Vector3F position;
		Vector3F normal;
		Vector4F color;
		@Normalized Vector2I uv;
		float intensity;
	}
	alias Test1 = GLVertexSpec!VertexTest;
	alias Test2 = GLVertexSpec!(VertexPosition!Vector3F);
}