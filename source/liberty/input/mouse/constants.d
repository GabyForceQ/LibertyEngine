/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/mouse/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.mouse.constants;

import bindbc.glfw;

/**
 *
**/
enum byte MOUSE_BUTTONS = 3;

/**
 *
**/
struct MouseAxis {}

/**
 *
**/
enum MouseAction : ubyte {
  /**
   *
  **/
  NONE,
  
  /**
   *
  **/
  DOWN,
  
  /**
   *
  **/
  UP,
  
  /**
   *
  **/
  HOLD
}

/**
 *
**/
enum MouseButton : byte {
  /**
   *
  **/
  LEFT = GLFW_MOUSE_BUTTON_1,
  
  /**
   *
  **/
  RIGHT = GLFW_MOUSE_BUTTON_2,
  
  /**
   *
  **/
  MIDDLE = GLFW_MOUSE_BUTTON_3
}

/**
 *
**/
enum CursorType : int {
  /**
   *
  **/
  NORMAL = GLFW_CURSOR_NORMAL,
  
  /**
   *
  **/
  HIDDEN = GLFW_CURSOR_HIDDEN,
  
  /**
   *
  **/
  DISABLED = GLFW_CURSOR_DISABLED
}