/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/light/system.d)
 * Documentation:
 * Coverage:
**/
module liberty.light.system;

import liberty.constants;
import liberty.light.point;
import liberty.light.renderer;
import liberty.scene.impl;

/**
 * System class holding basic ligthing functionality.
 * It contains references to the $(D LightingRenderer) and $(D Scene).
 * It also contains a map with all lights in the current scene.
**/
final class LightingSystem {
  private {
    LightingRenderer renderer;
    PointLight[string] map;
    Scene scene;
  }

  /**
   * Create and initialize ligthing system using a $(D Scene) reference.
  **/
  this(Scene scene) {
    this.scene = scene;
    renderer = new LightingRenderer(this, scene);
  }

  /**
   * Register a light node to the ligthing system.
   * Returns reference to this so it can be used in a stream.
  **/
  LightingSystem registerElement(PointLight node) pure nothrow {
    map[node.getId()] = node;
    return this;
  }

  /**
   * Remove the given light node from the light map.
   * Returns reference to this so it can be used in a stream.
  **/
  LightingSystem removeElement(PointLight node) pure nothrow {
    map.remove(node.getId());
    return this;
  }

  /**
   * Remove the light node that has the given id from the light map.
   * Returns reference to this so it can be used in a stream.
  **/
  LightingSystem removeElementById(string id) pure nothrow {
    map.remove(id);
    return this;
  }

  /**
   * Returns all elements in the ligthing map.
  **/
  PointLight[string] getMap() pure nothrow {
    return map;
  }

  /**
   * Returns the light element in the map that has the given id.
  **/
  PointLight getElementById(string id) pure nothrow {
    return map[id];
  }

  /**
   * Returns a lighting renderer reference.
  **/
  LightingRenderer getRenderer() pure nothrow {
    return renderer;
  }
}