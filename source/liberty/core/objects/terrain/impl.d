/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/terrain/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.terrain.impl;

import liberty,core.objects.entity : Entity;
import liberty.core.objects.meta : NodeBody;

import liberty.core.model.raw : RawModel;
import liberty.core.resource.manager : ResourceManager;

/**
 *
**/
final class Terrain : Entity {
  mixin(NodeBody);

  private {
    float size = 800;
    uint vertexCount = 128;

    float x, z;
    RawModel model;
  }

  this(int gridX, int gridZ) {
    x = gridX * size;
    z = gridZ * size;
    model = generateTerrain();
  }

  float getX() {
    return x;
  }
 
  float getZ() {
    return z;
  }

  RawModel getModel() {
    return model;
  }

  /**
   *
  **/
  override void render() {

  }

  private RawModel generateTerrain() {
    int count = vertexCount * vertexCount;
    float[] vertices = new float[count * 3];
    float[] normals = new float[count * 3];
    float[] textureCoords = new float[count*2];
    int[] indices = new int[6*(vertexCount-1)*(vertexCount-1)];
    int vertexPointer = 0;
    for(int i=0;i<vertexCount;i++){
        for(int j=0;j<vertexCount;j++){
            vertices[vertexPointer*3] = cast(float)j/(cast(float)vertexCount - 1) * size;
            vertices[vertexPointer*3+1] = 0;
            vertices[vertexPointer*3+2] = cast(float)i/(cast(float)vertexCount - 1) * size;
            normals[vertexPointer*3] = 0;
            normals[vertexPointer*3+1] = 1;
            normals[vertexPointer*3+2] = 0;
            textureCoords[vertexPointer*2] = cast(float)j/(cast(float)vertexCount - 1);
            textureCoords[vertexPointer*2+1] = cast(float)i/(cast(float)vertexCount - 1);
            vertexPointer++;
        }
    }
    int pointer = 0;
    for(int gz=0;gz<vertexCount-1;gz++){
        for(int gx=0;gx<vertexCount-1;gx++){
            int topLeft = (gz*vertexCount)+gx;
            int topRight = topLeft + 1;
            int bottomLeft = ((gz+1)*vertexCount)+gx;
            int bottomRight = bottomLeft + 1;
            indices[pointer++] = topLeft;
            indices[pointer++] = bottomLeft;
            indices[pointer++] = topRight;
            indices[pointer++] = topRight;
            indices[pointer++] = bottomLeft;
            indices[pointer++] = bottomRight;
        }
    }
    return ResourceManager.loadRawModel(Vertex(vertices, normals, textureCoords), indices);
  }
}