/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.core.scenegraph.node;
import liberty.core.engine: CoreEngine;
import liberty.core.scenegraph.services: Startable, Updatable, Processable;
import liberty.core.scenegraph.scene: Scene;
import liberty.core.scenegraph.camera: Camera;
import liberty.core.components: Transform;
/// Represents an object in the scene tree.
abstract class Node : Startable, Updatable, Processable {
	private {
		string _id;
		Node _parent;
		Node[string] _children;
		Scene _scene;
		Node[string] _singletonList;
	}
	/// Transform component.
	Transform transform;
	/// Default constructor.
	this(string id, Node parent) {
		transform = Transform(this);
		_scene = CoreEngine.get.activeScene;
		if (id in _scene._ids) {
			assert(0, "You already have an object with ID \"" ~ id ~ "\" in the current scene!");
		}
		_scene._ids[id] = true;
		_id = id;
		_parent = parent;
	}
	/// Returns node ID.
	string id() pure nothrow const {
		return _id;
	}
	/// Returns an array with parent references.
	@property Node parent() pure nothrow {
		return _parent;
	}
	/// Returns an array with children references.
    @property Node[string] children() pure nothrow {
        return _children;
    }
    /// Returns a child reference using its ID.
    @property T child(T)(string id) pure nothrow {
        return cast(T)_children[id];
    }
    ///
    @property Scene scene() pure nothrow {
        return _scene;
    }
	/// Called after all objects instantiation. Optional.
    void start() {}
    /// Called every frame. Optional.
    void update(in float deltaTime) {}
    /// Called every physics tick. Optional.
    void process() {}
    /// Insert a child node using its reference.
    private void insert(T: Node)(ref T child) {
        _children[child.id] = child;
    }
    /// Insert a child node using its id.
    private void insert(float _id) pure nothrow {

    }
    /// Remove a child node using its reference.
    void remove(T: Node)(ref T child) {
        if (child in _children) {
            _children.remove(child.id);
            _scene.startList.remove(child.id);
            _scene.updateList.remove(child.id);
            _scene.processList.remove(child.id);
            _scene.renderList.remove(child.id);
            _scene._ids.remove(child.id);
            static if (is(T == Camera)) {
	            _scene.clearCamera(child);
            }
            child.destroy();
            child = null;
            return;
        }
        //throw new CoreEngineException("CoreEngine tried to remove an nonexistent object!");
    }
    /// Remove a child node using its id.
    void remove(string id) {
        foreach (child; _children) {
            if (child.id == id) {
                _children.remove(child.id);
                _scene.startList.remove(child.id);
                _scene.updateList.remove(child.id);
                _scene.processList.remove(child.id);
                _scene.renderList.remove(child.id);
                _scene._ids.remove(child.id);
                static if (is(T == Camera)) {
	                _scene.clearCamera(child);
                }
                child.destroy();
                child = null;
                return;
            }
        }
        //throw new CoreEngineException("CoreEngine tried to remove an nonexistent object!");
    }
	/// Spawn an object using its reference.
	/// You can specify where to spawn. By default is set to scene tree.
	/// Returns new nodes reference.
	ref T spawn(T: Node)(ref T node, string id, bool start = true) {
		node = new T(id, this);
		insert(node);
		static if (is(T == Camera)) {
			_scene.registerCamera(node);
		}
		if (start) {
			node.start();
		}
		return node;
	}
	/// Spawn an object using its ID.
	/// Second time you call this method for the same id, an assertion is produced.
	/// Returns new node reference.
	T spawn(T: Node)(string id, bool start = true) {
		T node = new T(id, this);
		insert(node);
		static if (is(T == Camera)) {
			_scene.registerCamera(node);
		}
		if (start) {
			node.start();
		}
		return node;
	}
	/// Spawn an object using its reference.
	/// Second time you call this method for the same id, nothing happens.
	/// Returns old/new node reference.
	ref T spawnOnce(T: Node)(ref T node, string id, bool start = true) {
		if (id in _singletonList) {
			return cast(T)_singletonList[id];
		}
		node = new T(id, this);
		insert(node);
		static if (is(T == Camera)) {
			_scene.registerCamera(node);
		}
		_singletonList[id] = node;
		if (start) {
			node.start();
		}
		return node;
	}
	/// Spawn an object using its ID only once.
	/// Second time you call this method for the same id, nothing happens.
	/// Returns old/new node reference.
	T spawnOnce(T: Node)(string id, bool start = true) {
		if (id in _singletonList) {
			return cast(T)_singletonList[id];
		}
		T node = new T(id, this);
		insert(node);
		static if (is(T == Camera)) {
			_scene.registerCamera(node);
		}
		_singletonList[id] = node;
		if (start) {
			node.start();
		}
		return node;
	}
}
/// Root node of a scene. A scene can have only one root node.
final class Root: Node {
	this() {
		super("Root", null);
	}
}
///
//final class Group: Node {
//	this(string id) {
//		super(id, null); // ???????
//	}
//}
