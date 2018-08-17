/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/mvc/objects/node/controller.d, _controller.d)
 * Documentation:
 * Coverage:
**/
module liberty.mvc.objects.node.controller;

import liberty.core.system.logic : Logic;
import liberty.mvc.meta : Controller, BindModel, JSON;
import liberty.mvc.objects.node.model : NodeModel;
import liberty.mvc.services : IStartable, IUpdatable, IProcessable;
import liberty.mvc.scene.controller : SceneController;
import liberty.mvc.objects.camera.controller : CameraController;

/**
 * Represents object controller in the scene tree.
**/
@Controller
abstract class NodeController : IStartable, IUpdatable, IProcessable {
  mixin(BindModel);

  /**
   *
  **/
  this(string id, NodeController parent) {
    // Set model id
    model.id = id;
    
    // Set model scene
    model.scene = Logic.self
      .getViewport()
      .getActiveScene();

    // todo: ids

    // Set model parent
    model.parent = parent;
  }

  /**
   *
  **/
  string getId() {
    //return this.model.get!string("id");
    return model.id;
  }

  /**
   * Returns parent.
	**/
  NodeController getParent() pure nothrow @safe {
		return model.parent;
	}

  /**
	 * Returns an array with children references.
  **/
  NodeController[string] children() pure nothrow @safe {
    return model.children;
  }

  /**
   * Returns a child reference using its ID.
  **/
  T child(T)(string id) pure nothrow @trusted {
    return cast(T)model.children[id];
  }

  /**
   *
  **/
  SceneController getScene() pure nothrow @safe {
    return model.scene;
  }

  /**
   * Spawn an object using its reference.
	 * You can specify where to spawn. By default is set to scene tree.
	 * Returns new nodes reference.
	**/
  ref T spawn(T : NodeController)(ref T node, string id, bool start = true) {
		node = new T(id, this);
		insert(node);
		static if (is(T == CameraController)) {
			model.scene.registerCamera(node);
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
  T spawn(T : NodeController)(string id, bool start = true) {
		T node = new T(id, this);
		insert(node);
		static if (is(T == CameraController)) {
			model.scene.registerCamera(node);
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
  ref T spawnOnce(T : NodeController)(ref T node, string id, bool start = true) {
		if (id in _singletonList) {
			return cast(T)_singletonList[id];
		}
		node = new T(id, this);
		insert(node);
		static if (is(T == CameraController)) {
			model.scene.registerCamera(node);
		}
		model.singletonList[id] = node;
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
  T spawnOnce(T : NodeController)(string id, bool start = true) {
		if (id in _singletonList) {
			return cast(T)model.singletonList[id];
		}
		T node = new T(id, this);
		insert(node);
		static if (is(T == CameraController)) {
			model.scene.registerCamera(node);
		}
		model.singletonList[id] = node;
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

  private void insert(T : NodeController)(ref T child) {
    // Insert a child node using its reference.
    model.children[child.getId()] = child;
  }
}

/**
 *
**/
unittest {
  assert(
    (new NodeController("MyNode", null).id) == "MyNode", 
    "Id from serialized model is wrong!"
  );
}