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
 *
**/
final class PrimitiveSystem {
  private {
    PrimitiveRenderer renderer;
    PrimitiveShader shader;
    Primitive[string] primitiveMap;
    Scene scene;
  }

  /**
   * Create and initialize primitive system.
  **/
  this(Scene scene) {
    this.scene = scene;
    renderer = new PrimitiveRenderer(this, scene);
    shader = new PrimitiveShader();
  }

  /**
   *
  **/
  PrimitiveSystem registerPrimitive(Primitive node) {
    primitiveMap[node.getId()] = node;
    return this;
  }

  /**
   *
  **/
  Primitive[string] getPrimitiveMap() pure nothrow {
    return primitiveMap;
  }

  /**
   *
  **/
  Primitive getPrimitive(string id) pure nothrow {
    return primitiveMap[id];
  }

  /**
   *
  **/
  PrimitiveRenderer getRenderer() pure nothrow {
    return renderer;
  }

  /**
   * Returns the default generic shader.
  **/
  PrimitiveShader getShader() {
    return shader;
  }
}