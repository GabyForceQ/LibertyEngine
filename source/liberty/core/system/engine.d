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
import liberty.core.system.video.renderer : Renderer;
import liberty.core.system.logic : Logic;
import liberty.core.image.manager : ImageManager;
import liberty.core.system.resource.manager : ResourceManager;
import liberty.core.io.manager : IOManager;

/**
 * A failing CoreEngine function should <b>always</b> throw a $(D CoreEngineException).
**/
final class CoreEngineException : Exception {
  mixin(ExceptionConstructor);
}

/**
 *
**/
final class CoreEngine : Singleton!CoreEngine {
  mixin(ManagerBody);

  private {
    EngineState _engineState = EngineState.None;
    Event _event;
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
    Renderer.self.initialize();
    Platform.self.initialize();
    
    changeState(EngineState.Started);
  };

  private static immutable stopBody= q{
    changeState(EngineState.Stopping);
    
    // Deinit engine systems
    Platform.self.deinitialize();
    Renderer.self.deinitialize();

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
    while (_engineState != EngineState.ShouldQuit) {
      _event.pull();
      Logic.self.processTime();
      if (_engineState == EngineState.Running) {
        Logic.self.getViewport().updateScene();
      } else if (_engineState == EngineState.Paused) {
        //Logic.self.runPauseAnimation();
      } else {
        break;
      }
      Renderer.self.render();
    }

    stopService();
  }

  /**
   *
  **/
  void pause() {
    if (_engineState == EngineState.Running) {
      changeState(EngineState.Paused);
    } else {
      Logger.self.warning("Engine is not running", typeof(this).stringof);
    }
  }

  /**
   *
  **/
  void resume() {
    if (_engineState == EngineState.Paused) {
      changeState(EngineState.Running);
    } else {
      Logger.self.warning("Engine is not paused", typeof(this).stringof);
    }
  }

  /**
   *
  **/
  void shutDown() {
    _engineState = EngineState.ShouldQuit;
  }

  /**
   *
  **/
  void forceShutDown(bool failure = false) @trusted {
    import core.stdc.stdlib : exit;
    stopService();
    exit(failure);
  }

  pragma(inline, true)
  private void changeState(EngineState state) {
    _engineState = state;
    Logger.self.info("Engine state changed to " ~ state, typeof(this).stringof);
  }
}