/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/terrain/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.terrain.impl;

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
    uint vertexCount;
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
  void build(float size = 20.0f, uint vertexCount = 128) {
    this.size = size;
    this.vertexCount = vertexCount;
    generateTerrain();
    getTransform().translate(-size / 2.0f, 0.0f, -size / 2.0f);
  }

  private void generateTerrain() {
    const int count = vertexCount * vertexCount;

    TerrainVertex[] vertices = new TerrainVertex[count * 3];

    uint[] indices = new uint[6 * (vertexCount - 1) * (vertexCount - 1)];

    int vertexPtr;
    for (int i; i < vertexCount; i++) {
      for (int j; j < vertexCount; j++) {
        vertices[vertexPtr].position.x = cast(float)j / (cast(float)vertexCount - 1) * size;
        vertices[vertexPtr].position.y = 0;
        vertices[vertexPtr].position.z = cast(float)i / (cast(float)vertexCount - 1) * size;
        vertices[vertexPtr].normal.x = 0;
        vertices[vertexPtr].normal.y = 1;
        vertices[vertexPtr].normal.z = 0;
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
}