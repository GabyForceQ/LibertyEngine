/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/physics/rigidbody.d)
 * Documentation:
 * Coverage:
**/
module liberty.physics.rigidbody;

import liberty.framework.terrain.impl;
import liberty.math.transform;
import liberty.math.vector;
import liberty.scene.entity;
import liberty.time;

/**
 *
**/
class RigidBody {
  public {
    Vector3F gravityDirection = Vector3F.down;
    float gravity = -80.0f;
    float jumpPower = 20.0f;
    float upSpeed = 0;
    float moveSpeed = 5.0f;
    bool onGround;

    Entity entity;
    Terrain terrain;
  }

  /**
   *
  **/
  this(Entity entity, Terrain terrain)   {
    this.entity = entity;
    this.terrain = terrain;
  }

  /**
   *
  **/
  typeof(this) processPx() {
    const float deltaTime = Time.getDelta;
    upSpeed += gravity * deltaTime;

    entity.component!Transform.setLocationY!"+="(upSpeed * deltaTime);
    const Vector3F worldPos = entity.component!Transform.getLocation;

    const float terrainHeight = terrain.getHeight(worldPos.x, worldPos.z);

    onGround = false;
    
    if (worldPos.y < terrainHeight) {
      onGround = true;
      upSpeed = 0;
      entity.component!Transform.setLocationY(terrainHeight);
    }

    return this;
  }

  /**
   *
  **/
  typeof(this) jump() {
    upSpeed = jumpPower;
    return this;
  }
}