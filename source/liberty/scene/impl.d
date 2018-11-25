/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.impl;

import liberty.core.engine;
import liberty.math.vector;
import liberty.camera;
import liberty.scene.node;
import liberty.scene.world;
import liberty.services;
import liberty.primitive.system;
import liberty.terrain.system;
import liberty.surface.system;
import liberty.light.system;
import liberty.cubemap.system;
import liberty.scene.serializer;
import liberty.scene.factory;

/**
 * A scene is a 3D space where you can place different objects,
 * like primitives, terrains, lights and surfaces.
 * It implements $(D ISceneFactory), $(D IStartable) and $(D IUpdateable) services.
**/
final class Scene : ISceneFactory, IUpdateable, IRenderable {
  private {
    // isReady
    bool ready;
    // isRegistered
    bool registered;
    
    // getTree
    SceneNode tree;
    // getStartPoint
    Vector3F startPoint;
    // getWorld, setWorld
    World world;
    // getSerializer
    SceneSerializer serializer;
    
    // getActiveCamera, setActiveCamera
    Camera activeCamera;
    // registerCamera, getCameraById, getCameraMap
    Camera[string] cameraMap;

    // getStartableMap
    IStartable[string] startableMap;
    // getUpdateableMap
    IUpdateable[string] updateableMap;
    
    // getPrimitiveSystem
    PrimitiveSystem primitiveSystem;
    // getTerrainSystem
    TerrainSystem terrainSystem;
    // getSurfaceSystem
    SurfaceSystem surfaceSystem;
    // getLightingSystem
    LightingSystem lightingSystem;
    // getCubeMapSystem
    CubeMapSystem cubeMapSystem;
  }

  package {
    // It is necessary to modify it in SceneSerializer class
    string id;

    // It is necessary to modify it in Node class
    // getNodeMap
    SceneNode[string] nodeMap;
  }

  /**
   * Create a scene using a unique id.
  **/
  this(SceneSerializer serializer) {
    CoreEngine.loadScene(this);

    tree = new RootSceneNode();
    world = new World();

    // Create systems
    primitiveSystem = new PrimitiveSystem(this);
    terrainSystem = new TerrainSystem(this);
    surfaceSystem = new SurfaceSystem(this);
    lightingSystem = new LightingSystem(this);
    cubeMapSystem = new CubeMapSystem(this);

    // Init serializer
    serializer
      .setScene(this)
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
   * See $(D SceneNode).
  **/
  SceneNode getTree() pure nothrow {
    return tree;
  }

  /**
   * Returns the start point coordinates.
   * See $(D Vector3F).
  **/
  Vector3F getStartPoint() pure nothrow const {
    return startPoint;
  }

  /**
   * Returns the camera in use by the player.
   * See $(D Camera).
  **/
  Camera getActiveCamera() pure nothrow {
    return activeCamera;
  }

  /**
   * Set camera as the current view camera.
   * Returns reference to this so it can be used in a stream.
   * See $(D Camera).
  **/
  Scene setActiveCamera(Camera camera) pure nothrow {
    activeCamera = camera;
    return this;
  }

  /**
   * Register camera to the camera map.
   * Returns reference to this so it can be used in a stream.
   * See $(D Camera).
  **/
  Scene registerCamera(Camera camera) pure nothrow {
    cameraMap[camera.getId()] = camera;
    return this;
  }

  /**
   * Returns the camera in the map that has the given id.
   * See $(D Camera).
  **/
  Camera getCameraById(string id) pure nothrow {
    return cameraMap[id];
  }

  /**
   * Returns all elements in the camera map.
   * See $(D Camera).
  **/
  Camera[string] getCameraMap() pure nothrow {
    return cameraMap;
  }

  /**
   * Returns all elements in the startable map.
   * See $(D IStartable).
  **/
  IStartable[string] getStartableMap() pure nothrow {
    return startableMap;
  }

  /**
   * Returns all elements in the updateable map.
   * See $(D IUpdateable).
  **/
  IUpdateable[string] getUpdateableMap() pure nothrow {
    return updateableMap;
  }

  /**
   * Add a node to the startable map.
   * Returns reference to this so it can be used in a stream.
  **/
  Scene setStartableMap(string id, IStartable node) pure nothrow {
    startableMap[id] = node;
    return this;
  }

  /**
   * Add a node to the updateable map.
   * Returns reference to this so it can be used in a stream.
  **/
  Scene setUpdateableMap(string id, IUpdateable node) pure nothrow {
    updateableMap[id] = node;
    return this;
  }

  /**
   * Initialize scene.
   * Invoke start for all $(D IStartable) objects that have a start() method.
   * Returns reference to this so it can be used in a stream.
  **/
  Scene initialize() {
    registered = true;
    
    // If camera doesn't exist, the spawn a default camera
    if (activeCamera is null)
      activeCamera = tree.spawn!Camera("DefaultCamera");
    
    // Start all startable nodes
    foreach (node; startableMap)
      node.start();
    
    return this;
  }

  /**
   * Update all nodes that have an update() method.
   * These nodes must implement $(D IUpdateable).
   * It's called every frame.
  **/
  void update() {
    foreach (node; updateableMap)
      node.update();
  }

  /**
   * Render all nodes that have a $(D Renderer) component.
   * It's called every frame after $(D Scene.update).
  **/
  void render() {
    // Render all scene lights
    lightingSystem.getRenderer().render();

    // Render all cubeMapes
    cubeMapSystem.getRenderer().render();

    // Render all scene terrains
    terrainSystem.getRenderer().render();

    // Render all scene primitives
    primitiveSystem.getRenderer().render();

    // Render all scene surfaces
    surfaceSystem.getRenderer().render();
  }

  /**
   * Returns all elements in the scene node map.
   * See $(D SceneNode).
  **/
  SceneNode[string] getNodeMap()  pure nothrow {
    return nodeMap;
  }

  /**
   * Set the world settings for the scene.
   * Returns reference to this so it can be used in a stream.
   * See $(D World).
  **/
  Scene setWorld(World world) pure nothrow {
    this.world = world;
    return this;
  }

  /**
   * Returns the world settings of the scene.
   * See $(D World).
  **/
  World getWorld() pure nothrow {
    return world;
  }

  /**
   * Returns a refetence of primitive system.
   * See $(D PrimitiveSystem).
  **/
  PrimitiveSystem getPrimitiveSystem() pure nothrow {
    return primitiveSystem;
  }

  /**
   * Returns a refetence of terrain system.
   * See $(D TerrainSystem).
  **/
  TerrainSystem getTerrainSystem() pure nothrow {
    return terrainSystem;
  }

  /**
   * Returns a refetence of surface system.
   * See $(D SurfaceSystem).
  **/
  SurfaceSystem getSurfaceSystem() pure nothrow {
    return surfaceSystem;
  }

  /**
   * Returns a refetence of lighting system.
   * See $(D LightingSystem).
  **/
  LightingSystem getLightingSystem() pure nothrow {
    return lightingSystem;
  }

  /**
   * Returns a refetence of cube map system.
   * See $(D CubeMapSystem).
  **/
  CubeMapSystem getCubeMapSystem() pure nothrow {
    return cubeMapSystem;
  }

  /**
   * Returns a refetence of scene serializer.
   * See $(D SceneSerializer).
  **/
  SceneSerializer getSerializer() pure nothrow {
    return serializer;
  }
}
