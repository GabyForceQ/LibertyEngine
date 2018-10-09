/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/engine.d, _engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.engine;

import derelict.glfw3.glfw3;

import liberty.core.logger : Logger;
import liberty.core.platform : Platform;
import liberty.core.time : Time;
import liberty.graphics.engine : GfxEngine;
import liberty.core.objects.camera : CameraMovement;
import liberty.core.scene : Scene;
import liberty.core.image.manager : ImageManager;
import liberty.core.resource.manager : ResourceManager;
import liberty.core.input;

pragma(inline, true) :

/**
 * Core engine class containing engine base static functions.
**/
final class CoreEngine {
  private {
    static EngineState engineState = EngineState.None;
		static Scene scene;
  }

	@disable this();

  /**
   * Initialize core engine features.
  **/
  static void initialize() {
    // Set engine state to "starting"
		changeState(EngineState.Starting);

		// Initialize other classes
		ImageManager.initialize();
		ResourceManager.initialize();
		GfxEngine.initialize();
		Platform.initialize();
		GfxEngine.reloadFeatures();

    // Set engine state to "started"
		changeState(EngineState.Started);
  }

  /**
   * Deinitialize core engine features.
  **/
  static void deinitialize() {
    // Set engine state to "stopping"
    changeState(EngineState.Stopping);

		// Deinitialize other classes
		Platform.deinitialize();
		ResourceManager.releaseAllModels();

    // Set engine state to "stopped"
    changeState(EngineState.Stopped);
  }

  /**
   * Start the main loop of the application.
  **/
  pragma(inline, false)
	static void run() {
		// Set engine state to "running"
		changeState(EngineState.Running);

    // Main loop
		while (engineState != EngineState.ShouldQuit) {
			// Process time
			Time.processTime();

			Input.update();

			// Pull events
			glfwPollEvents();
			Platform.getWindow().resizeFrameBuffer();

			//Input.update();

			if (engineState == EngineState.Running) {
				scene.update();
			} else if (this.engineState == EngineState.Paused) {
        
      } else {
        break;
      }
			
			GfxEngine.render();

      scene.getActiveCamera().getPreset().runImplicit();

      if (Input.isKeyDown(KeyCode.T))
				glfwSetInputMode(Platform.getWindow().getHandle(), GLFW_CURSOR, GLFW_CURSOR_NORMAL);
			if (Input.isKeyDown(KeyCode.Y))
				glfwSetInputMode(Platform.getWindow().getHandle(), GLFW_CURSOR, GLFW_CURSOR_DISABLED);

			if (Input.isKeyDown(KeyCode.ESC))
				changeState(EngineState.ShouldQuit);
		}

    // Main loop ended so engine shutdowns
		deinitialize();
	}

  /**
   * Pause the entire application.
  **/
  static void pause() {
    if (this.engineState == EngineState.Running) {
      changeState(EngineState.Paused);
    } else {
      Logger.warning("Engine is not running", typeof(this).stringof);
    }
  }

  /**
   * Resume the entire application.
  **/
  static void resume() {
    if (this.engineState == EngineState.Paused) {
      changeState(EngineState.Running);
    } else {
      Logger.warning("Engine is not paused", typeof(this).stringof);
    }
  }

	/**
	 * Shutdown the entire application.
	**/
	static void shutDown() {
		engineState = EngineState.ShouldQuit;
	}

	/**
   * Force shutdown the entire application.
  **/
  static void forceShutDown(bool failure = false) {
    import core.stdc.stdlib : exit;
    deinitialize();
    exit(failure);
  }

	/**
	 * Load a new scene into the window viewport.
	**/
	static void loadScene(Scene scene) nothrow {
		this.scene = scene;
	}

	/**
	 * Returns: current scene.
	**/
	static Scene getScene() nothrow {
		return scene;
	}

	package static void changeState(EngineState engineState) {
		this.engineState = engineState;
		Logger.info("Engine state changed to " ~ engineState, typeof(this).stringof);
	}
}

version (unittest)
  /**
   *
  **/
  immutable EngineRun = q{};
else
  /**
   *
  **/
  immutable EngineRun = q{
    int main() {
      CoreEngine.initialize();
      libertyMain();
      CoreEngine.run();
      return 0;
    }
  };

/**
 * Engine state enumeration.
**/
enum EngineState : string {
	/**
	 * Engine is totally inactive.
	**/
	None = "None",

	/**
	 * Engine is starting.
	**/
	Starting = "Starting",

	/**
	 * Engine just started.
	**/
	Started = "Started",

	/**
	 * Engine is stopping.
	**/
	Stopping = "Stopping",

	/**
	 * Engine just stopped.
	**/
	Stopped = "Stopped",

	/**
	 * Engine is running.
	**/
	Running = "Running",

	/**
	 * Engine is paused.
	**/
	Paused = "Paused",

	/**
	 * Engine is in process of quiting.
	**/
	ShouldQuit = "ShouldQuit"
}