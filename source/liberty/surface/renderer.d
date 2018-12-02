/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.renderer;

version (none) :

import liberty.scene.services;
import liberty.scene.constants;
import liberty.scene.impl;
import liberty.surface.impl;

/**
 * Class holding basic surface rendering methods.
 * It contains references to the $(D SurfaceSystem) and $(D Scene).
 * It implements $(D IRenderable) service.
**/
final class SurfaceRenderer : IRenderable {
  private {
    Scene scene;
  }

  /**
   * Create and initialize surface renderer using a $(D SurfaceSystem) reference and a $(D Scene) reference.
  **/
  this(Scene scene) {
    this.scene = scene;
  }

  /**
   * Render all surface elements to the screen.
  **/
  void render() {
    system.getShader.bind;
    
    foreach (surface; system.getMap)
      if (surface.getVisibility == Visibility.Visible) {
        surface.updateProjection;
        render(surface);
      }

    system.getShader.unbind;
  }

  /**
   * Render a surface node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) render(Surface surface)
  in (surface !is null, "You cannot render a null surface.")
  do {
    foreach (widget; surface.getRootCanvas.getWidgets) {
      if (widget.getZIndex == 0) {
        if (widget.getVisibility == Visibility.Visible) {
          if (widget.getModel !is null)
            system
              .getShader
              .loadZIndex(0)
              .loadModelMatrix(widget.getTransform.getModelMatrix)
              .render(widget.getModel);
        }
      }
    }
    // FILTER Z INDEX FOR NOW WITH ONLY 0 AND 1 --> BUG
    foreach (widget; surface.getRootCanvas.getWidgets) {
      if (widget.getZIndex == 1) {
        if (widget.getVisibility == Visibility.Visible) {
          if (widget.getModel !is null)
            system
              .getShader
              .loadZIndex(1)
              .loadModelMatrix(widget.getTransform.getModelMatrix)
              .render(widget.getModel);
        }
      }
    }

    return this;
  }
}