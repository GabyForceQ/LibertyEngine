/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.core.scenegraph.entity;
import liberty.core.scenegraph.node: Node;
import liberty.graphics.renderer: Renderable;
import liberty.graphics.renderer: Vertex;
import liberty.core.components: Renderer, Transform;
/// An entity has a render component.
abstract class Entity : Node, Renderable {
	private {
		Renderer!Vertex _renderComponent;
    }
	/// Default constructor.
    this(string id, Node parent) nothrow {
        super(id, parent);
    }
    /// Returns a reference to the render component.
    ref Renderer!Vertex renderer() pure nothrow {
        return _renderComponent;
    }
    ///
    override void render() {}
}
