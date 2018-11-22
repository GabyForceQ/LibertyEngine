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
import liberty.model;
import liberty.surface.impl;
import liberty.surface.widget;
import liberty.scene.meta;
import liberty.surface.model;
import liberty.terrain;
import liberty.primitive.model;
import liberty.primitive.vertex;
import liberty.surface.vertex;
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

    static if (is(NODETYPE == SceneNode))
      alias RendererNode = SceneNode;
    else static if (is(NODETYPE == Surface))
      alias RendererNode = Widget;
    
    RendererNode parent;
    RendererModel model;
  }

  /**
   *
  **/
  this(RendererNode parent, RendererModel model) pure nothrow {
    this.parent = parent;
    this.model = model;
  }

  /**
   *
  **/
  void draw() {
    static if (is(VERTEX == PrimitiveVertex))
      parent
        .getScene()
        .getPrimitiveSystem()
        .getShader()
        .loadModelMatrix(
          parent
            .getTransform()
            .getModelMatrix()
        );
    else static if (is(VERTEX == TerrainVertex))
      parent
        .getScene()
        .getTerrainSystem()
        .getShader()
        .loadModelMatrix(
          parent
            .getTransform()
            .getModelMatrix()
        );
    else static if (is(VERTEX == SurfaceVertex))
      parent
        .getSurface()
        .getScene()
        .getSurfaceSystem()
        .getShader()
        .loadModelMatrix(
          parent
            .getTransform()
            .getModelMatrix()
        );
    else static if (is(VERTEX == CubeMapVertex)) {}
    else
      assert(0, "Unreachable");

    model.draw();
  }

  /**
   *
  **/
  RendererNode getParent() pure nothrow {
    return parent;
  }

  /**
   * Returns reference to this so it can be used in a stream.
  **/
  Renderer!(VERTEX, NODETYPE) setModel(RendererModel model) pure nothrow {
    this.model = model;
    return this;
  }

  /**
   *
  **/
  RendererModel getModel() pure nothrow {
    return model;
  }
}