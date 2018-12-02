/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/skybox/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.skybox.renderer;

import liberty.graphics.shader.graph;
import liberty.framework.skybox.impl;
import liberty.math.matrix;
import liberty.scene.constants;
import liberty.scene.meta;
import liberty.scene.renderer;

/**
 * Class holding basic sky box rendering functionality.
 * It inherits from $(D, Renderer) class and implements $(D, IRenderable) service.
**/
final class SkyBoxRenderer : Renderer {
  mixin RendererConstructor!(q{
    shader = GfxShaderGraph.getShader("SkyBox");
  });

  /**
   * Render the sky box to the screen.
  **/
  void render() {
    auto camera = scene.getActiveCamera;

    // Make it unreachable
    Matrix4F newViewMatrix = camera.getViewMatrix;
    newViewMatrix.c[0][3] = 0;
    newViewMatrix.c[1][3] = 0;
    newViewMatrix.c[2][3] = 0;

    shader
      .getProgram
      .bind
      .loadUniform("uProjectionMatrix", camera.getProjectionMatrix)
      .loadUniform("uViewMatrix", newViewMatrix)
      .loadUniform("uFadeLowerLimit", 0.0f)
      .loadUniform("uFadeUpperLimit", 30.0f)
      .loadUniform("uFogColor", scene.getWorld.getExpHeightFogColor);

    foreach (skyBox; map)
      if (skyBox.getVisibility == Visibility.Visible)
        render(cast(SkyBox)skyBox);

    shader.getProgram.unbind;
  }

  /**
   * Render a cube map node by its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) render(SkyBox skyBox)
  in (skyBox !is null, "You cannot render a null sky box.")
  do {
    auto model = skyBox.getModel;

    if (model !is null)
      shader
        .getProgram
        .render(model);
    
    return this;
  }
}