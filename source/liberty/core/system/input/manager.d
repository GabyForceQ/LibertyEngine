/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/input/manager.d, _manager.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.input.manager;

import liberty.core.utils : Singleton;
import liberty.core.system.input.mouse : MouseBody;
import liberty.core.manager : ManagerBody;

pragma (inline, true):

/**
 *
**/
final class Input : Singleton!Input {
  mixin(ManagerBody);
  mixin(MouseBody);
}