/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/light/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.light.renderer;

import liberty.logger.impl;
import liberty.framework.light.impl;
import liberty.graphics.shader.impl;
import liberty.scene.constants;
import liberty.scene.impl;
import liberty.scene.meta;
import liberty.scene.renderer;

/**
 * Class holding basic light rendering functionality.
 * It inherits from $(D, Renderer) class and implements $(D, IRenderable) service.
**/
final class LightRenderer : Renderer {
  mixin RendererConstructor;

  /**
   * Render all lights to the screen.
  **/
  void render(Scene scene) {
    foreach (id; ["Primitive", "Terrain"]) {
      Shader
        .getOrCreate(id)
        .getProgram
        .bind;

      foreach (light; map)
        if (light.getVisibility == Visibility.Visible)
          applyTo(cast(Light)light, id);
      
      Shader
        .getOrCreate(id)
        .getProgram
        .unbind;
    }
  }

  /**
   * Apply light to a primitive or terrain.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) applyTo(Light light, string shaderId)
  in (shaderId == "Primitive" || shaderId == "Terrain",
    "You can apply light only on primitives and terrains.")
  do {
    import std.conv : to;

    uint index = light.getIndex;

    if (index < 4) {
      Shader
        .getOrCreate(shaderId)
        .getProgram
        .loadUniform("uLightPosition[" ~ index.to!string ~ "]", light.getTransform.getLocation)
        .loadUniform("uLightColor[" ~ index.to!string ~ "]", light.getColor)
        .loadUniform("uLightAttenuation[" ~ index.to!string ~ "]", light.getAttenuation)
        .loadUniform("uShineDamper", 1.0f)
        .loadUniform("uReflectivity", 0.0f);
    } else
      Logger.warning(shaderId ~ " shader can't render more than 4 lights.", typeof(this).stringof);

    return this;
  }
}