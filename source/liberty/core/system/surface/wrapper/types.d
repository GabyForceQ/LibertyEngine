module liberty.core.system.surface.wrapper.types;

import derelict.sdl2.sdl :
  SDL_Surface, SDL_PixelFormat, SDL_Rect, SDL_FALSE;

/**
 * Pointer to SDL2 Surface.
**/
alias SurfaceHandler = SDL_Surface*;

/**
 *
**/
alias PixelFormat = SDL_PixelFormat*;

/**
 *
**/
alias Rect = SDL_Rect;

/**
 *
**/
alias SurfaceSuccess = SDL_FALSE;