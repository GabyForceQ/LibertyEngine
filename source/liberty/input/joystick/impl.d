/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/joystick/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.joystick.impl;

import bindbc.glfw;

import liberty.core.platform;
import liberty.input.joystick.constants;

/**
 *
**/
final class Joystick {
  private {
    bool connected;
    bool[JOYSTICK_BUTTONS] buttonsState;
    ubyte* pButtons;
  }

  /**
   *
  **/
  this() {
    const int present1 = glfwJoystickPresent(JoystickNumber.NO_1);
    if (present1)
      connected = true;

    processButtons();
  }

  /**
   * Returns true if joystick button was just pressed in an event loop.
  **/
  bool isButtonDown(JoystickButton button) {
    return isButtonHold(button) && !buttonsState[button];
  }

  /**
   * Returns true if joystick button was just released in an event loop.
  **/
  bool isButtonUp(JoystickButton button) {
    return !isButtonHold(button) && buttonsState[button];
  }

  /**
   * Returns true if joystick button is still pressed in an event loop.
   * Use case: shooting something.
  **/
  bool isButtonHold(return JoystickButton button) {
    return connected ? pButtons[button] == GLFW_PRESS : false;
  }

  /**
   * Returns true if joystick button has no input action in an event loop.
  **/
  bool isButtonNone(JoystickButton button) {
    return connected ? pButtons[button] == GLFW_RELEASE : false;
  }

  /**
   *
  **/
  bool isUnfolding(JoystickButton button, JoystickAction action) {
    final switch (action) with (JoystickAction) {
      case NONE:
        return isButtonNone(button);
      case DOWN:
        return isButtonDown(button);
      case UP:
        return isButtonUp(button);
      case HOLD:
        return isButtonHold(button);
    }
  }

  /**
   * Returns true if joystick is connected.
  **/
  bool isConnected() nothrow {
    return connected;
  }

  package(liberty.input) void update() {
    if (connected)
      static foreach (i; 0..JOYSTICK_BUTTONS)
        buttonsState[i] = isButtonHold(cast(JoystickButton)i);
  
    processButtons();
  }

  package(liberty.input) Joystick processButtons() nothrow {
    int count;
    pButtons = glfwGetJoystickButtons(JoystickNumber.NO_1, &count);
    return this;
  }

  package(liberty.input) Joystick setConnected(bool value) nothrow {
    connected = value;
    return this;
  }
}