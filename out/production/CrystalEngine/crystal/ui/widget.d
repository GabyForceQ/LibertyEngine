/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.ui.widget;
import crystal.core.scenegraph.node: Node;
import crystal.core.scenegraph.entity: Entity;
/// An Widget is a 2d element on the screen.
/// It doesn't depends on world camera.
abstract class Widget : Entity {
	/// Default constructor.
    this(string id, Node parent) nothrow {
        super(id, parent);
    }
    override void render() {}
}