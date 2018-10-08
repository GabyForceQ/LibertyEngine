/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/components/renderer.d, _renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.components.renderer;

import liberty.core.objects.node : WorldObject;
import liberty.core.model : Model;

/**
 *
**/
struct Renderer {
  private {
    WorldObject parent;
    Model model;
  }

  /**
   *
  **/
  this(WorldObject parent, Model model) {
    this.parent = parent;
    this.model = model;
  }

  /**
   *
  **/
  void draw() {
    model.getMaterial().getShader().loadUniform("uModelMatrix", parent.getTransform().getModelMatrix());
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
  Model getModel() {
    return model;
  }
}