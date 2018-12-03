/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.renderer;

import liberty.graphics.shader;
import liberty.scene.impl;
import liberty.scene.entity;
import liberty.scene.services;

/**
 * Renderer class holding basic rendering functionality.
 * It contains references to the $(D Scene).
 * It also contains a map with all types in the current scene.
 * It implements $(D IRenderable) service.
**/
abstract class Renderer : IRenderable {
  protected {
    Shader shader;
    Entity[string] map;
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
  Shader getShader() pure nothrow {
    return shader;
  }

  /**
   * Register a entity to the renderer.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) registerElement(Entity entity) pure nothrow {
    map[entity.getId] = entity;
    return this;
  }

  /**
   * Remove the given entity from the map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElement(Entity entity) pure nothrow {
    map.remove(entity.getId);
    return this;
  }

  /**
   * Remove the entity that has the given id from the map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElementById(string id) pure nothrow {
    map.remove(id);
    return this;
  }

  /**
   * Returns all elements in the map.
  **/
  Entity[string] getMap() pure nothrow {
    return map;
  }

  /**
   * Returns the element in the map that has the given id.
  **/
  Entity getElementById(string id) pure nothrow {
    return map[id];
  }
}