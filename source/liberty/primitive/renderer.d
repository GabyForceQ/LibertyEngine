/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/primitive/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.primitive.renderer;

import liberty.primitive.system;
import liberty.services;
import liberty.scene;

/**
 * Class holding basic primitive rendering methods.
 * It contains references to the $(D PrimitiveSystem) and $(D Scene).
 * It implements $(D, IRenderable) service.
**/
final class PrimitiveRenderer : IRenderable {
  private {
    PrimitiveSystem system;
    Scene scene;
  }

  /**
   * Create and initialize primitive renderer using a $(D PrimitiveSystem) reference and a $(D Scene) reference.
  **/
  this(PrimitiveSystem system, Scene scene) {
    this.system = system;
    this.scene = scene;
  }

  /**
   * Render all primitive elements to the screen.
  **/
  void render() {
    system
      .getShader()
      .bind();
    
    foreach (primitive; system.getMap())
      primitive.render();

    system
      .getShader()
      .unbind();
  }
}