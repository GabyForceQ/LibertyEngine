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

import liberty.audio.backend;
import liberty.audio.buffer.factory;
import liberty.material.impl;
import liberty.input.impl;
import liberty.logger;
import liberty.camera;
import liberty.core.platform;
import liberty.scene;
import liberty.time;
import liberty.input.event;
import liberty.graphics.engine;
import liberty.graphics.buffer.factory;

/**
 * Core engine class containing engine base static functions.
**/
final abstract class CoreEngine {
  private {
    static EngineState engineState = EngineState.None;
    static bool vsync;
  }

  ///
  static Scene scene;

  /**
   * Initialize core engine features.
  **/
  static void initialize() {
    Logger.initialize;
    
    // Set engine state to "starting"
    changeState(EngineState.Starting);

    // Initialize other classes    
    Platform.initialize;
    AudioBackend.initialize;
    GfxEngine.initialize;
    Input.initialize;

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
    Platform.deinitialize;
    IGfxBufferFactory.release;
    IAudioBufferFactory.release;

    // Set engine state to "stopped"
    changeState(EngineState.Stopped);

    Logger.deinitialize;
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
          scene.update;
          scene.camera.preset.runImplicitProcess(scene.camera);

          //Input
          //  .getMousePicker()
          //  .update(scene.camera(), scene.getTree().getChild!Terrain("DemoTerrain"));

          break;
        case Paused:
          break; // TODO.
        default:
          Logger.warning("Unreachable.", typeof(this).stringof);
          break;
      }

      // Clear the screen
      GfxEngine.backend.clearScreen;
      
      // Render to the screen
      CoreEngine.scene.render;
      
      glfwSwapBuffers(Platform.getWindow.getHandle);

      if (Platform.getWindow.shouldClose)
        changeState(EngineState.ShouldQuit);

      EventManager.updateLastMousePosition;
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
  static bool isVSyncEnabled()  {
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
  mixin template EngineRun() {}
else
  /**
   *
  **/
  mixin template EngineRun(alias startFun, alias endFun) {
    int main() {
      CoreEngine.initialize();
      startFun();
      CoreEngine.run();
      endFun();
      return 0;
    }
  }

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
