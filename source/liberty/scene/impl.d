/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/impl.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - implement IProcessable
**/
module liberty.scene.impl;

import liberty.core.engine;
import liberty.math.vector;
import liberty.camera;
import liberty.scene.node;
import liberty.scene.world;
import liberty.services;
import liberty.graphics.shader;
import liberty.surface.shader;
import liberty.primitive.shader;
import liberty.primitive.renderer;
import liberty.primitive.impl;
import liberty.terrain.shader;
import liberty.terrain.renderer;
import liberty.terrain.impl;
import liberty.surface.renderer;
import liberty.surface.impl;
import liberty.light.system;
import liberty.scene.serializer;

/**
 *
**/
final class Scene : IUpdatable, IRenderable {
  private {
    string id;
    bool ready;
    bool registered;
    
    SceneNode tree;
    Vector3F startPoint;
    WorldSettings worldSettings;
    SceneSerializer serializer;
    
    Camera activeCamera;
    Camera[string] camerasMap;
    bool[string] objectsId;

    IStartable[string] startList;
    IUpdatable[string] updateList;
    IRenderable[string] renderList;
    
    PrimitiveRenderer primitiveRenderer;
    PrimitiveShader primitiveShader;
    Primitive[string] primitiveMap;
    
    SurfaceRenderer surfaceRenderer;
    SurfaceShader surfaceShader;
    Surface[string] surfaceMap;

    TerrainRenderer terrainRenderer;
    TerrainShader terrainShader;
    Terrain[string] terrainMap;

    LightingSystem lightingSystem; 
  }

  /**
   * Create a scene using a unique id.
  **/
  this(SceneSerializer serializer) {
    CoreEngine.loadScene(this);

    tree = new RootObject();
    worldSettings = new WorldSettings();

    // Init primitive system
    primitiveRenderer = new PrimitiveRenderer(this);
    primitiveShader = new PrimitiveShader();
    
    // Init surface system
    surfaceRenderer = new SurfaceRenderer(this);
    surfaceShader = new SurfaceShader();

    // Init terrain system
    terrainRenderer = new TerrainRenderer(this);
    terrainShader = new TerrainShader();

    // Create systems
    lightingSystem = new LightingSystem(this);

    // Init serializer
    serializer
      .registerScene(this)
      .deserialize();
    this.serializer = serializer;
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
  SceneNode getTree() pure nothrow {
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
   * Returns reference to this and can be used in a stream.
  **/
  Scene setActiveCamera(Camera camera) {
    activeCamera = camera;
    return this;
  }

  /**
   * Register camera to the camera map.
   * Returns reference to this and can be used in a stream.
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
   * Returns reference to this and can be used in a stream.
  **/
  Scene setStartList(string id, IStartable node) pure nothrow {
    startList[id] = node;
    return this;
  }

  /**
   * Add an object to the updatable list.
   * Returns reference to this and can be used in a stream.
  **/
  Scene setUpdateList(string id, IUpdatable node) pure nothrow {
    updateList[id] = node;
    return this;
  }

  /**
   * Add an object to the renderable list.
   * Returns reference to this and can be used in a stream.
  **/
  Scene setRenderList(string id, IRenderable node) pure nothrow {
    renderList[id] = node;
    return this;
  }

  /**
   * Register scene to the CoreEngine.
	 * Invoke start for all IStartable objects that have an start() method.
   * Returns reference to this and can be used in a stream.
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

    // Render all scene lights
    lightingSystem.getRenderer().render();

    // Render all scene terrains
    terrainRenderer.render();

    // Render all scene primitives
    primitiveRenderer.render();

    // Render all scene surfaces
    surfaceRenderer.render();
  }

  /**
   * Returns a dictionary with all objects id.
  **/
  bool[string] getObjectsId() {
    return objectsId;
  }

  /**
   * Add an object id to the dictionary.
   * Returns reference to this and can be used in a stream.
  **/
  Scene setObjectId(string key, bool state = true) {
    objectsId[key] = state;
    return this;
  }

  /**
   * Set the default generic shader.
   * Returns reference to this and can be used in a stream.
  **/
  Scene setPrimitiveShader(PrimitiveShader shader) {
    primitiveShader = shader;
    return this;
  }

  /**
   * Returns the default generic shader.
  **/
  PrimitiveShader getPrimitiveShader() {
    return primitiveShader;
  }

  /**
   * Set the default terrain shader.
   * Returns reference to this and can be used in a stream.
  **/
  Scene setTerrainShader(TerrainShader shader) {
    terrainShader = shader;
    return this;
  }

  /**
   * Returns the default terrain shader.
  **/
  TerrainShader getTerrainShader() {
    return terrainShader;
  }

  /**
   * Set the default ui shader.
   * Returns reference to this and can be used in a stream.
  **/
  Scene setSurfaceShader(SurfaceShader shader) {
    surfaceShader = shader;
    return this;
  }

  /**
   * Returns the default ui shader.
  **/
  SurfaceShader getSurfaceShader() {
    return surfaceShader;
  }

  /**
   * Set the world settings for the scene.
   * Returns reference to this and can be used in a stream.
  **/
  Scene setWorldSettings(WorldSettings worldSettings) {
    this.worldSettings = worldSettings;
    return this;
  }

  /**
   * Returns the world settings of the scene.
  **/
  WorldSettings getWorldSettings() pure nothrow {
    return worldSettings;
  }

  /**
   *
  **/
  Scene registerPrimitive(Primitive node) {
    primitiveMap[node.getId()] = node;
    return this;
  }

  /**
   *
  **/
  Primitive[string] getPrimitiveMap() pure nothrow {
    return primitiveMap;
  }

  /**
   *
  **/
  Primitive getPrimitive(string id) pure nothrow {
    return primitiveMap[id];
  }

  /**
   *
  **/
  PrimitiveRenderer getPrimitiveRenderer() pure nothrow {
    return primitiveRenderer;
  }

  /**
   *
  **/
  Scene registerSurface(Surface node) {
    surfaceMap[node.getId()] = node;
    return this;
  }

  /**
   *
  **/
  Surface[string] getSurfaceMap() pure nothrow {
    return surfaceMap;
  }

  /**
   *
  **/
  Surface getSurface(string id) pure nothrow {
    return surfaceMap[id];
  }

  /**
   *
  **/
  SurfaceRenderer getSurfaceRenderer() pure nothrow {
    return surfaceRenderer;
  }

  /**
   *
  **/
  Scene registerTerrain(Terrain node) {
    terrainMap[node.getId()] = node;
    return this;
  }

  /**
   *
  **/
  Terrain[string] getTerrainMap() pure nothrow {
    return terrainMap;
  }

  /**
   *
  **/
  Terrain getTerrain(string id) pure nothrow {
    return terrainMap[id];
  }

  /**
   *
  **/
  TerrainRenderer getTerrainRenderer() pure nothrow {
    return terrainRenderer;
  }

  /**
   *
  **/
  LightingSystem getLightingSystem() pure nothrow {
    return lightingSystem;
  }

  /**
   *
  **/
  SceneSerializer getSerializer() pure nothrow {
    return serializer;
  }

  package void setId(string id) pure nothrow {
    this.id = id;
  }
}