/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/physics/engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.physics.engine;

/**
 *
**/
final class PxEngine {
  private {
    static bool running = true;
  }

  /**
   *
  **/
  static bool isRunning()  {
    return running;
  }

  /**
   * Pause the Physics Engine.
  **/
  static void pause() {
    running = false;
  }

  /**
   * Resume the Physics Engine.
  **/
  static void resume() {
    running = true;
  }
}