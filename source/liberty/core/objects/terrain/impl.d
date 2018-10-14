/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/terrain/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.terrain.impl;

import liberty.core.image.bitmap : Bitmap;

import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.core.objects.entity : Entity;
import liberty.core.objects.meta : NodeBody;
import liberty.graphics.vertex : TerrainVertex;

import liberty.core.resource.manager : ResourceManager;

import liberty.core.model.terrain : TerrainModel;
import liberty.core.components.renderer : Renderer;

/**
 *
**/
final class Terrain : Entity!TerrainVertex {
  mixin(NodeBody);

  private {
    float size;
    //uint vertexCount;
    float maxHeight = 40;
    float maxPixelColor = 256 ^^ 3;
    
    Vector2F texCoordMultiplier = Vector2F.one;
  }

  /**
   *
  **/
  void constructor() {
    renderer = Renderer!TerrainVertex(this, new TerrainModel());
  }

  /**
   *
  **/
  Terrain build(float size = 20.0f) {
    this.size = size;
    
    generateTerrain("res/textures/heightMap.bmp");
    
    getTransform().translate(-size / 2.0f, 0.0f, -size / 2.0f);
    texCoordMultiplier = size;

    return this;
  }

  /**
   *
  **/
  override void render() {
    getScene().getTerrainShader().loadTexCoordMultiplier(texCoordMultiplier);
    super.render();
  }

  /**
   *
  **/
  Vector2F getTexCoordMultiplier() {
    return texCoordMultiplier;
  }

  /**
   *
  **/
  Terrain setTexCoordMultiplier(Vector2F multiplier) {
    texCoordMultiplier = multiplier;
    return this;
  }

  /**
   *
  **/
  Terrain setTexCoordMultiplier(float x, float y) {
    texCoordMultiplier = Vector2F(x, y);
    return this;
  }

  /**
   *
  **/
  Terrain increaseTexCoordMultiplier(Vector2F multiplier) {
    texCoordMultiplier += multiplier;
    return this;
  }

  /**
   *
  **/
  Terrain increaseTexCoordMultiplier(float x, float y) {
    texCoordMultiplier += Vector2F(x, y);
    return this;
  }

  /**
   *
  **/
  Terrain decreaseTexCoordMultiplier(Vector2F multiplier) {
    texCoordMultiplier -= multiplier;
    return this;
  }

  /**
   *
  **/
  Terrain decreaseTexCoordMultiplier(float x, float y) {
    texCoordMultiplier -= Vector2F(x, y);
    return this;
  }

  private void generateTerrain(string heightMapPath) {
    // Load height map form file
    auto image = new Bitmap(heightMapPath);

    const int vertexCount = image.getHeight();
    const int count = vertexCount * vertexCount;

    TerrainVertex[] vertices = new TerrainVertex[count * 3];
    uint[] indices = new uint[6 * (vertexCount - 1) * (vertexCount - 1)];

    int vertexPtr;
    for (int i; i < vertexCount; i++) {
      for (int j; j < vertexCount; j++) {
        vertices[vertexPtr].position.x = cast(float)j / (cast(float)vertexCount - 1) * size;
        vertices[vertexPtr].position.y = getHeight(j, i, image);
        vertices[vertexPtr].position.z = cast(float)i / (cast(float)vertexCount - 1) * size;

        Vector3F normal = computeNormal(j, i, image);

        vertices[vertexPtr].normal.x = normal.x;
        vertices[vertexPtr].normal.y = normal.y;
        vertices[vertexPtr].normal.z = normal.z;
        vertices[vertexPtr].texCoord.x = cast(float)j / (cast(float)vertexCount - 1);
        vertices[vertexPtr].texCoord.y = cast(float)i / (cast(float)vertexCount - 1);
        vertexPtr++;
      }
    }
    int indexPtr;
    for (int gz; gz < vertexCount - 1; gz++) {
      for (int gx; gx < vertexCount - 1; gx++) {
        const int topLeft = (gz * vertexCount) + gx;
        const int topRight = topLeft + 1;
        const int bottomLeft = ((gz + 1) * vertexCount) + gx;
        const int bottomRight = bottomLeft + 1;
        indices[indexPtr++] = topLeft;
        indices[indexPtr++] = bottomLeft;
        indices[indexPtr++] = topRight;
        indices[indexPtr++] = topRight;
        indices[indexPtr++] = bottomLeft;
        indices[indexPtr++] = bottomRight;
      }
    }

    renderer.getModel().build(vertices, indices, "res/textures/default.bmp");
  }

  private float getHeight(int x, int y, Bitmap image) {
    if (x < 0 || x >= image.getHeight() || y < 0 || y >= image.getHeight())
      return 0;

    float height = image.getRGB(x, y);
    height += maxPixelColor / 2.0f;
    height /= maxPixelColor / 2.0f;
    height *= maxHeight;

    import liberty.engine;

    return height;
  }

  private Vector3F computeNormal(int x, int y, Bitmap image) {
    float heightL = getHeight(x - 1, y, image);
    float heightR = getHeight(x + 1, y, image);
    float heightD = getHeight(x, y - 1, image);
    float heightU = getHeight(x, y + 1, image);

    Vector3F normal = Vector3F(heightL - heightR, 2.0f, heightD - heightU);
    normal.normalize();

    return normal;
  }
}