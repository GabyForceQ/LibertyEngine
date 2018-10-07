module liberty.core.objects.entity;

import liberty.core.components.renderer : Renderer;
import liberty.core.objects.node : WorldObject;
import liberty.core.services : IRenderable;

/**
 *
**/
abstract class Entity : WorldObject, IRenderable {
  /**
   *
  **/
  Renderer renderer;

  /**
   *
  **/
  this(string id, WorldObject parent) {
    super(id, parent);
  }

  /**
   *
  **/
  override void render() {}

  /**
   *
  **/
  ref Renderer getRenderer() {
    return renderer;
  }
}