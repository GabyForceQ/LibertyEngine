/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/viewport.d, _viewport.d)
 * Documentation:
 * Coverage:
**/
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