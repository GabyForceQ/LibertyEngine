/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/terrain/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.terrain.renderer;

import liberty.services;
import liberty.scene;
import liberty.terrain.system;

/**
 * Class holding basic terrain rendering methods.
 * It contains references to the $(D TerrainSystem) and $(D Scene).
 * It implements $(D IRenderable) service.
**/
final class TerrainRenderer : IRenderable {
  private {
    TerrainSystem system;
    Scene scene;
  }

  /**
   * Create and initialize terrain renderer using a $(D TerrainSystem) reference and a $(D Scene) reference.
  **/
  this(TerrainSystem system, Scene scene) {
    this.system = system;
    this.scene = scene;
  }

  /**
   * Render all terrain elements to the screen.
  **/
  void render() {
    system
      .getShader()
      .bind();
    
    foreach (terrain; system.getMap())
      terrain.render();

    system
      .getShader()
      .unbind();
  }
}