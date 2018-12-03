/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/light/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.light.impl;

import liberty.framework.primitive.vertex;
import liberty.framework.primitive.impl;
import liberty.graphics.shader.constants;
import liberty.graphics.shader.impl;
import liberty.math.functions;
import liberty.math.vector;
import liberty.scene.meta;
import liberty.scene.node;

/**
 *
**/
final class Light : SceneNode {
  mixin NodeConstructor!(q{
    this.getTransform.setAbsoluteLocation(0.0f, 200.0f, 0.0f);
    this.index = this.numberOfLights;
    this.numberOfLights++;
  });

  mixin NodeDestructor!(q{
    this.numberOfLights--;
  });

  private {
    static uint numberOfLights;

    uint index;
    Vector3F color = Vector3F.one;
    Vector3F attenuation = Vector3F(1.0f, 0.0f, 0.0f);
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

  uint getIndex() pure nothrow const {
    return index;
  }
}