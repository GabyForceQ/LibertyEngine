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

/// A scene is a 3D space where you can place different objects,
/// like primitives, terrains, lights and guis.
/// It implements $(D ISceneFactory), $(D IStartable) and $(D IUpdateable) services.
final class Scene : ISceneFactory, IUpdateable {
  ///
  string id;
  ///
  bool initialized;
  ///
  string relativePath;
  ///
  Camera camera;
  ///
  Entity[string] entityMap;
  ///
  Vector3F startPoint;
  ///
  World world;
  ///
  Camera[string] cameraMap;
  ///
  IStartable[string] startableMap;
  ///
  IUpdateable[string] updateableMap;
  ///
  Shader[string] shaderMap;
  ///
  Light[string] lightMap;

  /// Create a scene using a unique id.
  this(string id) {
    CoreEngine.scene = this;

    this.id = id;
    world = new World;
    camera = spawn!Camera("DefaultCamera");
  }

  /// Initialize scene.
  /// Invoke start for all $(D IStartable) objects that have a start() method.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) initialize() {
    initialized = true;
    
    // Start all startable entitys
    foreach (entity; startableMap)
      entity.start;
    
    return this;
  }

  /// Update all entitys that have an update() method.
  /// These entitys must implement $(D IUpdateable).
  /// It's called every frame.
  void update() {
    foreach (entity; updateableMap)
      entity.update;
  }

  /// Render all renderable systems.
  /// It's called every frame after $(D Scene.update).
  void render() {
    // Apply all lights to the scene
    applyLights;

    // Render all shaders to the scene
    foreach (shader; shaderMap)
      shader.render(this);
  }

  ///
  T entity(T)(string id)   {
    return cast(T)entityMap[id];
  }

  /// Spawn a scene entity using its reference.
  /// You can specify where to spawn. By default is set to scene tree.
  // Returns new entitys reference.
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

  /// Spawn a scene entity using its ID.
  /// Second time you call this method for the same id, an assertion is produced.
  /// Returns new entity reference.
  T spawn(T : Entity, bool STRAT = true)(string id, void delegate(T) initMethod = null) {
    T entity = new T(id);
    entityMap[id] = entity;

    static if (is(T == Camera))
      cameraMap[entity.id] = entity;

    static if (STRAT)
      entity.start;

    if (initMethod !is null)
      initMethod(entity);

    return entity;
  }
  
  /// Spawn a scene entity using its reference.
  /// Second time you call this method for the same id, nothing happens.
  /// Returns old/new entity reference.
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

  /// Spawn a scene entity using its ID.
  /// Second time you call this method for the same id, nothing happens.
  /// Returns old/new entity reference.
  T spawnOnce(T : Entity, bool STRAT = true)(string id, void delegate(T) initMethod = null) {    
    if (id in singletonMap)
      return cast(T)singletonMap[id];

    T entity = new T(id, this);
    insert(entity);

    static if (is(T == Camera))
      scene.cameraMap[entity.id] = entity;

    singletonMap[id] = entity;

    static if (STRAT)
      entity.start;

    if (initMethod !is null)
      initMethod(entity);

    return entity;
  }

  /// Remove a child entity using its reference.
  /// Returns reference to this so it can be used in a stream.
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
          if (light.visibility == Visibility.Visible)
            light.applyTo(id);
        
        Shader
          .getOrCreate(id)
          .getProgram
          .unbind;
      }
  }
}