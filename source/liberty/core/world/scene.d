/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/world/scene.d, _scene.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.world.scene;
import liberty.core.engine : CoreEngine;
import liberty.core.world.services : IStartable, IUpdatable, IProcessable;
import liberty.core.world.node : Node, Root;
import liberty.core.world.camera : Camera;
import liberty.core.logger : Logger, WarningMessage, InfoMessage;
import liberty.core.utils : Singleton;
import liberty.graphics.engine : IRenderable;
import liberty.math.vector : Vector3F;
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
///
final class SceneSerializer : Singleton!SceneSerializer {
    private {
        bool _serviceRunning;
        immutable {
            string _ext = ".lyscn";
            string _arr = " >> ";
            string _inf = ": ";
            string _nxt = ", ";
            string _str = `"`;
            string _end = "\r\n"; // TODO. Check OS version
        }
        enum PropTkn : string {
            id = "id"
        }
    }
    /// Start SceneSerializer service.
    void startService() @trusted {
        if (_serviceRunning) {
            Logger.get.warning(WarningMessage.ServiceAlreadyRunning, this);
        } else {
            _serviceRunning = true;
            Logger.get.info(InfoMessage.ServiceStarted, this);
        }
    }
    /// Stop SceneSerializer service.
    void stopService() @trusted {
        if (_serviceRunning) {
            _serviceRunning = false;
            Logger.get.info(InfoMessage.ServiceStopped, this);
        } else {
            Logger.get.warning(WarningMessage.ServiceNotRunning, this);
        }
    }
    /// Restart SceneSerializer service.
    void restartService() @trusted {
        stopService();
        startService();
    }
    /// Returns true if FontManager service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
    ///
    void serialize(Scene scene) {
        if (_serviceRunning) {
            import std.stdio : File;
            import std.conv : to;
            auto file = new File(scene.id.to!string ~ _ext, "w");
            scope (exit) file.close();
            // TODO. Parse children too
            //foreach (node; scene.tree) {
            //    file.writeln(node.stringof ~ _arr ~ PropTkn.id ~ _inf ~ _str ~ node.id.to!string ~ _str);
                // TODO. foreach all node members searching for other props including construction default values
            //    file.write(_end);
            //}
        } else {
            Logger.get.warning(WarningMessage.ServiceNotRunning, this);
        }
    }
    ///
    Scene deserialize(string path) {
        if (_serviceRunning) {
            import std.stdio : File;
            import std.conv : to;
            import std.array : split;
            string id = path.split('/')[$ - 1]; // TODO. Check if it has at least one /
            auto file = new File(path ~ _ext, "r");
            scope (exit) file.close();
            // TODO. Read file
            auto scene = new Scene(id);
            return scene;
        } else {
            Logger.get.warning(WarningMessage.ServiceNotRunning, this);
            Logger.get.warning(WarningMessage.NullReturn, this);
            return null;
        }
    }
}