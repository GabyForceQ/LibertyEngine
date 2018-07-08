/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/world/entity.d, _entity.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.world.entity;
import liberty.core.world.node : Node;
import liberty.graphics.engine : IRenderable;
import liberty.graphics.engine : Vertex;
import liberty.core.components : Renderer, Transform;
/// An entity has a render component.
abstract class Entity : Node, IRenderable {
	private {
		Renderer!Vertex _renderComponent;
    }
	/// Default constructor.
    this(string id, Node parent) {
        super(id, parent);
    }
    /// Returns a reference to the render component.
    ref Renderer!Vertex renderer() pure nothrow {
        return _renderComponent;
    }
    ///
    override void render() {}
}
