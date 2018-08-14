// TODO: Calculate FPS, Calculate AVG_FPS

module liberty.core.system.logic;

import liberty.core.utils : Singleton;
import liberty.core.logger.meta : ExceptionConstructor;
import liberty.core.time.clock : Clock;

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

        Scene _activeScene;
    }

    /**
     *
    **/
    float deltaTime() pure nothrow const @safe @nogc @property {
        return _deltaTime;
    }

    /**
     *
    **/
    float lastFrameTime() pure nothrow const @safe @nogc @property {
        return _lastFrameTime;
    }

    /**
     *
    **/
    float elapsedTime() pure nothrow const @safe @nogc @property {
        return _elapsedTime;
    }

    /**
     *
    **/
    //float framesPerSecond() pure nothrow const @safe @nogc @property {
    //    return _framesPerSecond;
    //}

    package void processTime() {
        // Process time
        _elapsedTime = Clock.self.time();
        _deltaTime = _elapsedTime - _lastFrameTime;
        _lastFrameTime = _elapsedTime;
    }

    package void updateScene() {
        // Update scene using processed time
        _activeScene.update(_deltaTime);
    }

    /**
     *
    **/
    void loadScene(Scene scene) {
        _activeScene = scene;
    }

    /**
     *
    **/
    Scene activeScene() {
        return _activeScene;
    }

}