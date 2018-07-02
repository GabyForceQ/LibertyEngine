/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.ui.widget;
import liberty.core.scenegraph.node: Node;
import liberty.core.scenegraph.entity: Entity;
/// An Widget is a 2d element on the screen.
/// It doesn't depends on world camera.
abstract class Widget : Entity, IListener {
    ///
    protected bool _canListen;
    ///
    bool __canListen; // TODO: remove
	/// Default constructor.
    this(string id, Node parent) {
        super(id, parent);
    }
    override void render() {}
    ///
    void stopListening() {}
}
///
interface IListener {
    ///
    void stopListening();
}