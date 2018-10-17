/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/light.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.light;

import liberty.core.math.vector : Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.core.components.renderer : Renderer;
import liberty.core.objects.meta : NodeBody;
import liberty.core.model.generic : GenericModel;
import liberty.core.objects.node : WorldObject;
import liberty.core.objects.entity : Entity;
import liberty.core.math.functions : cos, radians;
import liberty.graphics.vertex : GenericVertex;

/**
 *
**/
final class PointLight : Entity!GenericVertex {
  mixin(NodeBody);

  private {
    Vector3F color = Vector3F.one;
  }

  /**
   *
  **/
	void constructor() {
    renderer = Renderer!GenericVertex(this, null);
    getTransform().setPosition(0.0f, 200.0f, 0.0f);
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
  override void render() {
    CoreEngine.getScene().getGenericShader()
      .loadLightPosition(getTransform().getWorldPosition())
      .loadLightColor(color)
      .loadShineDamper(1.0f)
      .loadReflectivity(0.0f);

    CoreEngine.getScene().getTerrainShader()
      .loadLightPosition(getTransform().getWorldPosition())
      .loadLightColor(color)
      .loadShineDamper(1.0f)
      .loadReflectivity(0.0f);
  }
}