/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.core.components;
import liberty.core.scenegraph.node: Node;
import liberty.core.model: Model, Mesh;
import liberty.graphics.material: Material, Materials;
import liberty.math.vector: Vector3F;
import liberty.math.matrix: Matrix4F;
import liberty.math.functions: radians;
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
	this(Node parent, Model!VERTEX model) {
		_parent = parent;
		_model = model;
		_mesh = _model.mesh;
		_material = _model.material;
	}
	///
	void pass(void delegate() drawCallback) {
		_material.shader.loadUniform("model", _parent.transform.modelMatrix);
        _model.mesh.vao.bind();
        drawCallback();
        _model.mesh.vao.unbind();
	}
	///
	Model!VERTEX model() pure nothrow {
		return _model;
	}
	///
	void mesh(Mesh mesh) {
		_mesh = mesh;
		_model.mesh(_mesh);
	}
	///
	void material(Material material) {
		_material = material;
		_model.material(_material);
	}
	///
	Mesh mesh() {
		return _mesh;
	}
	///
	Material material() {
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
	this(Node parent, Vector3F position = Vector3F.zero, Vector3F rotation = Vector3F.zero, Vector3F scale = Vector3F.one, float angle = 0.0f) nothrow {
		_parent = parent;
		_position = position;
		//_rotation = rotation;
		//_scale = scale;
		_modelMatrix.translate(position);
		//_modelMatrix.rotate(angle, rotation);
		_modelMatrix.scale(scale);
	}
	///
	ref Transform translate(float x, float y, float z) {
		_position += Vector3F(x, y, z);
		_modelMatrix.translate(Vector3F(x, y, z));
		return this;
	}
	///
	ref Transform translate(Vector3F translation) {
		_position += translation;
		_modelMatrix.translate(translation);
		return this;
	}
	///
	void translateX(float value) {
		_position += Vector3F(value, 0.0f, 0.0f);
		_modelMatrix.translate(Vector3F(value, 0.0f, 0.0f));
	}
	///
	void translateY(float value) {
		_position += Vector3F(0.0f, value, 0.0f);
		_modelMatrix.translate(Vector3F(0.0f, value, 0.0f));
	}
	///
	void translateZ(float value) {
		_position += Vector3F(0.0f, 0.0f, value);
		_modelMatrix.translate(Vector3F(0.0f, 0.0f, value));
	}
	///
	void rotate(float angle, float rotationX, float rotationY, float rotationZ) {
		_modelMatrix.rotate(angle, Vector3F(rotationX, rotationY, rotationZ));
	}
	///
	void rotate(float angle, Vector3F rotation) {
		_modelMatrix.rotate(angle, _rotation);
	}
	///
	void rotatePitch(float angle) {
		_modelMatrix.rotateX(angle.radians);
	}
	///
	void rotateY(float angle) {
		_modelMatrix.rotateY(angle);
	}
	///
	void rotateZ(float angle) {
		_modelMatrix.rotateZ(angle);
	}
	///
	void scale(float x, float y, float z) {
		_modelMatrix.scale(Vector3F(x, y, z));
	}
	///
	void scale(Vector3F scale) {
		_modelMatrix.scale(scale);
	}
	///
	void scaleX(float value) {
		_modelMatrix.scale(Vector3F(value, 0.0f, 0.0f));
	}
	///
	void scaleY(float value) {
		_modelMatrix.scale(Vector3F(0.0f, value, 0.0f));
	}
	///
	void scaleZ(float value) {
		_modelMatrix.scale(Vector3F(0.0f, 0.0f, value));
	}
	///
	ref const(Vector3F) position() pure nothrow @safe @nogc {
		return _position;
	}
		///
	ref const(Vector3F) rotation() pure nothrow @safe @nogc {
		return _rotation;
	}
	///
	ref const(Vector3F) scale() pure nothrow @safe @nogc {
		return _scale;
	}
	///
	ref const(Matrix4F) modelMatrix() pure nothrow @safe @nogc {
		return _modelMatrix;
	}
}