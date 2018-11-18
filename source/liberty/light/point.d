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
import liberty.graphics.renderer;
import liberty.scene.meta;
import liberty.primitive.model;
import liberty.scene.node;
import liberty.math.functions;
import liberty.primitive.vertex;
import liberty.primitive.impl;
import liberty.primitive.shader;
import liberty.terrain.shader;

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
  **/
  PointLight setColor(Vector3F color) {
    this.color = color;
    return this;
  }

  /**
   *
  **/
  Vector3F getColor() pure nothrow {
    return color;
  }

  /**
   *
  **/
  PointLight setAttenuation(Vector3F attenuation) {
    this.attenuation = attenuation;
    return this;
  }

  /**
   *
  **/
  Vector3F getAttenuation() pure nothrow {
    return attenuation;
  }

  /**
   *
  **/
  void applyToPrimitiveMap(PrimitiveShader shader) {
    if (index < 4) {
      shader
        .loadLightPosition(index, getTransform().getLocation())
        .loadLightColor(index, color)
        .loadLightAttenuation(index, attenuation)
        .loadShineDamper(1.0f)
        .loadReflectivity(0.0f);
    } else
      Logger.warning("GfxEngine can't render more than 4 lights.", typeof(this).stringof);
  }

  /**
   *
  **/
  void applyToTerrainMap(TerrainShader shader) {
    if (index < 4) {
      shader
        .loadLightPosition(index, getTransform().getLocation())
        .loadLightColor(index, color)
        .loadLightAttenuation(index, attenuation)
        .loadShineDamper(1.0f)
        .loadReflectivity(0.0f);
    } else
      Logger.warning("GfxEngine can't render more than 4 lights.", typeof(this).stringof);
  }
}