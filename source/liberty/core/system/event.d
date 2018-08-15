/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/event.d, _event.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.event;

import derelict.sdl2.sdl : 
  SDL_Event,
  SDL_PollEvent,
  SDL_QUIT,
  SDL_MOUSEMOTION;

import liberty.core.system.engine : CoreEngine;
import liberty.core.system.input.manager : Input;

package struct Event {
  private SDL_Event event;

  package void pull() {
    while (SDL_PollEvent(&event)) {
      switch (event.type) {
        case SDL_QUIT:
          CoreEngine.self.shutDown();
          break;

        case SDL_MOUSEMOTION:
          Input.self.updateMousePosition(event.motion.x, event.motion.y);
          break;

        default:
          break;
      }
    }
  }
}