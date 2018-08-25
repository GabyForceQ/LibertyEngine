/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/scene/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.scene.impl;

import liberty.core.math.vector : Vector3F;
import liberty.core.system.engine : CoreEngine;
import liberty.world.objects.node : WorldObject;
import liberty.world.objects.node.root : RootObject;
import liberty.world.services : IStartable, IUpdatable, IProcessable, IRenderable;
import liberty.world.objects.camera.impl : Camera;

/**
 *
**/
final class Scene : IUpdatable, IProcessable, IRenderable {
  private {
    string id;
    bool ready;
    WorldObject tree;
    Vector3F startPoint;
    Camera activeCamera;
    Camera[string] camerasMap;
    bool[string] objectsId;
    IStartable[string] startList;
    IUpdatable[string] updateList;
    IRenderable[string] renderList;
    IProcessable[string] processList; 
  }

  static IRenderable[string] shaderList;

  /**
   * Create a scene using a unique id.
  **/
  this(string id) {
    CoreEngine.self
      .getViewport()
      .loadScene(this);

    this.id = id;
    this.tree = new RootObject();
  }

  /**
   * Returns scene unique id.
  **/
  string getId() pure nothrow const @safe {
    return this.id;
  }

  /**
   * Returns if scene is ready to run.
  **/
  bool isReady() pure nothrow const @safe {
    return this.ready;
  }

  /**
   * Returns a scene tree reference.
  **/
  WorldObject getTree() pure nothrow {
    return this.tree;
  }

  /**
   * Returns the start point coordinates
  **/
  Vector3F getStartPoint() pure nothrow const @safe {
    return this.startPoint;
  }

  /**
   *
  **/
  Camera getActiveCamera() {
    return activeCamera;
  }

  /**
   *
  **/
  void setActiveCamera(Camera camera) {
    activeCamera = camera;
  }

  /**
   *
  **/
  void registerCamera(Camera camera) {
		camerasMap[camera.getId()] = camera;
	}

  /**
   *
  **/
  IStartable[string] getStartList() pure nothrow @safe {
    return this.startList;
  }

  /**
   *
  **/
  IUpdatable[string] getUpdateList() pure nothrow @safe {
    return this.updateList;
  }

  /**
   *
  **/
  IProcessable[string] getProcessList() pure nothrow @safe {
    return this.processList;
  }

  /**
   *
  **/
  IRenderable[string] getRenderList() pure nothrow @safe {
    return this.renderList;
  }

  /**
   *
  **/
  void setStartList(string id, IStartable node) pure nothrow @safe {
    this.startList[id] = node;
  }

  /**
   *
  **/
  void setUpdateList(string id, IUpdatable node) pure nothrow @safe {
    this.updateList[id] = node;
  }

  /**
   *
  **/
  void setProcessList(string id, IProcessable node) pure nothrow @safe {
    this.processList[id] = node;
  }

  /**
   *
  **/
  void setRenderList(string id, IRenderable node) pure nothrow @safe {
    this.renderList[id] = node;
  }

  /**
   * Update all objects that have an update() method.
   * The object should implement IUpdatable.
   * It's called every frame.
  **/
  void update(in float deltaTime) {
    foreach (node; this.updateList) {
      node.update(deltaTime);
    }
    import liberty.core.logger.manager;
    import std.conv : to;
  }

  /**
   * Process all objects that have a process() method.
   * The object should implement IProcessable.
   * It's synchronized with PhysicsCoreEngine.
  **/
  void process() {
    foreach (node; this.processList) {
      node.process();
    }
  }

  /**
   * Render all objects that have a render() method.
   * The object should implement IRenderable.
  **/
  void render() {
    foreach (shader; this.shaderList) {
      shader.render();
    }
    foreach(node; this.renderList) {
      node.render();
    }
  }

  bool[string] getObjectsId() {
    return objectsId;
  }

  void setObjectId(string key, bool state = true) {
    objectsId[key] = state;
  }
}