/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/engine.d, _engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.engine;

import liberty.core.utils : Singleton;
import liberty.core.logger.meta : ExceptionConstructor;
import liberty.core.logger.manager : Logger;
import liberty.core.manager.meta : ManagerBody;
import liberty.core.system.platform : Platform;
import liberty.core.system.constants : EngineState;
import liberty.core.system.event : Event;
import liberty.core.image.manager : ImageManager;
import liberty.core.system.resource.manager : ResourceManager;
import liberty.core.system.viewport : Viewport;
import liberty.core.io.manager : IOManager;
import liberty.graphics.engine : GraphicsEngine;

/**
 * A failing CoreEngine function should <b>always</b> throw a $(D CoreEngineException).
**/
final class CoreEngineException : Exception {
  mixin(ExceptionConstructor);
}

/**
 * CoreEngine service used to manage core features like pause and shutdown.
 * Currently supports only one event and only one viewport.
**/
final class CoreEngine : Singleton!CoreEngine {
  mixin(ManagerBody);

  private {
    EngineState engineState = EngineState.None;
    Event event;
    Viewport[string] viewportsMap;
  }

  private static immutable startBody = q{
    // Logger must be the first service to start
    Logger.self.startService();

    changeState(EngineState.Starting);

    // Init extern libraries
    IOManager.self.startService();
    ResourceManager.self.startService();
    ImageManager.self.startService();

    // Init engine systems
    GraphicsEngine.self.startService();
    Platform.self.initialize();

    // Create the viewport
    viewportsMap["Viewport0"] = new Viewport("Viewport0");
    
    changeState(EngineState.Started);
  };

  private static immutable stopBody= q{
    changeState(EngineState.Stopping);
    
    // Deinit engine systems
    Platform.self.deinitialize();
    GraphicsEngine.self.stopService();

    // Deinit extern libraries
    ImageManager.self.stopService();
    ResourceManager.self.stopService();
    IOManager.self.stopService();

    changeState(EngineState.Stopped);
  };

  static ~this() {
    // Logger must be the last service to stop
    Logger.self.stopService();
  }

  /**
   *
  **/
  void run() {
    changeState(EngineState.Running);
    while (this.engineState != EngineState.ShouldQuit) {
      this.event.pull();
      foreach (viewport; this.viewportsMap) {
        viewport.processTime();
      }
      if (this.engineState == EngineState.Running) {
        foreach (viewport; this.viewportsMap) {
          viewport.update();
        }
      } else if (this.engineState == EngineState.Paused) {
        //this.viewport.runPauseAnimation();
      } else {
        break;
      }
      GraphicsEngine.self.render();
    }

    stopService();
  }

  /**
   *
  **/
  void pause() {
    if (this.engineState == EngineState.Running) {
      changeState(EngineState.Paused);
    } else {
      Logger.self.warning("Engine is not running", typeof(this).stringof);
    }
  }

  /**
   *
  **/
  void resume() {
    if (this.engineState == EngineState.Paused) {
      changeState(EngineState.Running);
    } else {
      Logger.self.warning("Engine is not paused", typeof(this).stringof);
    }
  }

  /**
   *
  **/
  void shutDown() {
    this.engineState = EngineState.ShouldQuit;
  }

  /**
   *
  **/
  void forceShutDown(bool failure = false) @trusted {
    import core.stdc.stdlib : exit;
    stopService();
    exit(failure);
  }

  Viewport getViewport() pure nothrow @safe {
    return this.viewportsMap["Viewport0"];
  }

  pragma(inline, true)
  private void changeState(EngineState state) {
    this.engineState = state;
    Logger.self.info("Engine state changed to " ~ state, typeof(this).stringof);
  }
}