/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/light/point.d)
 * Documentation:
 * Coverage:
**/
module liberty.light.point;

import liberty.logger.impl;
import liberty.math.vector;
import liberty.core.engine;
import liberty.scene.meta;
import liberty.model.impl;
import liberty.scene.node;
import liberty.math.functions;
import liberty.primitive.vertex;
import liberty.primitive.impl;
import liberty.terrain.shader;
import liberty.graphics.shader.graph;

alias Lighting = PointLight;

/**
 *
**/
final class PointLight : SceneNode {
  mixin NodeConstructor!(q{
    this.getTransform().setAbsoluteLocation(0.0f, 200.0f, 0.0f);
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

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) applyToPrimitiveMap() {
    import std.conv : to;

    if (index < 4) {
      GfxShaderGraph
        .getDefaultShader("primitive")
        .getProgram
        .loadUniform("uLightPosition[" ~ index.to!string ~ "]", getTransform().getLocation())
        .loadUniform("uLightColor[" ~ index.to!string ~ "]", color)
        .loadUniform("uLightAttenuation[" ~ index.to!string ~ "]", attenuation)
        .loadUniform("uShineDamper", 1.0f)
        .loadUniform("uReflectivity", 0.0f);
    } else
      Logger.warning("GfxEngine can't render more than 4 lights.", typeof(this).stringof);

    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) applyToTerrainMap(TerrainShader shader) {
    if (index < 4) {
      shader
        .loadLightPosition(index, getTransform().getLocation())
        .loadLightColor(index, color)
        .loadLightAttenuation(index, attenuation)
        .loadShineDamper(1.0f)
        .loadReflectivity(0.0f);
    } else
      Logger.warning("GfxEngine can't render more than 4 lights.", typeof(this).stringof);

    return this;
  }
}