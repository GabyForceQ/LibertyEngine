/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/primitive/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.primitive.impl;

import liberty.logger.impl;
import liberty.model.impl;
import liberty.scene.entity;
import liberty.graphics.shader.impl;

/**
 *
**/
abstract class Primitive : Entity {
  private {
    Shader shader;
  }

  /**
   *
  **/
  this(string id, Entity parent) {
    super(id, parent);

    shader = Shader
      .getOrCreate("Primitive", (shader) {
        shader
          .addGlobalRender((program) {
            program.loadUniform("uSkyColor", scene.getWorld.getExpHeightFogColor);
          })
          .addPerEntityRender((program) {
            program.loadUniform("uUseFakeLighting", model.isFakeLightingEnabled);
          });
      });

    shader.registerEntity(this);
    scene.addShader(shader);
  }
}

/**
 *
**/
abstract class UniquePrimitive : Primitive {
  private static bool hasInstance;
  /**
   *
  **/
  this(string id, Entity parent) {
    if (this.hasInstance) {
      Logger.error(
        "Cannot have multiple instances", 
        typeof(this).stringof
      );
    }
    super(id, parent);
    this.hasInstance = true;
  }
}