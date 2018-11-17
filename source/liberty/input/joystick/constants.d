/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/joystick/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.joystick.constants;

import bindbc.glfw;

/**
 *
**/
enum byte JOYSTICK_BUTTONS = 14;

/**
 *
**/
struct JoystickAxis {}

/**
 *
**/
enum JoystickAction : byte {
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
enum JoystickButton : byte {
  /**
   *
  **/
  A = 0x00,
  
  /**
   *
  **/
  B = 0x01,
  
  /**
   *
  **/
  X = 0x02,
  
  /**
   *
  **/
  Y = 0x03,
  
  /**
   *
  **/
  LB = 0x04,
  
  /**
   *
  **/
  RB = 0x05,
  
  /**
   *
  **/
  BACK = 0x06,
  
  /**
   *
  **/
  START = 0x07,
  
  /**
   *
  **/
  LAXIS = 0x08,
  
  /**
   *
  **/
  RAXIS = 0x09,
  
  /**
   *
  **/
  PAD_UP = 0x0A,
  
  /**
   *
  **/
  PAD_RIGHT = 0x0B,
  
  /**
   *
  **/
  PAD_DOWN = 0x0C,
  
  /**
   *
  **/
  PAD_LEFT = 0x0D
}

/**
 *
**/
enum JoystickNumber : byte {
  /**
   *
  **/
  NO_1 = GLFW_JOYSTICK_1,
  
  /**
   *
  **/
  NO_2 = GLFW_JOYSTICK_2,
  
  /**
   *
  **/
  NO_3 = GLFW_JOYSTICK_3,
  
  /**
   *
  **/
  NO_4 = GLFW_JOYSTICK_4,
  
  /**
   *
  **/
  NO_5 = GLFW_JOYSTICK_5,
  
  /**
   *
  **/
  NO_6 = GLFW_JOYSTICK_6,
  
  /**
   *
  **/
  NO_7 = GLFW_JOYSTICK_7,
  
  /**
   *
  **/
  NO_8 = GLFW_JOYSTICK_8,
  
  /**
   *
  **/
  NO_9 = GLFW_JOYSTICK_9,
  
  /**
   *
  **/
  NO_10 = GLFW_JOYSTICK_10,
  
  /**
   *
  **/
  NO_11 = GLFW_JOYSTICK_11,
  
  /**
   *
  **/
  NO_12 = GLFW_JOYSTICK_12,
  
  /**
   *
  **/
  NO_13 = GLFW_JOYSTICK_13,
  
  /**
   *
  **/
  NO_14 = GLFW_JOYSTICK_14,
  
  /**
   *
  **/
  NO_15 = GLFW_JOYSTICK_15,
  
  /**
   *
  **/
  NO_16 = GLFW_JOYSTICK_16
}