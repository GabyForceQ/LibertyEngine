/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/geometry/shapes.d, _shapes.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.geometry.shapes;
import liberty.core.engine : CoreEngine;
import liberty.core.component : Renderer;
import liberty.core.scene.meta : NodeBody;
import liberty.core.scene.entity : Entity;
import liberty.core.scene.node : Node;
import liberty.core.model : Models;
import liberty.graphics.util : RenderUtil;
import liberty.graphics.engine : DrawMode, VectorType, Vertex2;
///
abstract class Shape : Entity {
	///
    this(string id, Node parent) {
        super(id, parent);
    }
}
///
final class RectangleShape : Shape {
	mixin(NodeBody);
	///
	private static immutable constructor = q{
		renderer2DComponent = Renderer!Vertex2(this, Models.get.rectangleModel);
	};
	///
    override void render() {
        renderer2DComponent.pass(() @safe {
            RenderUtil.get.drawElements(DrawMode.Triangles, 6, VectorType.UnsignedInt);
        });
    }
}
///
enum ShapeForm: byte {
	///
	Rectangle = 0x00,
	///
	Circle = 0x01
}