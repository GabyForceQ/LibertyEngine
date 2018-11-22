/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/primitive/system.d)
 * Documentation:
 * Coverage:
**/
module liberty.primitive.system;

import liberty.scene;
import liberty.primitive.shader;
import liberty.primitive.renderer;
import liberty.primitive.impl;

/**
 * System class holding basic primitive functionality.
 * It contains references to the $(D PrimitiveRenderer), $(D PrimitiveShader) and $(D Scene).
 * It also contains a map with all primitives in the current scene.
**/
final class PrimitiveSystem {
  private {
    PrimitiveRenderer renderer;
    PrimitiveShader shader;
    Primitive[string] map;
    Scene scene;
  }

  /**
   * Create and initialize primitive system using a $(D Scene) reference.
  **/
  this(Scene scene) {
    this.scene = scene;
    renderer = new PrimitiveRenderer(this, scene);
    shader = new PrimitiveShader();
  }

  /**
   * Register a primitive node to the primitive system.
   * Returns reference to this so it can be used in a stream.
  **/
  PrimitiveSystem registerElement(Primitive node) {
    map[node.getId()] = node;
    return this;
  }

  /**
   * Returns all elements in the primitive map.
  **/
  Primitive[string] getMap() pure nothrow {
    return map;
  }

  /**
   * Returns the primitive element in the map that has the given id.
  **/
  Primitive getElementById(string id) pure nothrow {
    return map[id];
  }

  /**
   * Returns a primitive renderer reference.
  **/
  PrimitiveRenderer getRenderer() pure nothrow {
    return renderer;
  }

  /**
   * Returns a primitive shader reference.
  **/
  PrimitiveShader getShader() pure nothrow {
    return shader;
  }
}