/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.impl;

import liberty.camera;
import liberty.core.engine;
import liberty.framework.light.impl;
import liberty.graphics.shader.impl;
import liberty.math.vector;
import liberty.scene.constants;
import liberty.scene.entity;
import liberty.scene.factory;
import liberty.scene.services;
import liberty.text.system;
import liberty.world.impl;

/**
 * A scene is a 3D space where you can place different objects,
 * like primitives, terrains, lights and guis.
 * It implements $(D ISceneFactory), $(D IStartable) and $(D IUpdateable) services.
**/
final class Scene : ISceneFactory, IUpdateable {
  private {
    // isReady
    bool ready;
    // isInitialized
    bool initialized;
    // getRelativePath, setRelativePath
    string relativePath;
    // getEntityMap
    Entity[string] entityMap;
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
    // getShader, addShader
    Shader[string] shaderMap;
    // addLight
    Light[string] lightMap;
  }

  package {
    // It is necessary to modify it in SceneSerializer class
    string id;
  }

  /**
   * Create a scene using a unique id.
  **/
  this(string id) {
    CoreEngine.loadScene(this);

    this.id = id;
    world = new World;
    activeCamera = spawn!Camera("DefaultCamera");
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
   * Add a entity to the startable map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setStartableMap(string id, IStartable entity) pure nothrow {
    startableMap[id] = entity;
    return this;
  }

  /**
   * Add a entity to the updateable map.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setUpdateableMap(string id, IUpdateable entity) pure nothrow {
    updateableMap[id] = entity;
    return this;
  }

  /**
   * Initialize scene.
   * Invoke start for all $(D IStartable) objects that have a start() method.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) initialize() {
    initialized = true;
    
    // Start all startable entitys
    foreach (entity; startableMap)
      entity.start;
    
    return this;
  }

  /**
   * Update all entitys that have an update() method.
   * These entitys must implement $(D IUpdateable).
   * It's called every frame.
  **/
  void update() {
    foreach (entity; updateableMap)
      entity.update;
  }

  /**
   * Render all renderable systems.
   * It's called every frame after $(D Scene.update).
  **/
  void render() {
    // Apply all lights to the scene
    applyLights;

    // Render all shaders to the scene
    foreach (shader; shaderMap)
      shader.render(this);
  }

  /**
   * Returns all elements in the scene entity map.
   * See $(D Entity) class.
  **/
  Entity[string] getEntityMap() pure nothrow {
    return entityMap;
  }

  /**
   *
  **/
  T getEntity(T)(string id) pure nothrow {
    return cast(T)entityMap[id];
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
   * Add a new shader renderer to the scene.
   * Returns reference to this so it can be used in a stream.
   * See $(D Shader) class.
  **/
  typeof(this) addShader(Shader shader) pure nothrow {
    shaderMap[shader.getId] = shader;
    return this;
  }

  /**
   * Returns the shader with the given id.
   * See $(D Shader) class.
  **/
  Shader getShaderById(string id) pure nothrow {
    return shaderMap[id];
  }

  /**
   * Add a new light to the light map.
   * Returns reference to this so it can be used in a stream.
   * See $(D Light) class.
  **/
  typeof(this) addLight(Light light) {
    lightMap[light.getId] = light;
    return this;
  }

  /**
   * Returns the light with the given id.
   * See $(D Shader) class.
  **/
  Light getLightById(string id) pure nothrow {
    return lightMap[id];
  }

  /**
   * Spawn a scene entity using its reference.
   * You can specify where to spawn. By default is set to scene tree.
   * Returns new entitys reference.
  **/
  ref T spawn(T : Entity, bool STRAT = true)(ref T entity, string id, void delegate(T) initMethod = null) {
    entity = new T(id, this);
    insert(entity);

    static if (is(T == Camera))
      this.scene.registerCamera(entity);

    static if (STRAT)
      entity.start;

    if (initMethod !is null)
      initMethod(entity);
	
    return entity;
  }

  /**
   * Spawn a scene entity using its ID.
   * Second time you call this method for the same id, an assertion is produced.
   * Returns new entity reference.
  **/
  T spawn(T : Entity, bool STRAT = true)(string id, void delegate(T) initMethod = null) {
    T entity = new T(id);
    entityMap[id] = entity;

    static if (is(T == Camera))
      registerCamera(entity);

    static if (STRAT)
      entity.start;

    if (initMethod !is null)
      initMethod(entity);

    return entity;
  }
  
  /**
   * Spawn a scene entity using its reference.
   * Second time you call this method for the same id, nothing happens.
   * Returns old/new entity reference.
  **/
  ref T spawnOnce(T : Entity, bool STRAT = true)(ref T entity, string id, void delegate(T) initMethod = null) {
    if (id in singletonMap)
      return cast(T)singletonMap[id];

    entity = new T(id);
    entityMap[id] = entity;

    static if (is(T == Camera))
      registerCamera(entity);
    
    singletonMap[id] = entity;

    static if (STRAT)
      entity.start;

    if (initMethod !is null)
      initMethod(entity);

    return entity;
  }

  /**
   * Spawn a scene entity using its ID.
   * Second time you call this method for the same id, nothing happens.
   * Returns old/new entity reference.
  **/
  T spawnOnce(T : Entity, bool STRAT = true)(string id, void delegate(T) initMethod = null) {    
    if (id in singletonMap)
      return cast(T)singletonMap[id];

    T entity = new T(id, this);
    insert(entity);

    static if (is(T == Camera))
      scene.registerCamera(entity);

    singletonMap[id] = entity;

    static if (STRAT)
      entity.start;

    if (initMethod !is null)
      initMethod(entity);

    return entity;
  }

  /**
   * Remove a child entity using its reference.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) remove(T : Entity)(T entity) {
    import std.traits : EnumMembers;
    import liberty.framework.light.impl : Light;
    import liberty.framework.primitive.impl : Primitive;
    import liberty.framework.skybox.impl : SkyBox;
    import liberty.framework.terrain.impl : Terrain;
    import liberty.framework.gui.impl : Gui;
    import liberty.text.impl : Text;

    const id = entity.getId();

    if (id in childMap) {
      // Remove entity from scene maps
      static foreach (e; ["Startable", "Updateable", "Entity"])
        mixin("scene.get" ~ e ~ "Map.remove(id);");

      // Remove entity from system
      static foreach (sys; EnumMembers!SystemType)
        static if (mixin("is(T : " ~ sys ~ ")"))
          mixin("scene.get" ~ sys ~ "System.removeElementById(id);");
      
      //static if (is(T == Camera))
      //  scene.safeRemoveCamera(id);

      // Remove entity from child map
      childMap[id].destroy;
      childMap[id] = null;
      childMap.remove(id);
      
      return this;
    }
    
    Logger.warning(
      "You are trying to remove a null scene entity",
      typeof(this).stringof
    );

    return this;
  }

  private void applyLights() {
    foreach (id; ["Primitive", "Terrain"]) 
      if (Shader.exists(id)) {
        Shader
          .getOrCreate(id)
          .getProgram
          .bind;

        foreach (light; lightMap)
          if (light.getVisibility == Visibility.Visible)
            light.applyTo(id);
        
        Shader
          .getOrCreate(id)
          .getProgram
          .unbind;
      }
  }
}