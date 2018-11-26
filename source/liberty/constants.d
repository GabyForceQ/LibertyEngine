/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.constants;

/**
 * Visibility state for an element.
**/
enum Visibility : byte {
  /**
   * The element is rendering.
   * Its physics is processing.
  **/
  Visible = 0x00,

  /**
   * The element is not rendering.
   * Its physics is processing.
  **/
  Hidden = 0x01,

  /**
   * The element is not rendering.
   * Its physics is not processing.
  **/
  Collapsed = 0x02
}