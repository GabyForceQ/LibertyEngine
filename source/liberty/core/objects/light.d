module liberty.core.objects.light;

import liberty.core.math.vector : Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.core.components.renderer : Renderer;
import liberty.core.objects.meta : NodeBody;
import liberty.core.model.impl : Model;
import liberty.core.objects.node : WorldObject;
import liberty.core.objects.entity : Entity;
import liberty.core.math.functions : cos, radians;

/**
 *
**/
final class PointLight : Entity {
  mixin(NodeBody);

  private {
    Vector3F position = Vector3F.zero;
    Vector3F ambient = Vector3F(0.5f);
    Vector3F diffuse =  Vector3F(0.8f);
    Vector3F specular = Vector3F.one;
  }

  /**
   *
  **/
	void constructor() {
    renderer = Renderer(this, null);
	}

  /**
   *
  **/
  PointLight setColor(Vector3F color) {
    diffuse = color * Vector3F(0.8f);
    ambient = diffuse * Vector3F(0.5f);

    return this;
  }

  /**
   *
  **/
  PointLight setPosition(Vector3F position) {
    this.position = position;

    return this;
  }

  /**
   *
  **/
  override void render() {
    CoreEngine.getScene().shaderList["CoreShader"]
      .loadUniform("uLight.position", CoreEngine.getScene().getActiveCamera().getPosition())
      .loadUniform("uLight.direction", CoreEngine.getScene().getActiveCamera().getFrontVector())
      .loadUniform("uLight.cutOff", cos(radians(12.5f)))
      .loadUniform("uLight.outerCutOff", cos(radians(17.5f)))
      .loadUniform("uLight.ambient", ambient)
      .loadUniform("uLight.diffuse", diffuse)
      .loadUniform("uLight.specular", specular)
      .loadUniform("uLight.constant", 1.0f)
      .loadUniform("uLight.linear", 0.09f)
      .loadUniform("uLight.quadratic", 0.032f);
  }
}