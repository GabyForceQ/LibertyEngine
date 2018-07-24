/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/component/renderer.d, _renderer.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.component.renderer;

import liberty.core.scene.node : Node;
import liberty.core.model : Model, Mesh;
import liberty.graphics.material : Material, Materials;
import liberty.core.component.meta : Component, ComponentBody, ComponentField;

/**
 *
 */
@Component
struct Renderer(VERTEX) {

	mixin(ComponentBody);

	private {
		Node _parent;
		Model!VERTEX _model;
		// Mesh reference from _model visible in editor.
		@ComponentField!("ReadWrite")("mesh", "mesh")
		Mesh _mesh;
		// Material reference from _model visible in editor.
		@ComponentField!("ReadWrite")("material", "material")
		Material _material;
	}

    /**
    *
    */
	this(Node parent, Model!VERTEX model) pure nothrow @safe @nogc {
		_parent = parent;
		_model = model;
		_mesh = _model.mesh;
		_material = _model.material;
	}

    /**
    *
    */
	void pass(void delegate() @safe drawCallback) @safe {
		_material.shader.loadUniform("model", _parent.transform.modelMatrix);
        _model.mesh.vao.bind();
        drawCallback();
        _model.mesh.vao.unbind();
	}

    /**
    *
    */
	Model!VERTEX model() pure nothrow @safe @nogc {
		return _model;
	}

    /**
    *
    */
	void mesh(Mesh mesh) pure nothrow @safe @nogc {
		_mesh = mesh;
		_model.mesh = _mesh;
	}

    /**
    *
    */
	void material(Material material) pure nothrow @safe @nogc {
		_material = material;
		_model.material(_material);
	}

    /**
    *
    */
	Mesh mesh() pure nothrow @safe @nogc {
		return _mesh;
	}

    /**
    *
    */
	Material material() pure nothrow @safe @nogc {
		return _material;
	}

}