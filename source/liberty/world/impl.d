/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.impl;

import liberty.camera;
import liberty.math.vector;
import liberty.world.constants;

/**
 * Class containing world settings used in a scene.
**/
final class World {
  private {
    Vector3F expHeightFogColor = WORLD_DEFAULT_EXP_HEIGHT_FOG_COLOR;
  }

  /**
   * Set the exp height fog color of the scene using 3 floats for the color (RGB) in a template stream function.
   * Assign a value to exp height fog color using world.setExpHeightFogColor(r, g, b) or world.setExpHeightFogColor!"="(r, g, b).
   * Increment exp height fog color by value using world.setExpHeightFogColor!"+="(r, g, b).
   * Decrement exp height fog color by value using world.setExpHeightFogColor!"-="(r, g, b).
   * Multiply exp height fog color by value using world.setExpHeightFogColor!"*="(r, g, b).
   * Divide exp height fog color by value using world.setExpHeightFogColor!"/="(r, g, b).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setExpHeightFogColor(string op = "=")(float r, float g, float b) pure nothrow
  if (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=")
  do {
    return setExpHeightFogColor!op(Vector3F(r, g, b));
  }

  /**
   * Set the exp height fog color of the scene using a vector of 3 values for the color (RGB) in a template stream function.
   * Assign a value to exp height fog color using world.setExpHeightFogColor(vector3) or world.setExpHeightFogColor!"="(vector3).
   * Increment exp height fog color by value using world.setExpHeightFogColor!"+="(vector3).
   * Decrement exp height fog color by value using world.setExpHeightFogColor!"-="(vector3).
   * Multiply exp height fog color by value using world.setExpHeightFogColor!"*="(vector3).
   * Divide exp height fog color by value using world.setExpHeightFogColor!"/="(vector3).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setExpHeightFogColor(string op = "=")(Vector3F expHeightFogColor) pure nothrow {
    mixin("this.expHeightFogColor " ~ op ~ " expHeightFogColor;");
    return this;
  }

  /**
   * Returns the exponential height fog color.
  **/
  Vector3F getExpHeightFogColor() pure nothrow const {
    return expHeightFogColor;
  }

  /**
   * Set exp height fog color to default value $(D WORLD_DEFAULT_EXP_HEIGHT_FOG_COLOR).
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setDefaultExpHeightFogColor() pure nothrow {
    expHeightFogColor = WORLD_DEFAULT_EXP_HEIGHT_FOG_COLOR;
    return this;
  }
}