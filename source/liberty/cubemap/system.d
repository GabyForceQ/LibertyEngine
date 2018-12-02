/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/cubemap/system.d)
 * Documentation:
 * Coverage:
**/
module liberty.cubemap.system;

import liberty.constants;
import liberty.scene;
import liberty.cubemap.renderer;
import liberty.cubemap.skybox;

/**
 * System class holding basic skybox functionality.
 * It contains references to the $(D CubeMapRenderer) and $(D Scene).
 * It also contains a map with all cubeMapes in the current scene.
**/
final class SkyBoxSystem {
  private {
    CubeMapRenderer renderer;
    SkyBox[string] map;
    Scene scene;
  }

  /**
   * Create and initialize cubeMap system using a $(D Scene) reference.
  **/
  this(Scene scene) {
    this.scene = scene;
    renderer = new CubeMapRenderer(this, scene);
  }

  /**
   * Register a cubeMap node to the cubeMap system.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) registerElement(SkyBox node) pure nothrow {
    map[node.getId] = node;
    return this;
  }

  /**
   * Remove the given cubemap node from the cubemap map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElement(SkyBox node) pure nothrow {
    map.remove(node.getId);
    return this;
  }

  /**
   * Remove the cubemap node that has the given id from the cubemap map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) removeElementById(string id) pure nothrow {
    map.remove(id);
    return this;
  }

  /**
   * Returns all elements in the cubeMap map.
  **/
  SkyBox[string] getMap() pure nothrow {
    return map;
  }

  /**
   * Returns the cubeMap element in the map that has the given id.
  **/
  SkyBox getElementById(string id) pure nothrow {
    return map[id];
  }

  /**
   * Returns a cubeMap renderer reference.
  **/
  CubeMapRenderer getRenderer() pure nothrow {
    return renderer;
  }

  /**
   * Returns the type of the system which is always SystemType.CubeMap.
   * See $(D SystemType) enumeration.
  **/
  static SystemType getType() pure nothrow {
    return SystemType.SkyBox;
  }
}