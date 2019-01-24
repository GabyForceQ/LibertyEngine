/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/light/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.light.impl;

import liberty.framework.primitive.impl;
import liberty.framework.primitive.vertex;
import liberty.graphics.shader.constants;
import liberty.graphics.shader.impl;
import liberty.logger.impl;
import liberty.math.functions;
import liberty.math.transform;
import liberty.math.vector;
import liberty.scene.entity;
import liberty.scene.meta;

/**
 *
**/
final class Light : Entity {
  mixin NodeBody;

  private {
    static uint numberOfLights;

    uint index;
    Vector3F color = Vector3F.one;
    Vector3F attenuation = Vector3F(1.0f, 0.0f, 0.0f);
  }

  /**
   *
  **/
  this(string id) {
    super(id);
    register;

    getComponent!Transform
      .setLocation(0.0f, 200.0f, 0.0f);
    
    index = this.numberOfLights;
    numberOfLights++;

    scene.addLight(this);
  }

  ~this() {
    this.numberOfLights--;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setColor(Vector3F color) pure nothrow {
    this.color = color;
    return this;
  }

  /**
   *
  **/
  Vector3F getColor() pure nothrow const {
    return color;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setAttenuation(Vector3F attenuation) pure nothrow {
    this.attenuation = attenuation;
    return this;
  }

  /**
   *
  **/
  Vector3F getAttenuation() pure nothrow const {
    return attenuation;
  }

  /**
   *
  **/
  uint getIndex() pure nothrow const {
    return index;
  }

  /**
   * Apply light to a primitive or terrain.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) applyTo(string shaderId)
  in (shaderId == "Primitive" || shaderId == "Terrain",
    "You can apply light only on primitives and terrains.")
  do {
    import std.conv : to;

    if (index < 4) {
      Shader
        .getOrCreate(shaderId)
        .getProgram
        .loadUniform("uLightPosition[" ~ index.to!string ~ "]", getComponent!Transform.getLocation)
        .loadUniform("uLightColor[" ~ index.to!string ~ "]", color)
        .loadUniform("uLightAttenuation[" ~ index.to!string ~ "]", attenuation)
        .loadUniform("uShineDamper", 1.0f)
        .loadUniform("uReflectivity", 0.0f);
    } else
      Logger.warning(shaderId ~ " shader can't render more than 4 lights.", typeof(this).stringof);

    return this;
  }
}