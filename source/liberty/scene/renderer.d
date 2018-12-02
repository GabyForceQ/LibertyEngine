/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.renderer;

import liberty.constants;
import liberty.graphics.shader;
import liberty.scene.impl;
import liberty.scene.node;
import liberty.scene.services;

/**
 * Renderer class holding basic rendering functionality.
 * It contains references to the $(D Scene).
 * It also contains a map with all types in the current scene.
 * It implements $(D IRenderable) service.
**/
abstract class Renderer : IRenderable {
  protected {
    GfxShaderGraph shader;
    SceneNode[string] map;
    Scene scene;
    string id;
  }

  /**
   * Create and initialize renderer using a $(D Scene) reference.
  **/
  protected this(string id, Scene scene) {
    this.id = id;
    this.scene = scene;
  }

  /**
   * Returns renderer's id.
  **/
  string getId() pure nothrow const {
    return id;
  }

  /**
   * Returns renderer's shader graph.
  **/
  GfxShaderGraph getShader() pure nothrow {
    return shader;
  }

  /**
   * Register a node to the renderer.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) registerElement(SceneNode node) pure nothrow {
    map[node.getId] = node;
    return this;
  }

  /**
   * Remove the given node from the map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElement(SceneNode node) pure nothrow {
    map.remove(node.getId);
    return this;
  }

  /**
   * Remove the node that has the given id from the map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElementById(string id) pure nothrow {
    map.remove(id);
    return this;
  }

  /**
   * Returns all elements in the map.
  **/
  SceneNode[string] getMap() pure nothrow {
    return map;
  }

  /**
   * Returns the element in the map that has the given id.
  **/
  SceneNode getElementById(string id) pure nothrow {
    return map[id];
  }
}