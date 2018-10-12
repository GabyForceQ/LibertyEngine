/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/components/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.components.renderer;

import liberty.core.objects.node : WorldObject;
import liberty.core.model : GenericModel, TerrainModel;
import liberty.graphics.vertex : GenericVertex, TerrainVertex;

/**
 *
**/
struct Renderer(VERTEX) {
  private {
    WorldObject parent;

    static if (is(VERTEX == GenericVertex)) {
      GenericModel model;
      alias RendererModel = GenericModel;
    } else static if (is(VERTEX == TerrainVertex)) {
      TerrainModel model;
      alias RendererModel = TerrainModel;
    }
  }

  /**
   *
  **/
  this(WorldObject parent, RendererModel model) {
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
    else
      assert(0, "Unreachable");

    model.draw();
  }

  /**
   *
  **/
  WorldObject getParent() {
    return parent;
  }

  /**
   *
  **/
  ref Renderer!VERTEX setModel(RendererModel model) {
    this.model = model;
    return this;
  }

  /**
   *
  **/
  RendererModel getModel() {
    return model;
  }
}