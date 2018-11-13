/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/physics/collider.d)
 * Documentation:
 * Coverage:
**/
module liberty.physics.collider;

abstract class Collider {
  private {
    // setMass, getMass
    float mass;
    // setLayer, getLayer
    ulong layer;
    // setTriggered, getTriggered
    bool triggered;
    // setStatic, getStatic
    bool static_;
  }

  Collider setMass(float value) pure nothrow {
    mass = value;
    return this;
  }

  float getMass() pure nothrow const {
    return mass;
  }

  Collider setLayer(ulong value) pure nothrow {
    layer = value;
    return this;
  }

  float getLayer() pure nothrow const {
    return layer;
  }

  Collider setTriggered(bool value) pure nothrow {
    triggered = value;
    return this;
  }

  float getTriggered() pure nothrow const {
    return triggered;
  }

  Collider setStatic(bool value) pure nothrow {
    static_ = value;
    return this;
  }

  float getStatic() pure nothrow const {
    return static_;
  }
}