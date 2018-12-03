/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/terrain/impl.d)
 * Documentation:
 * Coverage:
 * TODO:
 *  - use texture_io to load png within a texture
 *  - setTexCoordMultiplier += -=
**/
module liberty.framework.terrain.impl;

import liberty.framework.terrain.vertex;
import liberty.graphics.shader;
import liberty.image.format.bmp;
import liberty.image.io;
import liberty.material.impl;
import liberty.math.functions;
import liberty.math.vector;
import liberty.model.impl;
import liberty.model.io;
import liberty.scene.entity;
import liberty.scene.meta;
import liberty.scene.services;

/**
 *
**/
final class Terrain : Entity {
  mixin EntityConstructor!(q{
    shader = Shader
      .getOrCreate("Terrain")
      .registerEntity(this)
      .addGlobalRender((program) {
        program.loadUniform("uSkyColor", scene.getWorld.getExpHeightFogColor);
      })
      .addPerEntityRender((program) {
        program.loadUniform("uTexCoordMultiplier", getTexCoordMultiplier);
      });
    
    scene.addShader(shader);
  });

  private {
    const float maxPixelColor = 256 ^^ 3;

    // getSize
    float size;
    // getMaxHeight
    float maxHeight = 0;
    float[256][256] heights; // ????
    Material[] materials;
    
    // getTexCoordMultiplier, setTexCoordMultiplier
    Vector2F texCoordMultiplier = Vector2F.one;

    Shader shader;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(float size, float maxHeight, Material[] materials) {
    this.size = size;
    this.maxHeight = maxHeight;
    this.materials = materials;
    
    generateTerrain("res/textures/heightMap.bmp");
    
    getTransform().setAbsoluteLocation(-size / 2.0f, 0.0f, -size / 2.0f);
    texCoordMultiplier = size;

    return this;
  }

  /**
   *
  **/
  Vector2F getTexCoordMultiplier() pure nothrow const {
    return texCoordMultiplier;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setTexCoordMultiplier(Vector2F multiplier) pure nothrow {
    texCoordMultiplier = multiplier;
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setTexCoordMultiplier(float x, float y) pure nothrow {
    texCoordMultiplier = Vector2F(x, y);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) increaseTexCoordMultiplier(Vector2F multiplier) pure nothrow {
    texCoordMultiplier += multiplier;
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) increaseTexCoordMultiplier(float x, float y) pure nothrow {
    texCoordMultiplier += Vector2F(x, y);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) decreaseTexCoordMultiplier(Vector2F multiplier) pure nothrow {
    texCoordMultiplier -= multiplier;
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) decreaseTexCoordMultiplier(float x, float y) pure nothrow {
    texCoordMultiplier -= Vector2F(x, y);
    return this;
  }

  /**
   *
  **/
  float getHeight(float worldX, float worldZ) {
    const float terrainX = worldX - getTransform().getAbsoluteLocation().x;
    const float terrainZ = worldZ - getTransform().getAbsoluteLocation().z;

    const int heightLen = (heights.length) - 1;
    const float gridSqareSize = size / cast(float)heightLen;
    
    int gridX = cast(int)floor(terrainX / gridSqareSize);
    int gridZ = cast(int)floor(terrainZ / gridSqareSize);

    if (gridX >= heightLen || gridZ >= heightLen || gridX < 0 || gridZ < 0)
      return int.min;

    float xCoord = (terrainX % gridSqareSize) / gridSqareSize;
    float zCoord = (terrainZ % gridSqareSize) / gridSqareSize;

    float finalPos;
    if (xCoord <= (1 - zCoord)) {
			finalPos = barryCentric(
        Vector3F(0, heights[gridX][gridZ], 0),
        Vector3F(1, heights[gridX + 1][gridZ], 0),
        Vector3F(0, heights[gridX][gridZ + 1], 1),
        Vector2F(xCoord, zCoord)
      );
		} else {
			finalPos = barryCentric(
        Vector3F(1, heights[gridX + 1][gridZ], 0),
        Vector3F(1, heights[gridX + 1][gridZ + 1], 1),
        Vector3F(0, heights[gridX][gridZ + 1], 1),
        Vector2F(xCoord, zCoord)
      );
		}

    return finalPos;
  }

  private void generateTerrain(string heightMapPath) {
    // Load height map form file
    auto image = cast(BMPImage)ImageIO.loadImage(heightMapPath);

    const int vertexCount = image.getHeight();
    const int count = vertexCount * vertexCount;

    //heights = new float[vertexCount][vertexCount]; // ???? vertexCount

    TerrainVertex[] vertices = new TerrainVertex[count * 3];
    uint[] indices = new uint[6 * (vertexCount - 1) * (vertexCount - 1)];

    int vertexPtr;
    for (int i; i < vertexCount; i++) {
      for (int j; j < vertexCount; j++) {
        const float height = getHeight(j, i, image);
        heights[j][i] = height;

        vertices[vertexPtr].position.x = cast(float)j / (cast(float)vertexCount - 1) * size;
        vertices[vertexPtr].position.y = height;
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

    setModel(new Model(ModelIO.loadRawModel(vertices, indices), materials));
  }

  private float getHeight(int x, int y, BMPImage image) {
    if (x < 0 || x >= image.getHeight() || y < 0 || y >= image.getHeight())
      return 0;

    float height = image.getRGBPixelColor(x, y);
    height += maxPixelColor / 2.0f;
    height /= maxPixelColor / 2.0f;
    height *= maxHeight;

    return height;
  }

  private Vector3F computeNormal(int x, int y, BMPImage image) {
    const float heightL = getHeight(x - 1, y, image);
    const float heightR = getHeight(x + 1, y, image);
    const float heightD = getHeight(x, y - 1, image);
    const float heightU = getHeight(x, y + 1, image);

    Vector3F normal = Vector3F(heightL - heightR, 2.0f, heightD - heightU);
    normal.normalize();

    return normal;
  }

  /**
   *
  **/
  float getSize() pure nothrow const {
    return size;
  }

  /**
   *
  **/
  float getMaxHeight() pure nothrow const {
    return maxHeight;
  }
}