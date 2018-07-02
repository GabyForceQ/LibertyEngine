/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/time.d, _time.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.time;
import derelict.sdl2.sdl: SDL_GetTicks;
///
uint ticks() {
	return SDL_GetTicks();
}
///
float time() {
	return SDL_GetTicks() / 1000.0f;
}