/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/entity.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.entity;

import liberty.camera;
import liberty.core.engine;
import liberty.framework.primitive.bsp;
import liberty.framework.primitive.vertex;
import liberty.framework.terrain.vertex;
import liberty.logger;
import liberty.math.transform;
import liberty.model.impl;
import liberty.scene.constants;
import liberty.scene.impl;
import liberty.scene.services;
import liberty.surface.vertex;

/**
 * Represents a entity in the scene tree.
 * It implements $(D IStartable) and $(D IUpdateable) service.
**/
abstract class Entity : IStartable, IUpdateable {
  private {
    // getId
    string id;
  }
  
  protected {
    // getScene
    Scene scene;
    // getParent
    Entity parent;
    // getChildMap
    Entity[string] childMap;
    // It is used in spawnOnce methods
    Entity[string] singletonMap;
    // setVisibility, getVisibility
    Visibility visibility;
    // getTransform
    Transform transform;
    // setModel, getModel
    Model model;
  }

  /**
   * Set entity's model.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setModel(Model model) pure nothrow {
    this.model = model;
    return this;
  }

  /**
   * Returns the model of the entity.
  **/
  Model getModel() pure nothrow {
    return model;
  }

  /**
   * Construct a scene entity using an id and its parent.
  **/
  this(string id, Entity parent) {
    // Set model scene
    scene = CoreEngine.getScene;
    
    // Check if given id is unique
    if (id in scene.entityMap)
      Logger.error(
        "You already have a scene entity with ID: \"" ~ id ~ "\" in the current scene!",
        typeof(this).stringof
      );

    // Set transformation
    transform = (parent is null)
      ? new Transform(this)
      : new Transform(this, parent.getTransform);

    // Now save this in the scene entity map
    scene.entityMap[id] = this;

    // Set model id and parent
    this.id = id;
    this.parent = parent;
  }

  /**
   * Retuns the scene entity id.
  **/
  string getId() pure nothrow const {
    return id;
  }

  /**
   * Returns a reference of parent scene entity.
  **/
  Entity getParent() pure nothrow {
    return parent;
  }

  /**
   * Returns all elements in the child map.
  **/
  Entity[string] getChildMap() pure nothrow {
    return childMap;
  }

  /**
   * Returns the child in the map that has the given id.
  **/
  T getChild(T)(string id) pure nothrow {
    return (id in childMap) ? cast(T)childMap[id] : null;
  }

  /**
   * Returns scene that scene entity is attached to.
  **/
  Scene getScene() pure nothrow {
    return scene;
  }

  /**
   * Returns true if this scene entity is the root entity.
  **/
  bool isRootEntity() pure nothrow {
    return parent.id == scene.getTree().id;
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
    import liberty.surface.impl : Surface;
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
    T entity = new T(id, this);
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
   * Spawn a scene entity using its reference.
   * Second time you call this method for the same id, nothing happens.
   * Returns old/new entity reference.
  **/
  ref T spawnOnce(T : Entity, bool STRAT = true)(ref T entity, string id, void delegate(T) initMethod = null) {
    if (id in singletonMap)
      return cast(T)singletonMap[id];

    entity = new T(id, this);
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
   * Called after all scene entitys instantiation.
   * It is optional.
  **/
  void start() {}

  /**
   * Called every frame to update the current state of the scene entity.
   * It is optional.
  **/
  void update() {}

  /**
   * Returns transform component used for translation, rotation and scale
  **/
  Transform getTransform() pure nothrow {
    return transform;
  }

  /**
   * Set the visibility of the scene entity.
   * See $(D Visibility) enumeration for possible values.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setVisibility(Visibility visibility) pure nothrow {
    this.visibility = visibility;
    return this;
  }

  /**
   * Returns the visibility of the scene entity.
   * See $(D Visibility) enumeration for possible values.
  **/
  Visibility getVisibility() pure nothrow const {
    return visibility;
  }

  private void insert(T : Entity)(ref T child) pure nothrow {
    // Insert a child entity using its reference.
    childMap[child.getId] = child;
  }
}

/**
 * The root scene entity of a scene.
 * It is the king of all scene entitys.
**/
final class RootEntity : Entity {
  /**
   * Create the root scene entity with the id "Root" and no parent.
  **/
  this() {
    super("RootEntity", null);
  }
}