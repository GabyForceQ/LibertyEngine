/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/terrain/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.terrain.impl;

import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.core.objects.entity : Entity;
import liberty.core.objects.meta : NodeBody;
import liberty.graphics.vertex : Vertex;

import liberty.core.resource.manager : ResourceManager;

import liberty.core.model.impl : TerrainModel;
import liberty.core.components.renderer : Renderer;

/**
 *
**/
final class Terrain : Entity!"terrain" {
  mixin(NodeBody);

  private {
    float size = 800;
    uint vertexCount = 128;

    float x, z;
  }

  void constructor() {
    type = "terrain";
    renderer = Renderer!"terrain"(this, new TerrainModel());
  }

  void build(int gridX, int gridZ) {
    x = gridX * size;
    z = gridZ * size;
    generateTerrain();
  }

  float getX() {
    return x;
  }
 
  float getZ() {
    return z;
  }

  private void generateTerrain() {
    const int count = vertexCount * vertexCount;

    Vertex[] vertices = new Vertex[count * 3];

    uint[] indices = new uint[6 * (vertexCount - 1) * (vertexCount - 1)];

    int vertexPtr;
    for (int i; i < vertexCount; i++) {
      for (int j; j < vertexCount; j++) {
        vertices[vertexPtr * 3].position = cast(float)j / (cast(float)vertexCount - 1) * size;
        vertices[vertexPtr * 3 + 1].position = 0;
        vertices[vertexPtr * 3 + 2].position = cast(float)i / (cast(float)vertexCount - 1) * size;
        vertices[vertexPtr * 3].normal = 0;
        vertices[vertexPtr * 3 + 1].normal = 1;
        vertices[vertexPtr * 3 + 2].normal = 0;
        vertices[vertexPtr * 2].texCoord = cast(float)j / (cast(float)vertexCount - 1);
        vertices[vertexPtr * 2 + 1].texCoord = cast(float)i / (cast(float)vertexCount - 1);
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

     Vertex[] squareVertices = [
  Vertex(Vector3F(-0.5f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 1.0f)),
  Vertex(Vector3F(-0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 0.0f)),
  Vertex(Vector3F( 0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 0.0f)),
  Vertex(Vector3F( 0.5f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 1.0f))
];

 uint[6] squareIndices = [
  0, 1, 2,
  0, 2, 3
];

    renderer.getModel().build(squareVertices, squareIndices, "res/textures/default.bmp");
  }
}