/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/node.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.node;

import liberty.math.transform;
import liberty.logger;
import liberty.core.engine;
import liberty.services;
import liberty.scene.impl;
import liberty.primitive.bsp;
import liberty.camera;
import liberty.primitive.vertex;
import liberty.surface.vertex;
import liberty.terrain.vertex;

/**
 * Represents a node in the scene tree.
 * It implements $(D IStartable) and $(D IUpdateable) service.
**/
abstract class SceneNode : IStartable, IUpdateable {
  private {
    // getId
    string id;
    // getScene
    Scene scene;
    
    // getParent
    SceneNode parent;
    // getChildMap
    SceneNode[string] childMap;
    // It is used in spawnOnce methods
    SceneNode[string] singletonMap;
    
    // Transform component used for translation, rotation and scale
    Transform3 transform;
  }

  /**
   * Construct a scene node using an id and its parent.
  **/
  this(string id, SceneNode parent) {
    // Set model scene
    scene = CoreEngine.getScene();
    
    // Check if given id is unique
    if (id in scene.nodeMap)
      Logger.error(
        "You already have a scene node with ID: \"" ~ id ~ "\" in the current scene!",
        typeof(this).stringof
      );

    // Set transformation
    transform = (parent is null)
      ? new Transform3(this)
      : new Transform3(this, parent.getTransform());

    // Now save this in the scene node map
    scene.nodeMap[id] = this;

    // Set model id and parent
    this.id = id;
    this.parent = parent;
  }

  /**
   * Retuns the scene node id.
  **/
  string getId() pure nothrow const {
    return id;
  }

  /**
   * Returns a reference of parent scene node.
  **/
  SceneNode getParent() pure nothrow {
    return parent;
  }

  /**
   * Returns all elements in the child map.
  **/
  SceneNode[string] getChildMap() pure nothrow {
    return childMap;
  }

  /**
   * Returns the child in the map that has the given id.
  **/
  T getChild(T)(string id) pure nothrow {
    return (id in childMap) ? cast(T)childMap[id] : null;
  }

  /**
   * Returns scene that scene node is attached to.
  **/
  Scene getScene() pure nothrow {
    return scene;
  }

  /**
   * Returns true if this scene node is the root node.
  **/
  bool isRootNode() pure nothrow {
    return parent.id == scene.getTree().id;
  }

  /**
   * Remove a child node using its reference.
  **/
  void remove(T : SceneNode)(ref T child) {
    if (child in childMap) {
      childMap.remove(child.id);
      
      scene.getStartableMap().remove(child.id);
      scene.getUpdateableMap().remove(child.id);
      scene.getNodeMap().remove(child.id);
      
      static if (is(T == Camera))
        scene.clearCamera(child);

      child.destroy();
      child = null;
      
      return;
    }
    
    Logger.warning(
      "You are trying to remove a null scene node",
      typeof(this).stringof
    );
  }

  /**
   * Remove a child node using its id.
  **/
  void remove(string id) {
    foreach (child; childMap)
      if (child.id == id) {
        childMap.remove(child.id);
        
        scene.getStartableMap().remove(child.id);
        scene.getUpdateableMap().remove(child.id);
        scene.getNodeMap().remove(child.id);
        
        static if (is(T == Camera))
          scene.clearCamera(child);
        
        child.destroy();
        child = null;
        
        return;
      }
    
    Logger.warning(
      "You are trying to remove a null scene node",
      typeof(this).stringof
    );
  }

  /**
   * Spawn a scene node using its reference.
   * You can specify where to spawn. By default is set to scene tree.
   * Returns new nodes reference.
  **/
  ref T spawn(T : SceneNode, bool STRAT = true)(ref T node, string id, void delegate(T) initMethod = null) {
    node = new T(id, this);
    insert(node);

    static if (is(T == Camera))
      this.scene.registerCamera(node);

    static if (STRAT)
      node.start();

    if (initMethod !is null)
      initMethod(node);
	
    return node;
  }

  /**
   * Spawn a scene node using its ID.
   * Second time you call this method for the same id, an assertion is produced.
   * Returns new node reference.
  **/
  T spawn(T : SceneNode, bool STRAT = true)(string id, void delegate(T) initMethod = null) {
    T node = new T(id, this);
    insert(node);

    static if (is(T == Camera))
      this.scene.registerCamera(node);

    static if (STRAT)
      node.start();

    if (initMethod !is null)
      initMethod(node);

    return node;
  }
  
  /**
   * Spawn a scene node using its reference.
   * Second time you call this method for the same id, nothing happens.
   * Returns old/new node reference.
  **/
  ref T spawnOnce(T : SceneNode, bool STRAT = true)(ref T node, string id, void delegate(T) initMethod = null) {
    if (id in singletonMap)
      return cast(T)singletonMap[id];

    node = new T(id, this);
    insert(node);

    static if (is(T == Camera))
      scene.registerCamera(node);
    
    singletonMap[id] = node;

    static if (STRAT)
      node.start();

    if (initMethod !is null)
      initMethod(node);

    return node;
  }

  /**
   * Spawn a scene node using its ID.
   * Second time you call this method for the same id, nothing happens.
   * Returns old/new node reference.
  **/
  T spawnOnce(T : SceneNode, bool STRAT = true)(string id, void delegate(T) initMethod = null) {    
    if (id in singletonMap)
      return cast(T)singletonMap[id];

    T node = new T(id, this);
    insert(node);

    static if (is(T == Camera))
      scene.registerCamera(node);

    singletonMap[id] = node;

    static if (STRAT)
      node.start();

    if (initMethod !is null)
      initMethod(node);

    return node;
  }

  /**
   * Called after all scene nodes instantiation.
   * It is optional.
  **/
  void start() {}

  /**
   * Called every frame to update the current state of the scene node.
   * It is optional.
  **/
  void update() {}

  /**
   * Returns transform.
  **/
  Transform3 getTransform() pure nothrow {
    return transform;
  }

  private void insert(T : SceneNode)(ref T child) pure nothrow {
    // Insert a child node using its reference.
    childMap[child.getId()] = child;
  }
}

/**
 * The root scene node of a scene.
 * It is the king of all scene nodes.
**/
final class RootSceneNode : SceneNode {
  /**
   * Create the root scene node with the id "Root" and no parent.
  **/
  this() {
    super("RootNode", null);
  }
}
