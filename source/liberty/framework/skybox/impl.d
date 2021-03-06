/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/skybox/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.skybox.impl;

import liberty.framework.skybox.vertex;
import liberty.graphics.shader.impl;
import liberty.material.impl;
import liberty.math.matrix;
import liberty.math.vector;
import liberty.model.impl;
import liberty.model.io;
import liberty.scene.entity;
import liberty.scene.meta;

/**
 *
**/
final class SkyBox : Entity {
  mixin NodeBody;

  private {
    Shader shader;
  }

  /**
   *
  **/
  this(string id) {
    super(id);
    register;

    shader = Shader
      .getOrCreate("SkyBox", (shader) {
        shader
          .setViewMatrixEnabled(false)
          .addGlobalRenderMethod((program) {
            // Make it unreachable
            Matrix4F newViewMatrix = scene.camera.viewMatrix;
            newViewMatrix.c[0][3] = 0;
            newViewMatrix.c[1][3] = 0;
            newViewMatrix.c[2][3] = 0;

            program
              .loadUniform("uFadeLowerLimit", 0.0f)
              .loadUniform("uFadeUpperLimit", 30.0f)
              .loadUniform("uFogColor", scene.world.getExpHeightFogColor)
              .loadUniform("uViewMatrix", newViewMatrix);
          });
      });
    
    shader.registerEntity(this);
    scene.shaderMap[shader.id] = shader;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(Material material) {
    model = new Model(ModelIO.loadRawModel(skyBoxVertices), [material]);
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
