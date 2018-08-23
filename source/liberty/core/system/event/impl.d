/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/event/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.event.impl;

//
import derelict.sdl2.sdl;
import liberty.core.system;
import liberty.core.math.vector;

import liberty.core.system.engine : CoreEngine;
import liberty.core.system.input.manager : Input;

package(liberty.core.system) struct Event {
  private {
    InternalEvent internalEvent;
  }

  void pull() {
    while (EventUtil.self.pollEvent(internalEvent)) {
      switch (internalEvent.type) with (EventType) {
        case Quit:
          CoreEngine.self.shutDown();
          break;

        case MouseMotion:
          Input.self.updateMousePosition(
            internalEvent.motion.x, 
            internalEvent.motion.y
          );
          break;

        case MouseButtonDown:
          Input.self.pressKey(internalEvent.button.button);
          break;

        case MouseButtonUp:
          Input.self.releaseKey(internalEvent.button.button);
          break;

        case KeyDown:
          Input.self.pressKey(internalEvent.key.keysym.sym);
          break;
          
        case KeyUp:
          Input.self.releaseKey(internalEvent.key.keysym.sym);
          break;

        default:
          break;
      }
    }
  }
}