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
import liberty.framework.gui.vertex;
import liberty.framework.primitive.bsp;
import liberty.framework.primitive.vertex;
import liberty.framework.terrain.vertex;
import liberty.logger;
import liberty.math.transform;
import liberty.model.impl;
import liberty.scene.component;
import liberty.scene.constants;
import liberty.scene.impl;
import liberty.scene.services;

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
    // It is used in spawnOnce methods
    Entity[string] singletonMap;
    // setVisibility, getVisibility
    Visibility visibility;
    // getTransform
    Transform transform;
    // setModel, getModel
    Model model;
    // addComponent, removeComponent
    IComponent[string] componentMap;
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
   *
  **/
  typeof(this) addComponent(T : IComponent)(T component) {
    import std.traits : EnumMembers;
    
    static foreach (e; EnumMembers!ComponentType)
      static if (mixin("is(T == " ~ e ~ ")"))
        componentMap[e] = component;

    return this;
  }

  /**
   *
  **/
  typeof(this) removeComponent(ComponentType type) {
    final switch (type) with (ComponentType) {
      case Transform:
        Logger.warning("Cannot remove transform component ever.", typeof(this).stringof);
    }

    // For future components:
    //componentMap.remove(id);
    
    return this;
  }

  /**
   *
  **/
  T getComponent(T : IComponent)() {
    import std.traits : EnumMembers;

    static foreach (e; EnumMembers!ComponentType)
      static if (mixin("is(T == " ~ e ~ ")"))
        mixin("return cast(" ~ e ~ ")componentMap[e];");
  }

  /**
   * Construct a scene entity using an id and its parent.
  **/
  this(string id) {
    // Set model scene
    scene = CoreEngine.getScene;
    
    // Check if given id is unique
    if (id in scene.getEntityMap)
      Logger.error(
        "You already have a scene entity with ID: \"" ~ id ~ "\" in the current scene!",
        typeof(this).stringof
      );

    // Set transformation
    transform = new Transform(this);
    addComponent(transform);

    // Now save this in the scene entity map
    scene.getEntityMap[id] = this;

    // Set model id
    this.id = id;
  }

  /**
   * Retuns the scene entity id.
  **/
  string getId() pure nothrow const {
    return id;
  }

  /**
   * Returns scene that scene entity is attached to.
  **/
  Scene getScene() pure nothrow {
    return scene;
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
}