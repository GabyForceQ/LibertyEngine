/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/node.d, _node.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - implement IProcessable
**/
module liberty.core.objects.node;

import liberty.core.logger : Logger;
import liberty.core.engine : CoreEngine;
import liberty.core.services : IStartable, IUpdatable;
import liberty.core.scene : Scene;
import liberty.core.objects.camera : Camera;
import liberty.core.components.transform : Transform;

/**
 * Represents base object in the scene tree.
**/
abstract class WorldObject : IStartable, IUpdatable {
  private {
    string id;
    WorldObject parent;
    WorldObject[string] children;
    Scene scene;
    WorldObject[string] singletonList;
    Transform transform;
  }

  /**
   *
  **/
  this(string id, WorldObject parent) {
    // Set model scene
    scene = CoreEngine.getScene();

    // Set transformation
    transform = Transform(this);
    
    // Check if given id is unique
    if (id in this.scene.getObjectsId()) {
      Logger.error(
        "You already have an object with ID: \"" ~ id ~ "\" in the current scene!",
        typeof(this).stringof
      );
		}

    // Now save the id in the ids map
    scene.setObjectId(id);

    // Set model id
    this.id = id;

    // Set model parent
    this.parent = parent;
  }

  /**
   *
  **/
  string getId() {
    return this.id;
  }

  /**
   *
  **/
  ref Transform getTransform() pure nothrow {
    return transform;
  }

  /**
   * Returns parent.
	**/
  WorldObject getParent() pure nothrow {
		return this.parent;
	}

  /**
	 * Returns an array with children references.
  **/
  WorldObject[string] getChildren() pure nothrow {
    return this.children;
  }

  /**
   * Returns a child reference using its ID.
  **/
  T child(T)(string id) pure nothrow {
    return cast(T)this.children[id];
  }

  /**
   *
  **/
  Scene getScene() pure nothrow {
    return this.scene;
  }

  /**
   * Remove a child node using its reference.
  **/
  void remove(T : WorldObject)(ref T child) {
    if (child in _children) {
      this.children.remove(child.id);
      this.scene.getStartList().remove(child.id);
      this.scene.getUpdateList().remove(child.id);
      this.scene.getRenderList().remove(child.id);
      this.scene.getObjectsId.remove(child.id);
      static if (is(T == Camera)) {
        _scene.clearCamera(child);
      }
      child.destroy();
      child = null;
      return;
    }
    Logger.warning(
      "You are trying to remove a null object",
      typeof(this).stringof
    );
  }

  /**
   * Remove a child node using its id.
  **/
  void remove(string id) {
    foreach (child; this.children) {
      if (child.id == id) {
        this.children.remove(child.id);
        this.scene.getStartList().remove(child.id);
        this.scene.getUpdateList().remove(child.id);
        this.scene.getRenderList().remove(child.id);
        this.scene.getObjectsId.remove(child.id);
        static if (is(T == Camera)) {
          this.scene.clearCamera(child);
        }
        child.destroy();
        child = null;
        return;
      }
    }
    Logger.warning(
      "You are trying to remove a null object",
      typeof(this).stringof
    );
  }

  /**
   * Spawn an object using its reference.
	 * You can specify where to spawn. By default is set to scene tree.
	 * Returns new nodes reference.
	**/
  ref T spawn(T : WorldObject)(ref T node, string id, bool start = true) {
		node = new T(id, this);
		insert(node);
		static if (is(T == Camera)) {
			this.scene.registerCamera(node);
		}
		if (start) {
			node.start();
		}
		return node;
	}

  /**
	 * Spawn an object using its ID.
	 * Second time you call this method for the same id, an assertion is produced.
	 * Returns new node reference.
	**/
  T spawn(T : WorldObject)(string id, bool start = true) {
		T node = new T(id, this);
		insert(node);
		static if (is(T == Camera)) {
			this.scene.registerCamera(node);
		}
		if (start) {
			node.start();
		}
		return node;
	}
  
  /**
	 * Spawn an object using its reference.
	 * Second time you call this method for the same id, nothing happens.
	 * Returns old/new node reference.
	**/
  ref T spawnOnce(T : WorldObject)(ref T node, string id, bool start = true) {
		if (id in _singletonList) {
			return cast(T)_singletonList[id];
		}
		node = new T(id, this);
		insert(node);
		static if (is(T == Camera)) {
			this.scene.registerCamera(node);
		}
		this.singletonList[id] = node;
		if (start) {
			node.start();
		}
		return node;
	}

  /**
	 * Spawn an object using its ID only once.
	 * Second time you call this method for the same id, nothing happens.
	 * Returns old/new node reference.
	**/
  T spawnOnce(T : WorldObject)(string id, bool start = true) {
		if (id in _singletonList) {
			return cast(T)this.singletonList[id];
		}
		T node = new T(id, this);
		insert(node);
		static if (is(T == Camera)) {
			this.scene.registerCamera(node);
		}
		this.singletonList[id] = node;
		if (start) {
			node.start();
		}
		return node;
	}

  /**
   * Called after all objects instantiation. Optional.
  **/
  void start() {}

  /**
   * Called every frame. Optional.
  **/
  void update() {}

  private void insert(T : WorldObject)(ref T child) {
    // Insert a child node using its reference.
    this.children[child.getId()] = child;
  }
}

/**
 *
**/
final class RootObject : WorldObject {
  /**
   *
  **/
  this() {
    super("Root", null);
  }
}