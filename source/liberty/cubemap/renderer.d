/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/cubemap/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.cubemap.renderer;

import liberty.constants;
import liberty.cubemap.impl;
import liberty.cubemap.system;
import liberty.scene;
import liberty.services;

/**
 * Class holding basic cubeMap rendering methods.
 * It contains references to the $(D CubeMapSystem) and $(D Scene).
 * It implements $(D IRenderable) service.
**/
final class CubeMapRenderer : IRenderable {
  private {
    CubeMapSystem system;
    Scene scene;
  }

  /**
   * Create and initialize cubeMap renderer using a $(D CubeMapSystem) reference and a $(D Scene) reference.
  **/
  this(CubeMapSystem system, Scene scene) {
    this.system = system;
    this.scene = scene;
  }

  /**
   * Render the cubeMap to the screen.
  **/
  void render() {
    system
      .getShader()
      .bind()
      .loadProjectionMatrix(
        scene
          .getActiveCamera()
          .getProjectionMatrix())
      .loadViewMatrix(
        scene
          .getActiveCamera()
          .getViewMatrix());

    foreach (cubeMap; system.getMap())
      if (cubeMap.getVisibility() == Visibility.Visible)
        render(cubeMap);

    system
      .getShader()
      .unbind();
  }

  /**
   * Render a cube map node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) render(CubeMap cubemap) {
    if (cubemap.getModel() !is null)
      cubemap
        .getModel()
        .render();
    
    return this;
  }
}