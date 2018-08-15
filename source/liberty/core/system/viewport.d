module liberty.core.system.viewport;

import liberty.core.system.logic : Logic;
import liberty.mvc.scene.controller : SceneController;

/**
 *
**/
final class Viewport {
  private {
    Logic _logic;
    SceneController _activeScene;
  }

  /**
   *
  **/
  this(Logic logic) {
    _logic = logic;
  }

  /**
   *
  **/
  void loadScene(SceneController scene) pure nothrow @safe {
    _activeScene = scene;
  }

  /**
   *
  **/
  SceneController getActiveScene() pure nothrow @safe {
    return _activeScene;
  }

  package void updateScene() {
    _activeScene.update(_logic.getDeltaTime());
  }
}