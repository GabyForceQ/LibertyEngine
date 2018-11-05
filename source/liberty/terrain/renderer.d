module liberty.terrain.renderer;

import liberty.services;
import liberty.scene;

/**
 *
**/
final class TerrainRenderer : IRenderable {
  private {
    Scene scene;
  }

  /**
   *
  **/
  this(Scene scene) {
    this.scene = scene;
  }

  /**
   *
  **/
  void render() {
    scene.getTerrainShader().bind();
    
    foreach (terrain; scene.getTerrainMap())
      terrain.render();

    scene.getTerrainShader().unbind();
  }

  /**
   *
  **/
  Scene getScene() pure nothrow {
    return scene;
  }
}