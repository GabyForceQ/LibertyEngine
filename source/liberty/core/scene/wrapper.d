/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/scene/wrapper.d, _wrapper.d)
 * Documentation:
 * Coverage:
 */
 // TODO. Define onApply so you can iterate over children.
module liberty.core.scene.wrapper;

import liberty.core.engine : CoreEngine;
import liberty.core.scene.services : IStartable, IUpdatable, IProcessable;
import liberty.core.scene.node : Node, Root;
import liberty.core.scene.camera : Camera;
import liberty.core.logger : Logger, WarningMessage, InfoMessage;
import liberty.core.utils : Singleton;
import liberty.graphics.engine : IRenderable;
import liberty.core.math.vector : Vector3F;
///
struct SceneSettings {
	///
	Vector3F startPoint;
}
///
final class Scene : IUpdatable, IProcessable, IRenderable {
	public {
	    ///
        IStartable[string] startList;
	    ///
        IUpdatable[string] updateList;
	    ///
        IProcessable[string] processList;
	    ///
        IRenderable[string] renderList;
	    ///
        static IRenderable[string] shaderList;
	}
    package {
        bool[string] _ids;
    }
    private {
        string _id;
        SceneSettings _settings;
        Node _tree;
        Camera _activeCamera;
        Camera[string] _cameras;
        bool _registered;
    }
    /// Default contrctor.
    this(string id) {
        CoreEngine.get.activeScene = this;
        _tree = new Root();
        _id = id;
    }
    /// Returns scene ID.
    string id() pure nothrow const {
        return _id;
    }
    /// Returns if scene is ready to run.
    bool isRegistered() pure nothrow const {
        return _registered;
    }
    /// Returns scene settings.
    ref const(SceneSettings) settings() pure nothrow const {
        return _settings;
    }
    /// Returns a scene tree reference.
    Node tree() pure nothrow {
        return _tree;
    }
    ///
    //T node(T: Node)(string id) {
    //    return cast(T)_nodeList[id];
    //}
    ///
    //Node node(string id) {
    //    return _nodeList[id];
    //}
    /// Releases all scene tree nodes.
    void resetTree() {
        _tree = new Root();
    }
    /// Sets the current camera using its reference.
    void activeCamera(Camera camera) {
        _activeCamera = camera;
    }
    /// Sets the current camera using its ID.
	void activeCamera(string id) {
	    //_activeCamera = node!Camera(id);
	}
	/// Returns the current camera.
	Camera activeCamera() {
	    return _activeCamera;
	}
	/// Change view from a camera to another using their references.
	void toggleBetweenCameras(Camera camera1, Camera camera2) {
        if (_activeCamera.id == camera1.id) {
            _activeCamera = camera2;
        } else {
            _activeCamera = camera1;
        }
    }
	/// Change view from a camera to another using their IDs.
	void toggleBetweenCameras(string id1, string id2) {
	    if (_activeCamera.id == id1) {
	        _activeCamera = _cameras[id2];
	    } else {
	        _activeCamera = _cameras[id1];
	    }
	}
	///
	package void registerCamera(Camera camera) {
		_cameras[camera.id] = camera;
	}
	///
	package void clearCamera(Camera camera) {
		_cameras.remove(camera.id);
		//camera.destroy();
		//camera = null;
	}
	/// Register scene to the CoreEngine.
	/// Invoke start for all IStartable objects that have an start() method.
	void register() {
		_registered = true;
		foreach (node; startList) {
			node.start();
		}
		if (_activeCamera is null) {
			_activeCamera = tree.spawn!Camera("DefaultCamera");
		}
	}
	/// Updates all IUpdatable objects that have an update() method.
	/// It's called every frame.
	void update(in float deltaTime) {
        foreach (node; updateList) {
            node.update(deltaTime);
        }
    }
    /// Process all IProcessable objects that have a process() method.
    /// It's synchronized with PhysicsCoreEngine.
    void process() {
        foreach (node; processList) {
            node.process();
        }
    }
    /// Render all IRenderable objects that have a render() method.
    void render() {
        foreach (shader; shaderList) {
            shader.render();
        }
        foreach(node; renderList) {
            node.render();
        }
    }
}
