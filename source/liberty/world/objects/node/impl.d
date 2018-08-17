/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/objects/node/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.objects.node.impl;

import liberty.core.system.logic : Logic;
import liberty.world.services : IStartable, IUpdatable, IProcessable;
import liberty.world.scene.impl : Scene;
import liberty.world.objects.camera.impl : Camera;

/**
 * Represents base object in the scene tree.
**/
abstract class WorldObject : IStartable, IUpdatable, IProcessable {
  private {
    string id;
    WorldObject parent;
    WorldObject[string] children;
    Scene scene;
  }

  /**
   *
  **/
  this(string id, WorldObject parent) {
    // Set model id
    this.id = id;
    
    // Set model scene
    this.scene = Logic.self
      .getViewport()
      .getActiveScene();

    // todo: ids

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
   * Returns parent.
	**/
  WorldObject getParent() pure nothrow @safe {
		return this.parent;
	}

  /**
	 * Returns an array with children references.
  **/
  WorldObject[string] getChildren() pure nothrow @safe {
    return this.children;
  }

  /**
   * Returns a child reference using its ID.
  **/
  T child(T)(string id) pure nothrow @trusted {
    return cast(T)this.children[id];
  }

  /**
   *
  **/
  Scene getScene() pure nothrow @safe {
    return this.scene;
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
  void update(in float deltaTime) {}

  /**
   * Called every physics tick. Optional.
  **/
  void process() {}

  private void insert(T : WorldObject)(ref T child) {
    // Insert a child node using its reference.
    this.children[child.getId()] = child;
  }
}