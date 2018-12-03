/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/skybox/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.skybox.impl;

import liberty.math.vector;
import liberty.material.impl;
import liberty.model.impl;
import liberty.model.io;
import liberty.scene.meta;
import liberty.scene.node;
import liberty.framework.skybox.vertex;

/**
 *
**/
final class SkyBox : SceneNode {
  mixin NodeConstructor;

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(Material material) {
    setModel(new Model(ModelIO.loadRawModel(skyBoxVertices), [material]));
    return this;
  }
}

private const float SIZE = 500.0f;

private SkyBoxVertex[36] skyBoxVertices = [  
  SkyBoxVertex(Vector3F(-SIZE,  SIZE, -SIZE)),
  SkyBoxVertex(Vector3F(-SIZE, -SIZE, -SIZE)),
  SkyBoxVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  SkyBoxVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  SkyBoxVertex(Vector3F( SIZE,  SIZE, -SIZE)),
  SkyBoxVertex(Vector3F(-SIZE,  SIZE, -SIZE)),

  SkyBoxVertex(Vector3F(-SIZE, -SIZE,  SIZE)),
  SkyBoxVertex(Vector3F(-SIZE, -SIZE, -SIZE)),
  SkyBoxVertex(Vector3F(-SIZE,  SIZE, -SIZE)),
  SkyBoxVertex(Vector3F(-SIZE,  SIZE, -SIZE)),
  SkyBoxVertex(Vector3F(-SIZE,  SIZE,  SIZE)),
  SkyBoxVertex(Vector3F(-SIZE, -SIZE,  SIZE)),

  SkyBoxVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  SkyBoxVertex(Vector3F( SIZE, -SIZE,  SIZE)),
  SkyBoxVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  SkyBoxVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  SkyBoxVertex(Vector3F( SIZE,  SIZE, -SIZE)),
  SkyBoxVertex(Vector3F( SIZE, -SIZE, -SIZE)),

  SkyBoxVertex(Vector3F(-SIZE, -SIZE,  SIZE)),
  SkyBoxVertex(Vector3F(-SIZE,  SIZE,  SIZE)),
  SkyBoxVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  SkyBoxVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  SkyBoxVertex(Vector3F( SIZE, -SIZE,  SIZE)),
  SkyBoxVertex(Vector3F(-SIZE, -SIZE,  SIZE)),

  SkyBoxVertex(Vector3F(-SIZE,  SIZE, -SIZE)),
  SkyBoxVertex(Vector3F( SIZE,  SIZE, -SIZE)),
  SkyBoxVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  SkyBoxVertex(Vector3F( SIZE,  SIZE,  SIZE)),
  SkyBoxVertex(Vector3F(-SIZE,  SIZE,  SIZE)),
  SkyBoxVertex(Vector3F(-SIZE,  SIZE, -SIZE)),

  SkyBoxVertex(Vector3F(-SIZE, -SIZE, -SIZE)),
  SkyBoxVertex(Vector3F(-SIZE, -SIZE,  SIZE)),
  SkyBoxVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  SkyBoxVertex(Vector3F( SIZE, -SIZE, -SIZE)),
  SkyBoxVertex(Vector3F(-SIZE, -SIZE,  SIZE)),
  SkyBoxVertex(Vector3F( SIZE, -SIZE,  SIZE))
];
