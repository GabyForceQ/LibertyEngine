/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/components/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.components.renderer;

import liberty.objects.node;
import liberty.model;
import liberty.surface.ui.frame;
import liberty.surface.ui.widget;
import liberty.graphics.vertex;
import liberty.components.meta;
import liberty.surface.model;

/**
 *
**/
@Component
class Renderer(VERTEX, NODETYPE = SceneNode) {
  private {
    static if (is(VERTEX == GenericVertex))
      alias RendererModel = CoreModel;
    else static if (is(VERTEX == TerrainVertex))
      alias RendererModel = TerrainModel;
    else static if (is(VERTEX == UIVertex))
      alias RendererModel = SurfaceModel;

    static if (is(NODETYPE == SceneNode))
      alias RendererNode = SceneNode;
    else static if (is(NODETYPE == Frame))
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
    static if (is(VERTEX == GenericVertex))
      parent.getScene().getcoreShader().loadModelMatrix(parent.getTransform().getModelMatrix());
    else static if (is(VERTEX == TerrainVertex))
      parent.getScene().getTerrainShader().loadModelMatrix(parent.getTransform().getModelMatrix());
    else static if (is(VERTEX == UIVertex))
      parent.getFrame().getScene().getSurfaceShader().loadModelMatrix(parent.getTransform().getModelMatrix());
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
   * Returns reference to this.
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