/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/mvc/scene/controller.d, _controller.d)
 * Documentation:
 * Coverage:
**/
module liberty.mvc.scene.controller;

import liberty.core.math.vector : Vector3F;
import liberty.core.system.logic : Logic;
import liberty.mvc.meta : Controller, BindModel, JSON;
import liberty.mvc.scene.model : SceneModel;
import liberty.mvc.objects.node.controller : NodeController;
import liberty.mvc.objects.node.root : RootController;
import liberty.mvc.services : IStartable, IUpdatable, IProcessable, IRenderable;

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
    Logic.self.getViewport().loadScene(this);
    model.id = id;
    model.tree = new RootController();
  }

  /**
   * Returns scene unique id.
  **/
  string getId() pure nothrow const @safe {
    return model.id;
  }

  /**
   * Returns if scene is ready to run.
  **/
  bool isReady() pure nothrow const @safe {
    return model.isReady;
  }

  /**
   * Returns a scene tree reference.
  **/
  NodeController getTree() pure nothrow {
    return model.tree;
  }

  /**
   * Returns the start point coordinates
  **/
  Vector3F getStartPoint() pure nothrow const @safe {
    return model.startPoint;
  }

  /**
   *
  **/
  IStartable[string] getStartList() pure nothrow @safe {
    return model.startList;
  }

  /**
   *
  **/
  IUpdatable[string] getUpdateList() pure nothrow @safe {
    return model.updateList;
  }

  /**
   *
  **/
  IProcessable[string] getProcessList() pure nothrow @safe {
    return model.processList;
  }

  /**
   *
  **/
  void setStartList(string id, IStartable node) pure nothrow @safe {
    model.startList[id] = node;
  }

  /**
   *
  **/
  void setUpdateList(string id, IUpdatable node) pure nothrow @safe {
    model.updateList[id] = node;
  }

  /**
   *
  **/
  void setProcessList(string id, IProcessable node) pure nothrow @safe {
    model.processList[id] = node;
  }

  /**
   *
  **/
  void setRenderList(string id, IRenderable node) pure nothrow @safe {
    model.renderList[id] = node;
  }

  /**
   * Update all objects that have an update() method.
   * The object should implement IUpdatable.
   * It's called every frame.
  **/
  void update(in float deltaTime) {
    foreach (node; model.updateList) {
      node.update(deltaTime);
    }
  }

  /**
   * Process all objects that have a process() method.
   * The object should implement IProcessable.
   * It's synchronized with PhysicsCoreEngine.
  **/
  void process() {
    foreach (node; model.processList) {
      node.process();
    }
  }

  /**
   * Render all objects that have a render() method.
   * The object should implement IRenderable.
  **/
  void render() {
    //foreach (shader; model.shaderList) {
    //  shader.render();
    //}
    foreach(node; model.renderList) {
      node.render();
    }
  }
}