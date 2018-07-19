/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/world/canvas.d, _canvas.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.world.canvas;
import liberty.core.world.services : ListenerBody;
import liberty.core.world.node : Node;
import liberty.core.world.scene : Scene;
import liberty.core.math.vector : Vector3F, Vector4F;
import liberty.core.geometry.shapes;
import liberty.core.engine : CoreEngineException;
import liberty.core.ui.widget : Widget;
///
abstract class Canvas : Widget { // TODO: Not abstract, not final.
	protected {
		bool _canListen;
		Vector4F _fillColor;
		Shape _shape;
		// TODO: CollisionShape _collisionShape;
	}
	///
    this(string id, Node parent) {
        super(id, parent);
        _shape = spawn!RectangleShape("shape"); // TODO. Algorithm for a new id. Maybe count instances with static?
    }
    ///
    this(string id, ShapeForm shape_form, Node parent) {
        super(id, parent);
        switch (shape_form) with (ShapeForm) {
            case Rectangle:
                _shape = spawn!RectangleShape("shape"); // TODO. Algorithm for a new id.
                break;
            //case Circe:
                //_shape = spawn!CircleShape("shape"); // TODO. Algorithm for a new id.
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
    void __canListen(bool __) { // TODO: remove.
        _canListen = __;
    }
    ///
    override void stopListening() {}
    ///
    //override void render() {
    //    _shape.draw();
    //}
    ///
    Shape shape() {
        return _shape;
    }
}
