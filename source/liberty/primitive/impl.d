/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/primitive/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.primitive.impl;

import liberty.logger;
import liberty.scene.node;
import liberty.primitive.vertex;
import liberty.services;
import liberty.graphics.renderer;

/**
 * A primitive has action mapping implemented.
**/
abstract class Primitive : SceneNode, IRenderable {
  protected {
    // Renderer component used for rendering a primitive vertex
    Renderer!PrimitiveVertex renderer;
  }

  /**
   *
  **/
  this(string id, SceneNode parent) {
    super(id, parent);
  }

  /**
   *
  **/
  override void render() {
    renderer.draw();
  }

  /**
   * Returns reference to the current renderer component.
  **/
  final Renderer!PrimitiveVertex getRenderer() {
    return renderer;
  }
}

/**
 *
**/
abstract class UniquePrimitive : Primitive {
  private static bool hasInstance;
  /**
   *
  **/
  this(string id, SceneNode parent) {
    if (this.hasInstance) {
      Logger.error(
        "Cannot have multiple instances", 
        typeof(this).stringof
      );
    }
    super(id, parent);
    this.hasInstance = true;
  }
}