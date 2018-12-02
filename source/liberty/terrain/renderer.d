/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/terrain/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.terrain.renderer;

import liberty.constants;
import liberty.graphics.shader.constants;
import liberty.graphics.shader.graph;
import liberty.services;
import liberty.scene;
import liberty.terrain.impl;
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
    auto camera = scene.getActiveCamera;

    GfxShaderGraph
      .getDefaultShader(GfxShaderGraphDefaultType.TERRAIN)
      .getProgram
      .bind
      .loadUniform("uProjectionMatrix", camera.getProjectionMatrix)
      .loadUniform("uViewMatrix", camera.getViewMatrix)
      .loadUniform("uSkyColor", scene.getWorld.getExpHeightFogColor);
    
    foreach (terrain; system.getMap)
      if (terrain.getVisibility == Visibility.Visible)
        render(terrain);

    GfxShaderGraph
      .getDefaultShader(GfxShaderGraphDefaultType.TERRAIN)
      .getProgram
      .unbind;
  }

  /**
   * Render a terrain node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  TerrainRenderer render(Terrain terrain)
  in (terrain !is null, "You cannot render a null terrain.")
  do {
    auto model = terrain.getModel;

    if (model !is null)
      GfxShaderGraph
        .getDefaultShader(GfxShaderGraphDefaultType.TERRAIN)
        .getProgram
        .loadUniform("uModelMatrix", terrain.getTransform.getModelMatrix)
        .loadUniform("uTexCoordMultiplier", terrain.getTexCoordMultiplier)
        .render(model);
      
    return this;
  }
}