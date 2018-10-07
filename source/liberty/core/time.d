/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/time.d, _time.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.time;

import derelict.glfw3.glfw3 : glfwGetTime;

import std.conv : to;

pragma(inline, true) :

/**
 *
**/
static class Time {
  private {
    static float delta = 0.0f;
    static float lastFrame = 0.0f;
    static float elapsed = 0.0f;
  }

  /**
	 *
	**/
	static float getTime() nothrow {
		return glfwGetTime();
	}

  /**
   * Returns delta time.
  **/
  static float getDelta() nothrow {
    return delta;
  }

  /**
   * Returns delta time as string.
  **/
  static string getDeltaStr() {
    return delta.to!string;
  }

  /**
   * Returns last frame time.
  **/
  static float getLastFrame() nothrow {
    return lastFrame;
  }

  /**
   * Returns last frame time as string.
  **/
  static string getLastFrame() {
    return lastFrame.to!string;
  }

  /**
   * Returns elapsed time.
  **/
  static float getElapsed() nothrow {
    return elapsed;
  }

  /**
   * Returns elapsed time as string.
  **/
  static string getElapsed() {
    return elapsed.to!string;
  }

  // Time should be porcessed every single frame
  package static void processTime() nothrow {
    elapsed = getTime();
    delta = elapsed - lastFrame;
    lastFrame = elapsed;
  }
}