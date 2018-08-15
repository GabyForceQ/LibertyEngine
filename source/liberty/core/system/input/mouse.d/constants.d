/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/input/mouse/constants.d, _constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.input.mouse.constants;

import derelict.sdl2.sdl :
  SDL_BUTTON_LEFT,
  SDL_BUTTON_MIDDLE,
  SDL_BUTTON_RIGHT,
  SDL_BUTTON_X1,
  SDL_BUTTON_X2,
  SDL_BUTTON_LMASK,
  SDL_BUTTON_MMASK,
  SDL_BUTTON_RMASK,
  SDL_BUTTON_X1MASK,
  SDL_BUTTON_X2MASK;

/**
 *
**/
enum MouseButton : ubyte {
  /**
   *
  **/
	Left = SDL_BUTTON_LEFT,

  /**
   *
  **/
	Middle = SDL_BUTTON_MIDDLE,

  /**
   *
  **/
	Right = SDL_BUTTON_RIGHT,

  /**
   *
  **/
	X1 = SDL_BUTTON_X1,

  /**
   *
  **/
	X2 = SDL_BUTTON_X2,

  /**
   *
  **/
	LeftMask = SDL_BUTTON_LMASK,

  /**
   *
  **/
	MiddleMask = SDL_BUTTON_MMASK,

  /**
   *
  **/
	RightMask = SDL_BUTTON_RMASK,

  /**
   *
  **/
	X1Mask = SDL_BUTTON_X1MASK,

  /**
   *
  **/
	X2Mask = SDL_BUTTON_X2MASK
}