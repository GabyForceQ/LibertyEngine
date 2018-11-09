/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/font/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.font.renderer;

import liberty.font.shader;
import liberty.services;

/**
 *
**/
final class FontRenderer /*: IRenderable*/ {
  private {
    FontShader shader;
  }

  /**
   *
  **/
  this() {
    shader = new FontShader();
  }

  /**
   *
  **/
  /*
  void render(FontMap[string] fontMap) {
    shader.bind();
    
    foreach (font; fontMap)
      font.render();

    shader.unbind();
  }*/

  /**
   *
  **/
  FontShader getShader() pure nothrow {
    return shader;
  }
}