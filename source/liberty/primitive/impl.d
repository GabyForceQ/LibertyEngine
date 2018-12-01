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
import liberty.model.impl;
import liberty.primitive.vertex;

/**
 *
**/
abstract class Primitive : SceneNode {
  private {
    Model model;
  }

  /**
   *
  **/
  this(string id, SceneNode parent) {
    super(id, parent);
  }

  /**
   * Set the 3D model of the primitive.
   * Returns reference to this so it can be used in a stream.
  **/
  final typeof(this) setModel(Model model) pure nothrow {
    this.model = model;
    return this;
  }

  /**
   * Returns the 3D model of the primitive.
  **/
  final Model getModel() pure nothrow {
    return model;
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