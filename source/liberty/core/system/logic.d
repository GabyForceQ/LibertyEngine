// TODO: Calculate FPS, Calculate AVG_FPS

module liberty.core.system.logic;

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

  package void processTime() {
    // Process time
    _elapsedTime = Clock.self.getTime();
    _deltaTime = _elapsedTime - _lastFrameTime;
    _lastFrameTime = _elapsedTime;
  }
}