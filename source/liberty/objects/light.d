/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/objects/light.d)
 * Documentation:
 * Coverage:
**/
module liberty.objects.light;

import liberty.logger.impl : Logger;
import liberty.math.vector : Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.components.renderer : Renderer;
import liberty.objects.meta : NodeBody;
import liberty.model.core : CoreModel;
import liberty.objects.node : SceneNode;
import liberty.objects.entity : Entity;
import liberty.math.functions : cos, radians;
import liberty.graphics.vertex : GenericVertex;

/**
 *
**/
final class PointLight : Entity!GenericVertex {
  mixin(NodeBody);

  private {
    static uint numberOfLights;

    uint index;
    Vector3F color = Vector3F.one;
    Vector3F attenuation = Vector3F(1.0f, 0.0f, 0.0f);
  }

  /**
   *
  **/
	void constructor() {
    renderer = new Renderer!GenericVertex(this, null);
    getTransform().setWorldPosition(0.0f, 200.0f, 0.0f);
    index = numberOfLights;
    numberOfLights++;
	}

  ~this() {
    numberOfLights--;
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
  override void render() {
    if (index < 4) {
      CoreEngine.getScene().getcoreShader()
        .loadLightPosition(index, getTransform().getPosition())
        .loadLightColor(index, color)
        .loadLightAttenuation(index, attenuation)
        .loadShineDamper(1.0f)
        .loadReflectivity(0.0f);

      CoreEngine.getScene().getTerrainShader()
        .loadLightPosition(index, getTransform().getPosition())
        .loadLightColor(index, color)
        .loadLightAttenuation(index, attenuation)
        .loadShineDamper(1.0f)
        .loadReflectivity(0.0f);
    } else
      Logger.warning("GfxEngine can't render more than 4 lights.", typeof(this).stringof);
  }
}