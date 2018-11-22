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
import liberty.surface.system;

/**
 * Class holding basic surface rendering methods.
 * It contains references to the $(D SurfaceSystem) and $(D Scene).
 * It implements $(D IRenderable) service.
**/
final class SurfaceRenderer : IRenderable {
  private {
    SurfaceSystem system;
    Scene scene;
  }

  /**
   * Create and initialize surface renderer using a $(D SurfaceSystem) reference and a $(D Scene) reference.
  **/
  this(SurfaceSystem system, Scene scene) {
    this.system = system;
    this.scene = scene;
  }

  /**
   * Render all surface elements to the screen.
  **/
  void render() {
    system
      .getShader()
      .bind();
    
    foreach (surface; system.getMap())
      surface.render();

    system
      .getShader()
      .unbind();
  }
}