/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/system.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.system;

import liberty.constants;
import liberty.scene.impl;
import liberty.surface.impl;
import liberty.surface.renderer;
import liberty.surface.shader;

/**
 * System class holding basic surface functionality.
 * It contains references to the $(D SurfaceRenderer), $(D SurfaceShader) and $(D Scene).
 * It also contains a map with all surfaces in the current scene.
**/
final class SurfaceSystem {
  private {
    SurfaceRenderer renderer;
    SurfaceShader shader;
    Surface[string] map;
    Scene scene;
  }

  /**
   * Create and initialize surface system using a $(D Scene) reference.
  **/
  this(Scene scene) {
    this.scene = scene;
    shader = new SurfaceShader;
    renderer = new SurfaceRenderer(this, scene);
  }

  /**
   * Register a surface node to the surface system.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) registerElement(Surface node) pure nothrow {
    map[node.getId] = node;
    return this;
  }

  /**
   * Remove the given surface node from the surface map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElement(Surface node) pure nothrow {
    map.remove(node.getId);
    return this;
  }

  /**
   * Remove the surface node that has the given id from the surface map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElementById(string id) pure nothrow {
    map.remove(id);
    return this;
  }

  /**
   * Returns all elements in the surface map.
  **/
  Surface[string] getMap() pure nothrow {
    return map;
  }

  /**
   * Returns the surface element in the map that has the given id.
  **/
  Surface getElementById(string id) pure nothrow {
    return map[id];
  }

  /**
   * Returns a surface renderer reference.
  **/
  SurfaceRenderer getRenderer() pure nothrow {
    return renderer;
  }

  /**
   * Returns a surface shader reference.
  **/
  SurfaceShader getShader() pure nothrow {
    return shader;
  }
}