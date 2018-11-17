/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/profiler/data.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.profiler.data;

import liberty.input.joystick;
import liberty.input.keyboard;
import liberty.input.mouse;

/**
 *
**/
struct InputAction(DEVICE) {
  static if (is(DEVICE == Keyboard)) {
    /**
     *
    **/
    alias DeviceButton = KeyboardButton;
    /**
     *
    **/
    alias DeviceAction = KeyboardAction;
  } else static if (is(DEVICE == Mouse)) {
    /**
     *
    **/
    alias DeviceButton = MouseButton;
    /**
     *
    **/
    alias DeviceAction = MouseAction;
  } else static if (is(DEVICE == Joystick)) {
    /**
     *
    **/
    alias DeviceButton = JoystickButton;
    /**
     *
    **/
    alias DeviceAction = JoystickAction;
  } else
    static assert (0, "Device not supported.");

  /**
   *
  **/
  DeviceButton button;

  /**
   *
  **/
  DeviceAction action;

  /**
   *
  **/
  this(DeviceButton button, DeviceAction action) {
    this.button = button;
    this.action = action;
  }
}

/**
 *
**/
struct InputAxis(DEVICE) {
  static if (is(DEVICE == Keyboard))
    /**
     *
    **/
    alias DeviceAxis = KeyboardAxis;
  else static if (is(DEVICE == Mouse))
    /**
     *
    **/
    alias DeviceAxis = MouseAxis;
  else static if (is(DEVICE == Joystick))
    /**
     *
    **/
    alias DeviceAxis = JoystickAxis;
  else
    static assert (0, "Device not supported.");

  /**
   *
  **/
  DeviceAxis axis;
  
  /**
   *
  **/
  float scale;

  /**
   *
  **/
  this(DeviceAxis axis, float scale) {
    this.axis = axis;
    this.scale = scale;
  }
}