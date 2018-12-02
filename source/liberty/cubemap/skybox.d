/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/cubemap/skybox.d)
 * Documentation:
 * Coverage:
**/
module liberty.cubemap.skybox;

import liberty.math.vector;
import liberty.material.impl;
import liberty.model.impl;
import liberty.model.io;
import liberty.scene.meta;
import liberty.scene.node;
import liberty.cubemap.vertex;

/**
 *
**/
final class SkyBox : SceneNode {
  mixin NodeConstructor;

  private {
    Model model;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(Material material) {
    model = new Model(ModelIO.loadRawModel(cubeMapVertices), [material]);
    return this;
  }

  /**
   * Returns the 3D model of the cube map.
  **/
  Model getModel() pure nothrow {
    return model;
  }
}

private const float SIZE = 500.0f;

private CubeMapVertex[36] cubeMapVertices = [  
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE, -SIZE)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  CubeMapVertex(Vector3F( SIZE,  SIZE, -SIZE)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE)),

  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE, -SIZE)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE,  SIZE)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE)),

  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  CubeMapVertex(Vector3F( SIZE, -SIZE,  SIZE)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  CubeMapVertex(Vector3F( SIZE,  SIZE, -SIZE)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE)),

  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE,  SIZE)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  CubeMapVertex(Vector3F( SIZE, -SIZE,  SIZE)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE)),

  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE)),
  CubeMapVertex(Vector3F( SIZE,  SIZE, -SIZE)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  CubeMapVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE,  SIZE)),
  CubeMapVertex(Vector3F(-SIZE,  SIZE, -SIZE)),

  CubeMapVertex(Vector3F(-SIZE, -SIZE, -SIZE)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  CubeMapVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  CubeMapVertex(Vector3F(-SIZE, -SIZE,  SIZE)),
  CubeMapVertex(Vector3F( SIZE, -SIZE,  SIZE))
];
