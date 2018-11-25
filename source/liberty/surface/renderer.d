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
import liberty.surface.impl;
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
      render(surface);

    system
      .getShader()
      .unbind();
  }

  /**
   * Render a surface node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  SurfaceRenderer render(Surface surface) {
    foreach (widget; surface.getRootCanvas().getWidgets()) {
      if (widget.getZIndex() == 0) {
        system
          .getShader()
          .loadZIndex(0)
          .loadModelMatrix(
            widget
              .getTransform()
              .getModelMatrix());
      
        widget.render();
      }
    }
    // FILTER Z INDEX FOR NOW WITH ONLY 0 AND 1 --> BUG
    foreach (widget; surface.getRootCanvas().getWidgets()) {
      if (widget.getZIndex() == 1) {
        system
          .getShader()
          .loadZIndex(0)
          .loadModelMatrix(
            widget
              .getTransform()
              .getModelMatrix());

        widget.render();
      }
    }

    return this;
  }
}