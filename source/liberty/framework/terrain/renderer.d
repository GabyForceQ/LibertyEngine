/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/terrain/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.terrain.renderer;

import liberty.graphics.shader.impl;
import liberty.framework.terrain.impl;
import liberty.scene.constants;
import liberty.scene.impl;
import liberty.scene.meta;
import liberty.scene.renderer;

/**
 * Class holding basic terrain rendering functionality.
 * It inherits from $(D, Renderer) class and implements $(D, IRenderable) service.
**/
final class TerrainRenderer : Renderer {
  mixin RendererConstructor!(q{
    shader = Shader.getOrCreate("Terrain");
  });

  /**
   * Render all terrain elements to the screen.
  **/
  void render(Scene scene) {
    auto camera = scene.getActiveCamera;

    shader
      .getProgram
      .bind
      .loadUniform("uProjectionMatrix", camera.getProjectionMatrix)
      .loadUniform("uViewMatrix", camera.getViewMatrix)
      .loadUniform("uSkyColor", scene.getWorld.getExpHeightFogColor);
    
    foreach (terrain; map)
      if (terrain.getVisibility == Visibility.Visible)
        render(cast(Terrain)terrain);

    shader.getProgram.unbind;
  }

  /**
   * Render a terrain node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) render(Terrain terrain)
  in (terrain !is null, "You cannot render a null terrain.")
  do {
    auto model = terrain.getModel;

    if (model !is null)
      shader
        .getProgram
        .loadUniform("uModelMatrix", terrain.getTransform.getModelMatrix)
        .loadUniform("uTexCoordMultiplier", terrain.getTexCoordMultiplier)
        .render(model);
      
    return this;
  }
}