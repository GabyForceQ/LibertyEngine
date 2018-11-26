/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/cubemap/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.cubemap.impl;

import liberty.math.vector;
import liberty.material.impl;
import liberty.scene.meta;
import liberty.scene.node;
import liberty.cubemap.model;
import liberty.cubemap.vertex;

/**
 *
**/
final class CubeMap : SceneNode {
  mixin NodeConstructor;

  private {
    CubeMapModel model;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(Material material) {
    model = new CubeMapModel([material]).build(cubeMapVertices);
    return this;
  }

  /**
   * Returns the 3D model of the cube map.
  **/
  CubeMapModel getModel() pure nothrow {
    return model;
  }
}

private const float SIZE = 500.0f;

private CubeMapVertex[36] cubeMapVertices = [  
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE,  SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),

  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),

  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE, -SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE,  SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),

  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE, -SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),

  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE,  SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),

  CubeMapVertex(Vector3F(-SIZE, -SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f)),
  CubeMapVertex(Vector3F( SIZE, -SIZE,  SIZE), Vector3F(0.0f, 0.0f, 0.0f))
];
