/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.engine;

import bindbc.glfw;

import liberty.graphics.material.impl;
import liberty.image.manager;
import liberty.input.constants;
import liberty.input.impl;
import liberty.logger;
import liberty.camera;
import liberty.core.platform;
import liberty.resource;
import liberty.scene;
import liberty.time;
import liberty.input.event;
import liberty.graphics.engine;

/**
 * Core engine class containing engine base static functions.
**/
final class CoreEngine {
  private {
    static EngineState engineState = EngineState.None;
		static Scene scene;
		static bool vsync;
  }

	@disable this();

  /**
   * Initialize core engine features.
  **/
  static void initialize() {
    Logger.initialize();
    
    // Set engine state to "starting"
		changeState(EngineState.Starting);

		// Initialize other classes    
		ImageManager.initialize();
		ResourceManager.initialize();
		GfxEngine.initialize();
		Platform.initialize();
		GfxEngine.reloadFeatures();
    Material.initializeMaterials();
		Input.initialize();

    disableVSync();

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

    Logger.deinitialize();
  }

  /**
   * Start the main loop of the application.
  **/
	static void run() {
		// Set engine state to "running"
		changeState(EngineState.Running);

    // Main loop
		while (engineState != EngineState.ShouldQuit) {
			// Process time
			Time.processTime();

			// Update input and pull events
			Input.update();
			glfwPollEvents();
			Platform.getWindow().resizeFrameBuffer();

			switch (engineState) with (EngineState) {
				case Running:
					import liberty.terrain;
					

					scene.update();
					scene.getActiveCamera()
						.getPreset()
						.runImplicit(scene.getActiveCamera());

          //Input.getMousePicker()
					//	.update(scene.getActiveCamera(), scene.getTree().getChild!Terrain("DemoTerrain"));

					
					/*static int oo = 0;
					if (oo == 200) {
						import liberty.core.engine;
						Logger.exception(Input.getMousePicker().getCurrentRay().toString());
						Logger.exception(Input.getMousePicker().getCurrentTerrainPoint().toString());
						oo = 0;
					}
					oo++;*/

					break;
				case Paused:
					break; // TODO.
				default:
					Logger.warning("Unreachable.", typeof(this).stringof);
					break;
			}

			// Render to the screen
			GfxEngine.clearScreen();
			CoreEngine.getScene().render();
			glfwSwapBuffers(Platform.getWindow().getHandle());

			if (Platform.getWindow().shouldClose())
				changeState(EngineState.ShouldQuit);

      Event.updateLastMousePosition();
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
	 * Returns current scene.
	**/
	static Scene getScene() nothrow {
		return scene;
	}

	/**
   *
  **/
  static void enableVSync() {
    glfwSwapInterval(1);
		vsync = true;
  }

  /**
   *
  **/
  static void disableVSync() {
    glfwSwapInterval(0);
		vsync = false;
  }

	/**
	 *
	**/
	static bool isVSyncEnabled() nothrow {
		return vsync;
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