/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/primitive/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.primitive.renderer;

import liberty.constants;
import liberty.graphics.shader.constants;
import liberty.graphics.shader.graph;
import liberty.framework.primitive.impl;
import liberty.scene.meta;
import liberty.scene.renderer;

/**
 * System class holding basic primitive rendering functionality.
**/
final class PrimitiveRenderer : Renderer {
  mixin RendererConstructor;

  /**
   * Render all primitive elements to the screen.
  **/
  void render() {
    auto camera = scene.getActiveCamera;

    GfxShaderGraph
      .getDefaultShader(GfxShaderGraphDefaultType.PRIMITIVE)
      .getProgram
      .bind
      .loadUniform("uProjectionMatrix", camera.getProjectionMatrix)
      .loadUniform("uViewMatrix", camera.getViewMatrix)
      .loadUniform("uSkyColor", scene.getWorld.getExpHeightFogColor);
    
    foreach (primitive; map)
      if (primitive.getVisibility == Visibility.Visible)
        render(cast(Primitive)primitive);

    GfxShaderGraph
      .getDefaultShader(GfxShaderGraphDefaultType.PRIMITIVE)
      .getProgram
      .unbind;
  }

  /**
   * Render a primitive node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) render(Primitive primitive) 
  in (primitive !is null, "You cannot render a null primitive.")
  do {
    auto model = primitive.getModel;

    if (model !is null)
      GfxShaderGraph
        .getDefaultShader(GfxShaderGraphDefaultType.PRIMITIVE)
        .getProgram
        .loadUniform("uModelMatrix", primitive.getTransform.getModelMatrix)
        .loadUniform("uUseFakeLighting", model.isFakeLightingEnabled)
        .render(model);
    
    return this;
  }
}