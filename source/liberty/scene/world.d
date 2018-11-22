/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/world.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.world;

import liberty.camera;
import liberty.math.vector;
import liberty.scene.impl;

/**
 * Class containing world settings used in a scene.
**/
final class World {
  enum {
    /**
     * The default value of exponential height fog is r: 0.5; g:0.8; b:0.8;
    **/
    DEFAULT_EXP_HEIGHT_FOG_COLOR = Vector3F(0.5f, 0.8f, 0.8f)
  }

  private {
    Vector3F expHeightFogColor = DEFAULT_EXP_HEIGHT_FOG_COLOR;
  }

  /**
   * Update generic shader: projection matrix, view matrix, sky color.
   * Update terrain shader: projection matrix, view matrix, sky color.
   * Returns reference to this so it can be used in a stream.
  **/
  World updateShaders(Scene scene, Camera camera) {
    scene
      .getPrimitiveSystem()
      .getShader()
      .bind()
      .loadProjectionMatrix(camera.getProjectionMatrix())
      .loadViewMatrix(camera.getViewMatrix())
      .loadSkyColor(expHeightFogColor)
      .unbind();
    
    scene
      .getTerrainSystem()
      .getShader()
      .bind()
      .loadProjectionMatrix(camera.getProjectionMatrix())
      .loadViewMatrix(camera.getViewMatrix())
      .loadSkyColor(expHeightFogColor)
      .unbind();
    
    return this;
  }

  /**
   * Set the exp height fog of the scene using a 3 floats for the color (RGB).
   * Returns reference to this so it can be used in a stream.
  **/
  World setexpHeightFogColor(float r, float g, float b) pure nothrow {
    this.expHeightFogColor = Vector3F(r, g, b);
    return this;
  }

  /**
   * Set the exp height fog of the scene using a vector of 3 values for the color (RGB).
   * Returns reference to this so it can be used in a stream.
  **/
  World setexpHeightFogColor(Vector3F expHeightFogColor) pure nothrow {
    this.expHeightFogColor = expHeightFogColor;
    return this;
  }

  /**
   *
  **/
  Vector3F getexpHeightFogColor() pure nothrow const {
    return expHeightFogColor;
  }
}