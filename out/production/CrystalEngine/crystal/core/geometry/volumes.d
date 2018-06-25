/**
* Module Author: Gabriel Gheorghe
* Last Modified: Version 0.0.1 (alpha)
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
