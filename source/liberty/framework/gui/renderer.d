/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/gui/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.gui.renderer;

import liberty.graphics.shader.graph;
import liberty.framework.gui.impl;
import liberty.scene.constants;
import liberty.scene.meta;
import liberty.scene.renderer;

/**
 * Class holding basic gui rendering functionality.
 * It inherits from $(D, Renderer) class and implements $(D, IRenderable) service.
**/
final class GuiRenderer : Renderer {
  mixin RendererConstructor!(q{
    shader = GfxShaderGraph.getShader("Gui");
  });

  /**
   * Render all gui elements to the screen.
  **/
  void render() {
    shader.getProgram.bind;
    
    foreach (gui; map)
      if (gui.getVisibility == Visibility.Visible)
        render(cast(Gui)gui);

    shader.getProgram.unbind;
  }

  /**
   * Render a gui node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) render(Gui gui) 
  in (gui !is null, "You cannot render a null gui.")
  do {
    return this;
  }
}