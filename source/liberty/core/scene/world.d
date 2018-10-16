/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/scene/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.scene.world;

import liberty.core.math.vector : Vector3F;
import liberty.core.objects.camera : Camera;
import liberty.core.scene.impl : Scene;

/**
 *
**/
final class WorldSettings {
  private {
    Vector3F exponentialHeighFogColor = Vector3F(0.5f, 0.8f, 0.8f);
  }

  /**
   *
  **/
  WorldSettings updateShaders(Scene scene, Camera camera) {
    scene.getGenericShader()
      .loadProjectionMatrix(camera.getProjectionMatrix())
      .loadViewMatrix(camera.getViewMatrix())
      .loadSkyColor(exponentialHeighFogColor);
    
    scene.getTerrainShader()
      .loadProjectionMatrix(camera.getProjectionMatrix())
      .loadViewMatrix(camera.getViewMatrix())
      .loadSkyColor(exponentialHeighFogColor);
    
    return this;
  }

  /**
   *
  **/
  WorldSettings setExponentialHeighFogColor(Vector3F exponentialHeighFogColor) pure nothrow {
    this.exponentialHeighFogColor = exponentialHeighFogColor;
    return this;
  }

  /**
   *
  **/
  Vector3F getExponentialHeighFogColor() pure nothrow {
    return exponentialHeighFogColor;
  }
}