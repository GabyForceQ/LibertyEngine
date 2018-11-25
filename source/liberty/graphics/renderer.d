/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.renderer;

import liberty.scene.node;
import liberty.primitive.model;
import liberty.primitive.vertex;
import liberty.surface.model;
import liberty.surface.vertex;
import liberty.terrain.model;
import liberty.terrain.vertex;
import liberty.cubemap.model;
import liberty.cubemap.vertex;

/**
 *
**/
class Renderer(VERTEX, NODETYPE = SceneNode) {
  private {
    static if (is(VERTEX == PrimitiveVertex))
      alias RendererModel = PrimitiveModel;
    else static if (is(VERTEX == TerrainVertex))
      alias RendererModel = TerrainModel;
    else static if (is(VERTEX == SurfaceVertex))
      alias RendererModel = SurfaceModel;
    else static if (is(VERTEX == CubeMapVertex))
      alias RendererModel = CubeMapModel;

    RendererModel model;
  }

  /**
   *
  **/
  this(RendererModel model) pure nothrow {
    this.model = model;
  }

  /**
   *
  **/
  void draw() {
    model.draw();
  }

  /**
   *
  **/
  RendererModel getModel() pure nothrow {
    return model;
  }
}