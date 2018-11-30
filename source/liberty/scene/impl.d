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
import liberty.world.impl;
import liberty.services;
import liberty.primitive.system;
import liberty.terrain.system;
import liberty.surface.system;
import liberty.light.system;
import liberty.cubemap.system;
import liberty.text.system;
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
    // isInitialized
    bool initialized;
    // getTree
    SceneNode tree;
    // getStartPoint
    Vector3F startPoint;
    // getWorld, setWorld
    World world;
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
    // getTextSystem
    TextSystem textSystem;
    // getRelativePath, setRelativePath
    string relativePath;
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
  this(string id) {
    CoreEngine.loadScene(this);

    this.id = id;
    tree = new RootSceneNode;
    world = new World;
    activeCamera = tree.spawn!Camera("DefaultCamera");

    // Create systems
    primitiveSystem = new PrimitiveSystem(this);
    terrainSystem = new TerrainSystem(this);
    surfaceSystem = new SurfaceSystem(this);
    lightingSystem = new LightingSystem(this);
    cubeMapSystem = new CubeMapSystem(this);
    textSystem = new TextSystem(this);
  }

  /**
   * Returns scene unique id.
  **/
  string getId() pure nothrow const {
    return id;
  }

  /**
   * Returns true if scene is ready to run.
  **/
  bool isReady() pure nothrow const {
    return ready;
  }

  /**
   * Returns true if scene is initialized to the engine.
  **/
  bool isInitialized() pure nothrow const {
    return initialized;
  }

  /**
   * Returns a scene tree reference.
   * See $(D SceneNode) class.
  **/
  SceneNode getTree() pure nothrow {
    return tree;
  }

  /**
   * Returns the start point coordinates.
   * See $(D Vector3F) struct.
  **/
  Vector3F getStartPoint() pure nothrow const {
    return startPoint;
  }

  /**
   * Returns the camera in use by the player.
   * See $(D Camera) class.
  **/
  Camera getActiveCamera() pure nothrow {
    return activeCamera;
  }

  /**
   * Set camera as the current view camera.
   * See $(D Camera) class.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setActiveCamera(Camera camera) pure nothrow {
    activeCamera = camera;
    return this;
  }

  /**
   * Register camera to the camera map.
   * Returns reference to this so it can be used in a stream.
   * See $(D Camera).
  **/
  typeof(this) registerCamera(Camera camera) pure nothrow {
    cameraMap[camera.getId] = camera;
    return this;
  }

  /**
   * Returns the camera in the map that has the given id.
   * See $(D Camera) class.
  **/
  Camera getCameraById(string id) pure nothrow {
    return cameraMap[id];
  }

  /**
   * Returns all elements in the camera map.
   * See $(D Camera) class.
  **/
  Camera[string] getCameraMap() pure nothrow {
    return cameraMap;
  }

  /**
   * Returns all elements in the startable map.
   * See $(D IStartable) interface.
  **/
  IStartable[string] getStartableMap() pure nothrow {
    return startableMap;
  }

  /**
   * Returns all elements in the updateable map.
   * See $(D IUpdateable) interface.
  **/
  IUpdateable[string] getUpdateableMap() pure nothrow {
    return updateableMap;
  }

  /**
   * Add a node to the startable map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setStartableMap(string id, IStartable node) pure nothrow {
    startableMap[id] = node;
    return this;
  }

  /**
   * Add a node to the updateable map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setUpdateableMap(string id, IUpdateable node) pure nothrow {
    updateableMap[id] = node;
    return this;
  }

  /**
   * Initialize scene.
   * Invoke start for all $(D IStartable) objects that have a start() method.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) initialize() {
    initialized = true;
    
    // Start all startable nodes
    foreach (node; startableMap)
      node.start;
    
    return this;
  }

  /**
   * Update all nodes that have an update() method.
   * These nodes must implement $(D IUpdateable).
   * It's called every frame.
  **/
  void update() {
    foreach (node; updateableMap)
      node.update;
  }

  /**
   * Render all renderable systems.
   * It's called every frame after $(D Scene.update).
  **/
  void render() {
    lightingSystem.getRenderer.render;
    cubeMapSystem.getRenderer.render;
    terrainSystem.getRenderer.render;
    primitiveSystem.getRenderer.render;
    surfaceSystem.getRenderer.render;
    textSystem.getRenderer.render;
  }

  /**
   * Returns all elements in the scene node map.
   * See $(D SceneNode) class.
  **/
  SceneNode[string] getNodeMap()  pure nothrow {
    return nodeMap;
  }

  /**
   * Set the world settings for the scene.
   * See $(D World) class.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setWorld(World world) pure nothrow {
    this.world = world;
    return this;
  }

  /**
   * Returns the world settings of the scene.
   * See $(D World) class.
  **/
  World getWorld() pure nothrow {
    return world;
  }

  /**
   * Returns a refetence of the primitive system.
   * See $(D PrimitiveSystem) class.
  **/
  PrimitiveSystem getPrimitiveSystem() pure nothrow {
    return primitiveSystem;
  }

  /**
   * Returns a refetence of the terrain system.
   * See $(D TerrainSystem) class.
  **/
  TerrainSystem getTerrainSystem() pure nothrow {
    return terrainSystem;
  }

  /**
   * Returns a refetence of the surface system.
   * See $(D SurfaceSystem) class.
  **/
  SurfaceSystem getSurfaceSystem() pure nothrow {
    return surfaceSystem;
  }

  /**
   * Returns a refetence of the lighting system.
   * See $(D LightingSystem) class.
  **/
  LightingSystem getLightingSystem() pure nothrow {
    return lightingSystem;
  }

  /**
   * Returns a refetence of the cube map system.
   * See $(D CubeMapSystem) class.
  **/
  CubeMapSystem getCubeMapSystem() pure nothrow {
    return cubeMapSystem;
  }

  /**
   * Returns a refetence of the text system.
   * See $(D CubeMapSystem) class.
  **/
  TextSystem getTextSystem() pure nothrow {
    return textSystem;
  }

  /**
   * Set the relative path of the scene file using a string.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setRelativePath(string relativePath) pure nothrow {
    this.relativePath = relativePath;
    return this;
  }

  /**
   * Returns the relative path of the scene file.
  **/
  string getRelativePath() pure nothrow const {
    return relativePath;
  }
}