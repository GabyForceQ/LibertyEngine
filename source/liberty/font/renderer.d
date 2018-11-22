/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/font/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.font.renderer;

import liberty.scene;
import liberty.font.shader;
import liberty.services;

/**
 * Class holding basic font rendering methods.
 * It contains references to the $(D FontSystem) and $(D Scene).
 * It implements $(D IRenderable) service.
**/
final class FontRenderer /*: IRenderable*/ {
  private {
    FontShader shader;
    Scene scene;
  }

  /**
   * Create and initialize font renderer using a $(D FontSystem) reference and a $(D Scene) reference.
  **/
  this(Scene scene) {
    shader = new FontShader();
    this.scene = scene;
  }

  /**
   * Render all font elements to the screen.
  **/
  /*
  void render(FontMap[string] fontMap) {
    shader.bind();
    
    foreach (font; fontMap)
      font.render();

    shader.unbind();
  }*/

  /**
   * Returns a font shader reference.
  **/
  FontShader getShader() pure nothrow {
    return shader;
  }
}