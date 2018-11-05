/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/primitive/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.primitive.renderer;

import liberty.services;
import liberty.scene;

/**
 *
**/
final class PrimitiveRenderer : IRenderable {
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
    scene.getPrimitiveShader().bind();
    
    foreach (primitive; scene.getPrimitiveMap())
      primitive.render();

    scene.getPrimitiveShader().unbind();
  }

  /**
   *
  **/
  Scene getScene() pure nothrow {
    return scene;
  }
}