/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/ui/events.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.ui.events;

/**
 *
**/
enum ButtonEvent : ubyte {
  /**
   *
  **/
  MouseLeftClick = 0x00,

  /**
   *
  **/
  MouseMiddleClick = 0x01,

  /**
   *
  **/
  MouseRightClick = 0x02,

  /**
   *
  **/
  MouseInside = 0x03
}