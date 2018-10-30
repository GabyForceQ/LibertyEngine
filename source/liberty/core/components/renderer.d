/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/components/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.components.renderer;

import liberty.core.objects.node : SceneNode;
import liberty.core.model : GenericModel, TerrainModel, UIModel;
import liberty.core.ui.frame : Frame;
import liberty.core.ui.widget : Widget;
import liberty.graphics.vertex : GenericVertex, TerrainVertex, UIVertex;

/**
 *
**/
struct Renderer(VERTEX, NODETYPE = SceneNode) {
  private {
    static if (is(VERTEX == GenericVertex))
      alias RendererModel = GenericModel;
    else static if (is(VERTEX == TerrainVertex))
      alias RendererModel = TerrainModel;
    else static if (is(VERTEX == UIVertex))
      alias RendererModel = UIModel;

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
      parent.getScene().getGenericShader().loadModelMatrix(parent.getTransform().getModelMatrix());
    else static if (is(VERTEX == TerrainVertex))
      parent.getScene().getTerrainShader().loadModelMatrix(parent.getTransform().getModelMatrix());
    else static if (is(VERTEX == UIVertex))
      parent.getFrame().getScene().getUIShader().loadModelMatrix(parent.getModelMatrix());
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
  ref Renderer!(VERTEX, NODETYPE) setModel(RendererModel model) pure nothrow {
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