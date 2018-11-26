/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/text/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.text.renderer;

import liberty.constants;
import liberty.scene;
import liberty.services;
import liberty.text.impl;
import liberty.text.shader;
import liberty.text.system;

/**
 * Class holding basic text rendering methods.
 * It contains references to the $(D TextSystem) and $(D Scene).
 * It implements $(D IRenderable) service.
**/
final class TextRenderer : IRenderable {
  private {
    TextSystem system;
    Scene scene;
  }

  /**
   * Create and initialize text renderer using a $(D TextSystem) reference and a $(D Scene) reference.
  **/
  this(TextSystem system, Scene scene) {
    this.system = system;
    this.scene = scene;
  }

  /**
   * Render all text elements to the screen.
  **/
  void render() {
    system
      .getShader()
      .bind();
    
    foreach (text; system.getMap())
      if (text.getVisibility() == Visibility.Visible)
        render(text);

    system
      .getShader()
      .unbind();
  }

  /**
   * Render a text node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  TextRenderer render(Text text) {
    
    return this;
  }
}