/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/logic.d, _logic.d)
 * Documentation:
 * Coverage:
 * Todo: 
 *    Calculate FPS, Calculate AVG_FPS
**/
module liberty.core.system.logic;

//
import liberty.world.components.sprite;

import liberty.core.utils : Singleton;
import liberty.core.logger.meta : ExceptionConstructor;
import liberty.core.time.clock : Clock;
import liberty.core.system.viewport : Viewport;

/**
 * A failing Logic function should <b>always</b> throw a $(D LogicException).
**/
final class LogicException : Exception {
  mixin(ExceptionConstructor);
}

/**
 *
**/
final class Logic : Singleton!Logic {
  private {
    float _deltaTime = 0.0f;
    float _lastFrameTime = 0.0f;
    float _elapsedTime = 0.0f;
    //float _framesPerSecond = 0.0f;
    Viewport _viewport;

    //
    Camera2D _camera = new Camera2D();
  }

  /**
   *
  **/
  this() {
    _viewport = new Viewport(this);
  }

  /**
   *
  **/
  float getDeltaTime() pure nothrow const @safe {
    return _deltaTime;
  }

  /**
   *
  **/
  float getLastFrameTime() pure nothrow const @safe {
    return _lastFrameTime;
  }

  /**
   *
  **/
  float getElapsedTime() pure nothrow const @safe {
    return _elapsedTime;
  }

  /**
   *
  **/
  //float getFramesPerSecond() pure nothrow const @safe {
  //  return _framesPerSecond;
  //}

  /**
   *
  **/
  Viewport getViewport() pure nothrow @safe {
    return _viewport;
  }

  /**
   *
  **/
  Camera2D getCamera() {
    return _camera;
  }

  package void processTime() {
    // Process time
    _elapsedTime = Clock.self.getTime();
    _deltaTime = _elapsedTime - _lastFrameTime;
    _lastFrameTime = _elapsedTime;

    //
    _camera.update();
  }
}