/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/keyboard/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.keyboard.impl;

import bindbc.glfw;

import liberty.core.platform;
import liberty.input.keyboard.constants;

/**
 *
**/
final class Keyboard {
  private {
    bool[KEYBOARD_BUTTONS] buttonsState;
  }

  /**
   * Returns true if keyboard button was just pressed in an event loop.
  **/
  bool isButtonDown(KeyboardButton button)  {
    return isButtonHold(button) && !buttonsState[button];
  }

  /**
   * Returns true if keyboard button was just released in an event loop.
  **/
  bool isButtonUp(KeyboardButton button)  {
    return !isButtonHold(button) && buttonsState[button];
  }

  /**
   * Returns true if keyboard button is still pressed in an event loop.
   * Use case: player movement.
  **/
  bool isButtonHold(KeyboardButton button)  {
    return glfwGetKey(Platform.getWindow().getHandle(), button) == GLFW_PRESS;
  }

  /**
   * Returns true if keyboard button is still pressed in an event loop after a while since pressed.
   * Strongly recommended for text input.
  **/
  bool isButtonRepeat(KeyboardButton button)  {
    return glfwGetKey(Platform.getWindow().getHandle(), button) == GLFW_REPEAT;
  }

  /**
   * Returns true if keyboard button has no input action in an event loop.
  **/
  bool isButtonNone(KeyboardButton button)  {
    return glfwGetKey(Platform.getWindow().getHandle(), button) == GLFW_RELEASE;
  }

  /**
   *
  **/
  bool isUnfolding(KeyboardButton button, KeyboardAction action)  {
    final switch (action) with (KeyboardAction) {
      case NONE:
        return isButtonNone(button);
      case DOWN:
        return isButtonDown(button);
      case UP:
        return isButtonUp(button);
      case HOLD:
        return isButtonHold(button);
      case REPEAT:
        return isButtonRepeat(button);
    }
  }

  package(liberty.input) void update()  {
    static foreach (i; 0..KEYBOARD_BUTTONS)
      buttonsState[i] = isButtonHold(cast(KeyboardButton)i);
  }
}