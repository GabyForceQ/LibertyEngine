/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/light/system.d)
 * Documentation:
 * Coverage:
**/
module liberty.light.system;

import liberty.light.point;
import liberty.light.renderer;
import liberty.scene.impl;

/**
 *
**/
final class LightingSystem {
  private {
    LightRenderer renderer;
    PointLight[string] lightMap;
    Scene scene;
  }

  /**
   * Create and initialize lighting system.
  **/
  this(Scene scene) {
    this.scene = scene;
    renderer = new LightRenderer(this, scene);
  }

  /**
   *
  **/
  LightingSystem registerLight(PointLight node) {
    lightMap[node.getId()] = node;
    return this;
  }

  /**
   *
  **/
  PointLight[string] getLightMap() pure nothrow {
    return lightMap;
  }

  /**
   *
  **/
  PointLight getLight(string id) pure nothrow {
    return lightMap[id];
  }

  /**
   *
  **/
  LightRenderer getRenderer() pure nothrow {
    return renderer;
  }
}