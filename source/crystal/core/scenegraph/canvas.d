/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.core.scenegraph.canvas;
version (none):
import crystal.core.scenegraph.services : ListenerServices;
import crystal.core.scenegraph.node : NodeObject;
import crystal.core.scenegraph.scene : Scene;
import crystal.math.vector : Vector3F, Vector4F;
import crystal.core.geometry.shapes;
import crystal.core.config : CoreEngineException;
///
abstract class Canvas : Widget { // TODO: Not abstract, not final.
	protected {
		bool _canListen = false;
		Vector4F _fillColor;
		Shape _shape;
		// TODO: CollisionShape _collisionShape;
	}
	///
    this(string id, Node parent) {
        super(id, parent);
        _shape = getScene().spawn!RectangleShape("shape"); // TODO. Algorithm for a new id. Maybe count instances with static?
    }
    ///
    this(string id, ShapeForm shape_form, Node parent) {
        super(id, parent);
        switch (shape_form) with (ShapeForm) {
            case Rectangle:
                _shape = getScene().spawn!RectangleShape("shape"); // TODO. Algorithm for a new id.
                break;
            //case Circe:
                //_shape = getScene().spawn!CircleShape("shape"); // TODO. Algorithm for a new id.
                //break;
            default:
                throw new CoreEngineException("Unsupported ShapeForm for Canvas element!");
        }
    }
    ///
    bool canListen() pure nothrow const {
        return _canListen;
    }
    ///
    void __setCanListen(bool __) { // TODO: remove.
        _canListen = __;
    }
    ///
    void stopListening() {}
    ///
    //override void render() {
    //    _shape.draw();
    //}
    ///
    Shape getShape() {
        return _shape;
    }
}
