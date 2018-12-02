/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/terrain/system.d)
 * Documentation:
 * Coverage:
**/
module liberty.terrain.system;

import liberty.constants;
import liberty.scene;
import liberty.terrain.renderer;
import liberty.terrain.impl;

/**
 * System class holding basic terrain functionality.
 * It contains references to the $(D TerrainRenderer), $(D TerrainShader) and $(D Scene).
 * It also contains a map with all terrains in the current scene.
**/
final class TerrainSystem {
  private {
    TerrainRenderer renderer;
    Terrain[string] map;
    Scene scene;
  }

  /**
   * Create and initialize terrain system using a $(D Scene) reference.
  **/
  this(Scene scene) {
    this.scene = scene;
    renderer = new TerrainRenderer(this, scene);
  }

  /**
   * Register a terrain node to the terrain system.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) registerElement(Terrain node) pure nothrow {
    map[node.getId()] = node;
    return this;
  }

  /**
   * Remove the given terrain node from the terrain map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElement(Terrain node) pure nothrow {
    map.remove(node.getId);
    return this;
  }

  /**
   * Remove the terrain node that has the given id from the terrain map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElementById(string id) pure nothrow {
    map.remove(id);
    return this;
  }

  /**
   * Returns all elements in the terrain map.
  **/
  Terrain[string] getMap() pure nothrow {
    return map;
  }

  /**
   * Returns the terrain element in the map that has the given id.
  **/
  Terrain getElementById(string id) pure nothrow {
    return map[id];
  }

  /**
   * Returns a terrain renderer reference.
  **/
  TerrainRenderer getRenderer() pure nothrow {
    return renderer;
  }
}