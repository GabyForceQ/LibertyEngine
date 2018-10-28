/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/scene/impl.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - implement IProcessable
**/
module liberty.core.scene.impl;

import liberty.core.engine : CoreEngine;
import liberty.core.math.vector : Vector3F;
import liberty.core.objects.camera : Camera;
import liberty.core.objects.node : WorldObject, RootObject;
import liberty.core.scene.world : WorldSettings;
import liberty.core.services : IStartable, IUpdatable, IRenderable;
import liberty.graphics.shader : GfxShader, GfxGenericShader, GfxTerrainShader, GfxUIShader;

/**
 *
**/
final class Scene : IUpdatable, IRenderable {
  private {
    string id;
    bool ready;
    bool registered;
    WorldObject tree;
    Vector3F startPoint;
    Camera activeCamera;
    Camera[string] camerasMap;
    bool[string] objectsId;
    IStartable[string] startList;
    IUpdatable[string] updateList;
    IRenderable[string] renderList;
    GfxGenericShader genericShader;
    GfxTerrainShader terrainShader;
    GfxUIShader uiShader;
    WorldSettings worldSettings;
  }

  /**
   * Create a scene using a unique id.
  **/
  this(string id) {
    CoreEngine.loadScene(this);

    id = id;
    tree = new RootObject();

    genericShader = new GfxGenericShader();
    terrainShader = new GfxTerrainShader();
    uiShader = new GfxUIShader();

    worldSettings = new WorldSettings();
  }

  /**
   * Returns scene unique id.
  **/
  string getId() pure nothrow const {
    return this.id;
  }

  /**
   * Returns true if scene is ready to run.
  **/
  bool isReady() pure nothrow const {
    return ready;
  }

  /**
   * Returns true if scene is registered to the engine.
  **/
  bool isRegistered() pure nothrow const {
    return registered;
  }

  /**
   * Returns a scene tree reference.
  **/
  WorldObject getTree() pure nothrow {
    return tree;
  }

  /**
   * Returns the start point coordinates
  **/
  Vector3F getStartPoint() pure nothrow const {
    return startPoint;
  }

  /**
   * Returns the camera in use by the player.
  **/
  Camera getActiveCamera() {
    return activeCamera;
  }

  /**
   * Set camera as the current view camera.
   * Returns reference to this.
  **/
  Scene setActiveCamera(Camera camera) {
    activeCamera = camera;
    return this;
  }

  /**
   * Register camera to the camera map.
   * Returns reference to this.
  **/
  Scene registerCamera(Camera camera) {
		camerasMap[camera.getId()] = camera;
    return this;
	}

  /**
   * Returns a list with startable objects.
  **/
  IStartable[string] getStartList() pure nothrow {
    return startList;
  }

  /**
   * Returns a list with updatable objects.
  **/
  IUpdatable[string] getUpdateList() pure nothrow {
    return updateList;
  }

  /**
   * Returns a list with renderable objects.
  **/
  IRenderable[string] getRenderList() pure nothrow {
    return renderList;
  }

  /**
   * Add an object to the startable list.
   * Returns reference to this.
  **/
  Scene setStartList(string id, IStartable node) pure nothrow {
    startList[id] = node;
    return this;
  }

  /**
   * Add an object to the updatable list.
   * Returns reference to this.
  **/
  Scene setUpdateList(string id, IUpdatable node) pure nothrow {
    updateList[id] = node;
    return this;
  }

  /**
   * Add an object to the renderable list.
   * Returns reference to this.
  **/
  Scene setRenderList(string id, IRenderable node) pure nothrow {
    renderList[id] = node;
    return this;
  }

  /**
   * Register scene to the CoreEngine.
	 * Invoke start for all IStartable objects that have an start() method.
   * Returns reference to this.
  **/
	Scene register() {
		registered = true;

		if (activeCamera is null)
			activeCamera = tree.spawn!Camera("DefaultCamera");

    foreach (node; startList)
			node.start();

    return this;
	}

  /**
   * Update all objects that have an update() method.
   * The object should implement IUpdatable.
   * It's called every frame.
  **/
  void update() {
    foreach (node; this.updateList)
      node.update();
  }

  /**
   * Render all objects that have a render() method.
   * The object should implement IRenderable.
   * It's called every frame.
  **/
  void render() {
    worldSettings.updateShaders(this, activeCamera);

    foreach(i, node; this.renderList)
      node.render();
  }

  /**
   * Returns a dictionary with all objects id.
  **/
  bool[string] getObjectsId() {
    return objectsId;
  }

  /**
   * Add an object id to the dictionary.
   * Returns reference to this.
  **/
  Scene setObjectId(string key, bool state = true) {
    objectsId[key] = state;
    return this;
  }

  /**
   * Set the default generic shader.
   * Returns reference to this.
  **/
  Scene setGenericShader(GfxGenericShader shader) {
    genericShader = shader;
    return this;
  }

  /**
   * Returns the default generic shader.
  **/
  GfxGenericShader getGenericShader() {
    return genericShader;
  }

  /**
   * Set the default terrain shader.
   * Returns reference to this.
  **/
  Scene setTerrainShader(GfxTerrainShader shader) {
    terrainShader = shader;
    return this;
  }

  /**
   * Returns the default terrain shader.
  **/
  GfxTerrainShader getTerrainShader() {
    return terrainShader;
  }

  /**
   * Set the default ui shader.
   * Returns reference to this.
  **/
  Scene setUIShader(GfxUIShader shader) {
    uiShader = shader;
    return this;
  }

  /**
   * Returns the default ui shader.
  **/
  GfxUIShader getUIShader() {
    return uiShader;
  }

  /**
   * Set the world settings for the scene.
   * Returns reference to this.
  **/
  Scene setWorldSettings(WorldSettings worldSettings) {
    this.worldSettings = worldSettings;
    return this;
  }

  /**
   * Returns the world settings of the scene.
  **/
  WorldSettings getWorldSettings() {
    return worldSettings;
  }
}