/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/light/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.light.renderer;

import liberty.light.system;
import liberty.graphics.shader.constants;
import liberty.graphics.shader.graph;
import liberty.scene.services;
import liberty.scene;

/**
 * Class holding basic lighting rendering methods.
 * It contains references to the $(D LightingSystem) and $(D Scene).
 * It implements $(D IRenderable) service.
**/
final class LightingRenderer : IRenderable {
  private {
    LightingSystem system;
    Scene scene;
  }

  /**
   * Create and initialize lighting renderer using a $(D LightingSystem) reference and a $(D Scene) reference.
  **/
  this(LightingSystem system, Scene scene) {
    this.system = system;
    this.scene = scene;
  }

  /**
   * Render all lighting elements to the screen.
  **/
  void render() {
    with (GfxShaderGraphDefaultType)
      foreach (type; [TERRAIN, PRIMITIVE]) {
        GfxShaderGraph
          .getDefaultShader(type)
          .getProgram
          .bind;
        
        foreach (light; system.getMap)
          light.applyTo(type);

        GfxShaderGraph
          .getDefaultShader(type)
          .getProgram
          .unbind;
      }
  }
}