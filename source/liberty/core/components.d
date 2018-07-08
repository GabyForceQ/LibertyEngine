/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/components.d, _components.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.components;
import liberty.core.world.node : Node;
import liberty.core.model : Model, Mesh;
import liberty.graphics.material : Material, Materials;
import liberty.math.vector : Vector3F;
import liberty.math.matrix : Matrix4F;
import liberty.math.functions : radians;
///
struct Component;
///
struct ComponentField(string access) {
	static if (access == "ReadWrite") {
		///
		string getMethod = "Unspecified";
		///
		string setMethod = "Unspecified";
	} else static if (access == "ReadOnly") {
		///
		string getMethod = "Unspecified";
	} else static if (access == "WriteOnly") {
		///
		string setMethod = "Unspecified";
	} else {
		static assert (0, "Unknown access type!");
	}
}
///
immutable ComponentServices = q{};
///
@Component
struct Renderer(VERTEX) {
	///
	mixin(ComponentServices);
	private {
		Node _parent;
		Model!VERTEX _model;
		/// Mesh reference from _model visible in editor.
		@ComponentField!("ReadWrite")("mesh", "mesh")
		Mesh _mesh;
		/// Material reference from _model visible in editor.
		@ComponentField!("ReadWrite")("material", "material")
		Material _material;
	}
	///
	this(Node parent, Model!VERTEX model) pure nothrow @safe @nogc {
		_parent = parent;
		_model = model;
		_mesh = _model.mesh;
		_material = _model.material;
	}
	///
	void pass(void delegate() @safe drawCallback) @safe {
		_material.shader.loadUniform("model", _parent.transform.modelMatrix);
        _model.mesh.vao.bind();
        drawCallback();
        _model.mesh.vao.unbind();
	}
	///
	Model!VERTEX model() pure nothrow @safe @nogc {
		return _model;
	}
	///
	void mesh(Mesh mesh) pure nothrow @safe @nogc {
		_mesh = mesh;
		_model.mesh = _mesh;
	}
	///
	void material(Material material) pure nothrow @safe @nogc {
		_material = material;
		_model.material(_material);
	}
	///
	Mesh mesh() pure nothrow @safe @nogc {
		return _mesh;
	}
	///
	Material material() pure nothrow @safe @nogc {
		return _material;
	}
}
///
@Component
struct Transform {
	private {
		Matrix4F _modelMatrix = Matrix4F().identity();
		Vector3F _position;
		Vector3F _rotation;
		Vector3F _scale;
		//Vector3F _angles;
		Node _parent;
	}
	///
	this(Node parent, Vector3F position = Vector3F.zero, Vector3F rotation = Vector3F.zero, Vector3F scale = Vector3F.one, float angle = 0.0f) pure nothrow @safe @nogc {
		_parent = parent;
		_position = position;
		//_rotation = rotation;
		//_scale = scale;
		_modelMatrix.translate(position);
		//_modelMatrix.rotate(angle, rotation);
		_modelMatrix.scale(scale);
	}
	///
	ref Transform translate(float x, float y, float z) pure nothrow @safe @nogc {
		_position += Vector3F(x, y, z);
		_modelMatrix.translate(Vector3F(x, y, z));
		return this;
	}
	///
	ref Transform translate(Vector3F translation) pure nothrow @safe @nogc {
		_position += translation;
		_modelMatrix.translate(translation);
		return this;
	}
	///
	void translateX(float value) pure nothrow @safe @nogc {
		_position += Vector3F(value, 0.0f, 0.0f);
		_modelMatrix.translate(Vector3F(value, 0.0f, 0.0f));
	}
	///
	void translateY(float value) pure nothrow @safe @nogc {
		_position += Vector3F(0.0f, value, 0.0f);
		_modelMatrix.translate(Vector3F(0.0f, value, 0.0f));
	}
	///
	void translateZ(float value) pure nothrow @safe @nogc {
		_position += Vector3F(0.0f, 0.0f, value);
		_modelMatrix.translate(Vector3F(0.0f, 0.0f, value));
	}
	///
	void rotate(float angle, float rotationX, float rotationY, float rotationZ) pure nothrow @safe @nogc {
		_modelMatrix.rotate(angle, Vector3F(rotationX, rotationY, rotationZ));
	}
	///
	void rotate(float angle, Vector3F rotation) pure nothrow @safe @nogc {
		_modelMatrix.rotate(angle, _rotation);
	}
	///
	void rotatePitch(float angle) pure nothrow @safe @nogc {
		_modelMatrix.rotateX(angle.radians);
	}
	///
	void rotateY(float angle) pure nothrow @safe @nogc {
		_modelMatrix.rotateY(angle);
	}
	///
	void rotateZ(float angle) pure nothrow @safe @nogc {
		_modelMatrix.rotateZ(angle);
	}
	///
	void scale(float x, float y, float z) pure nothrow @safe @nogc {
		_modelMatrix.scale(Vector3F(x, y, z));
	}
	///
	void scale(Vector3F scale) pure nothrow @safe @nogc {
		_modelMatrix.scale(scale);
	}
	///
	void scaleX(float value) pure nothrow @safe @nogc {
		_modelMatrix.scale(Vector3F(value, 0.0f, 0.0f));
	}
	///
	void scaleY(float value) pure nothrow @safe @nogc {
		_modelMatrix.scale(Vector3F(0.0f, value, 0.0f));
	}
	///
	void scaleZ(float value) pure nothrow @safe @nogc {
		_modelMatrix.scale(Vector3F(0.0f, 0.0f, value));
	}
	///
	ref const(Vector3F) position() pure nothrow const @safe @nogc @property {
		return _position;
	}
	///
	ref const(Vector3F) rotation() pure nothrow const @safe @nogc @property {
		return _rotation;
	}
	///
	ref const(Vector3F) scale() pure nothrow const @safe @nogc @property {
		return _scale;
	}
	///
	ref const(Matrix4F) modelMatrix() pure nothrow const @safe @nogc @property {
		return _modelMatrix;
	}
}