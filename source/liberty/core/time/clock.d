/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/time/clock.d, _clock.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.time.clock;

import derelict.sdl2.sdl : SDL_GetTicks;
import liberty.core.utils : Singleton;

/**
 *
**/
class Clock : Singleton!Clock {
	/**
	 *
	**/
	uint getTicks() {
		return SDL_GetTicks();
	}

	/**
	 *
	**/
	float getTime() {
		return SDL_GetTicks() / 1000.0f;
	}
}

/**
 *
**/
class Time : Singleton!Time {
  private {
    float delta = 0.0f;
    float lastFrame = 0.0f;
    float elapsed = 0.0f;
  }

  /**
   * Returns the delta time.
  **/
  float getDelta() pure nothrow const @safe {
    return this.delta;
  }

  /**
   * Returns the last frame time.
  **/
  float getLastFrame() pure nothrow const @safe {
    return this.lastFrame;
  }

  /**
   * Returns the elapsed time.
  **/
  float getElapsed() pure nothrow const @safe {
    return this.elapsed;
  }

  /**
   * Time porcessed every single frame.
  **/
  void processTime() {
    this.elapsed = Clock.self.getTime();
    this.delta = this.elapsed - this.lastFrame;
    this.lastFrame = this.elapsed;
  }
}