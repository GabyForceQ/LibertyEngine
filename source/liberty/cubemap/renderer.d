/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/cubemap/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.cubemap.renderer;

import liberty.scene;
import liberty.services;
import liberty.cubemap.system;

/**
 * Class holding basic cubeMap rendering methods.
 * It contains references to the $(D CubeMapSystem) and $(D Scene).
 * It implements $(D, IRenderable) service.
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
      .bind();

    foreach (cubeMap; system.getMap())
      cubeMap.render();

    system
      .getShader()
      .unbind();
  }
}