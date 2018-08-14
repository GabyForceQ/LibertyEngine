module liberty.mvc.components.scene.controller;

import liberty.core.math.vector : Vector3F;
import liberty.core.system.logic : Logic;
import liberty.mvc.meta : Controller, BindModel, JSON;
import liberty.mvc.scene.model : SceneModel;
import liberty.mvc.objects.node.root : RootController;
import liberty.mvc.services : IStartable, IUpdatable, IProcessable;
import liberty.graphics.services : IRenderable;

/**
 *
**/
@Controller
final class SceneController : IUpdatable, IProcessable, IRenderable {
  mixin(BindModel);

  /**
   * Create a scene using a unique id.
  **/
  this(string id) {
    Logic.self.loadScene(this);
    model.id = id;
    model.tree = new RootController();
  }

  /**
   * Returns scene unique id.
  **/
  string id() pure nothrow const @safe @nogc @property {
    return model.id;
  }

  /**
   * Returns if scene is ready to run.
  **/
  string isReady() pure nothrow const @safe @nogc @property {
    return model.isReady;
  }

  /**
   * Returns a scene tree reference.
  **/
  Node tree() pure nothrow {
    return model.tree;
  }

  /**
   * Returns the start point coordinates
  **/
  Vector3F startPoint() pure nothrow const @safe @nogc @property {
    return model.startPoint;
  }
}