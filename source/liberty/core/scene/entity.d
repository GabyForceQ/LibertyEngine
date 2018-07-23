/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/scene/entity.d, _entity.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.scene.entity;
import liberty.core.scene.node : Node;
import liberty.graphics.engine : IRenderable;
import liberty.graphics.engine : Vertex2, Vertex3;
import liberty.core.components : Renderer, Transform;
import std.typecons : Nullable;
/// An entity has a render component.
abstract class Entity : Node, IRenderable {
	private {
        Nullable!(Renderer!Vertex2) _render2DComponent;
		Nullable!(Renderer!Vertex3) _render3DComponent;
    }
	/// Default constructor.
    this(string id, Node parent) {
        super(id, parent);
        _render2DComponent.nullify();
        _render3DComponent.nullify();
    }
    /// Returns a reference to the render 2D component.
    ref Nullable!(Renderer!Vertex2) renderer2DComponent() pure nothrow @safe @nogc {
        return _render2DComponent;
    }
    /// Returns a reference to the render 3D component.
    ref Nullable!(Renderer!Vertex3) renderer3DComponent() pure nothrow @safe @nogc {
        return _render3DComponent;
    }
    /// Returns true if Entity has a renderer 2D component.
    bool hasRenderer2DComponent() pure nothrow const @safe @nogc {
        return !(_render2DComponent.isNull());
    }
    /// Returns true if Entity has a renderer 3D component.
    bool hasRenderer3DComponent() pure nothrow const @safe @nogc {
        return !(_render3DComponent.isNull());
    }
    ///
    override void render() {}
}
