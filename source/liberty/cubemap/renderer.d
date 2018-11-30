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
import liberty.math.matrix;
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
    auto camera = scene.getActiveCamera;

    // Make it unreachable
    Matrix4F newViewMatrix = camera.getViewMatrix;
    newViewMatrix.c[0][3] = 0;
    newViewMatrix.c[1][3] = 0;
    newViewMatrix.c[2][3] = 0;

    system
      .getShader
      .bind
      .loadProjectionMatrix(camera.getProjectionMatrix)
      .loadViewMatrix(newViewMatrix)
      .loadFadeLowerLimit(0.0f)
      .loadFadeUpperLimit(30.0f)
      .loadFogColor(scene.getWorld.getExpHeightFogColor);

    foreach (cubeMap; system.getMap())
      if (cubeMap.getVisibility == Visibility.Visible)
        render(cubeMap);

    system.getShader.unbind;
  }

  /**
   * Render a cube map node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) render(CubeMap cubemap)
  in (cubemap !is null, "You cannot render a null cubemap.")
  do {
    auto model = cubemap.getModel;

    if (model !is null)
      system.getShader.render(model);
    
    return this;
  }
}