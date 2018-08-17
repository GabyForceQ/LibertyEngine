/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/event/wrapper/util.d, _util.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.event.wrapper.util;

import derelict.sdl2.sdl :
  SDL_Event,
  SDL_PollEvent;

import liberty.core.system;

import liberty.core.utils.singleton : Singleton;
import liberty.core.logger.manager : Logger;

pragma (inline, true) :

/**
 *
**/
final class EventUtil : Singleton!EventUtil {
  /**
   *
  **/
  bool pollEvent(
    ref InternalEvent internalEvent
  ) @trusted {
    return cast(bool)SDL_PollEvent(&internalEvent);
  }
}