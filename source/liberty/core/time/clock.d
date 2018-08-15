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