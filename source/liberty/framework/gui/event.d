/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/gui/event.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.gui.event;

/**
 *
**/
enum Event : string {
  /**
   *
  **/
  MouseLeftClick = "MouseLeftClick",

  /**
   *
  **/
  MouseMiddleClick = "MouseMiddleClick",

  /**
   *
  **/
  MouseRightClick = "MouseRightClick",

  /**
   *
  **/
  MouseOver = "MouseOver",

  /**
   *
  **/
  MouseMove = "MouseMove",

  /**
   *
  **/
  MouseEnter = "MouseEnter",

  /**
   *
  **/
  MouseLeave = "MouseLeave",

  /**
   *
  **/
  Check = "Check",

  /**
   *
  **/
  Uncheck = "Uncheck",

  /**
   *
  **/
  Checked = "Checked",

  /**
   *
  **/
  Unchecked = "Unchecked",

  /**
   *
  **/
  StateChange = "StateChange",

  /**
   *
  **/
  Update = "Update"
}