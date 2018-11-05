/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.renderer;

import liberty.services;
import liberty.scene;

/**
 *
**/
final class SurfaceRenderer : IRenderable {
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
    scene.getSurfaceShader().bind();
    
    foreach (surface; scene.getSurfaceMap())
      surface.render();

    scene.getSurfaceShader().unbind();
  }

  /**
   *
  **/
  Scene getScene() pure nothrow {
    return scene;
  }
}