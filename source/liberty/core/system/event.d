module liberty.core.system.event;

import derelict.sdl2.sdl : 
  SDL_Event, SDL_PollEvent,
  SDL_QUIT, SDL_MOUSEMOTION;

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