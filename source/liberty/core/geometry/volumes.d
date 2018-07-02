/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/geometry/volumes.d, _volumes.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.geometry.volumes;
import liberty.core.engine : CoreEngine;
import liberty.core.components : Renderer;
import liberty.core.world.services : NodeServices, Constructor;
import liberty.core.world.entity : Entity;
import liberty.core.world.node : Node;
import liberty.core.model: Models;
import liberty.graphics.util : RenderUtil;
import liberty.graphics.renderer : DrawMode, VectorType, Vertex;
///
abstract class Volume : Entity {
    ///
    this(string id, Node parent) {
        super(id, parent);
    }
}
///
final class CubeVolume : Volume {
	mixin(NodeServices);
	///
	@Constructor 
    private void _() {
        renderer = Renderer!Vertex(this, Models.get.cubeModel);
	}
	///
    override void render() {
        renderer.pass(() @safe {
            RenderUtil.get.drawElements(DrawMode.Triangles, 36, VectorType.UnsignedInt);
        });
    }
}
