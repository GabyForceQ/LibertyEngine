/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.core.geometry.volumes;
import crystal.core.engine: CoreEngine;
import crystal.core.components: Renderer;
import crystal.core.scenegraph.services: NodeServices, Constructor;
import crystal.core.scenegraph.entity: Entity;
import crystal.core.scenegraph.node: Node;
import crystal.core.model: Models;
import crystal.graphics.util: RenderUtil;
import crystal.graphics.renderer: DrawMode, VectorType, Vertex;
///
abstract class Volume: Entity {
    ///
    this(string id, Node parent) {
        super(id, parent);
    }
}
///
final class CubeVolume: Volume {
	mixin(NodeServices);
	///
	@Constructor private void _() {
        getRenderer() = Renderer!Vertex(this, Models.cubeModel);
	}
	///
    override void render() {
        getRenderer().pass((){
            RenderUtil.drawElements(DrawMode.Triangles, 36, VectorType.UnsignedInt);
        });
    }
}
