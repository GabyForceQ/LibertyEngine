/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/light/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.light.renderer;

import liberty.services;
import liberty.scene;

/**
 *
**/
final class LightRenderer : IRenderable {
  private {
    Scene scene;
  }

  /**
   *
  **/
  this(Scene scene) {
    this.scene = scene;
  }

  /**
   *
  **/
  void render() {
    scene.getTerrainShader().bind();
    
    // Apply lights to terrains
    foreach (light; scene.getLightMap())
      light.applyToTerrainMap(scene.getTerrainShader());

    scene.getTerrainShader().unbind();
    scene.getPrimitiveShader().bind();

    // Apply lights to primitives
    foreach (light; scene.getLightMap())
      light.applyToPrimitiveMap(scene.getPrimitiveShader());

    scene.getPrimitiveShader().unbind();
  }

  /**
   *
  **/
  Scene getScene() pure nothrow {
    return scene;
  }
}