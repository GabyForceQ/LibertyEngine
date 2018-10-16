/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/input/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.input.impl;

import derelict.glfw3.glfw3;

import liberty.core.math.vector : Vector2F;
import liberty.core.input.constants : KeyCode, MouseButton, KEY_CODES, MOUSE_BUTTONS;
import liberty.core.input.picker : MousePicker;
import liberty.core.platform : Platform;
import liberty.core.window : Window;

/**
 *
**/
final class Input {
  private {
    static bool[KEY_CODES] keyState;
    static bool[KEY_CODES] mouseBtnState;
    static MousePicker mousePicker;
  }

  @disable this();

  package(liberty.core) static void update() {
    static foreach (i; 0..KEY_CODES)
      keyState[i] = isKeyHold(cast(KeyCode)i);
    
    static foreach (i; 0..MOUSE_BUTTONS)
      mouseBtnState[i] = isMouseButtonHold(cast(MouseButton)i);
  }

  /**
   * Create the implicit mouse picker.
  **/
  static void initialize() {
    mousePicker = new MousePicker();
  }

  /**
   * Returns true if key was just pressed in an event loop.
  **/
  static bool isKeyDown(KeyCode key) {
    return isKeyHold(key) && !keyState[key];
  }

  /**
   * Returns true if key was just released in an event loop.
  **/
  static bool isKeyUp(KeyCode key) {
    return !isKeyHold(key) && keyState[key];
  }

  /**
   * Returns true if key is still pressed in an event loop.
   * Use case: player movement.
  **/
  static bool isKeyHold(KeyCode key) {
    return glfwGetKey(Platform.getWindow().getHandle(), key) == GLFW_PRESS;
  }

  /**
   * Returns true if key is still pressed in an event loop after a while since pressed.
   * Strongly recommended for text input.
  **/
  static bool isKeyRepeat(KeyCode key) {
    return glfwGetKey(Platform.getWindow().getHandle(), key) == GLFW_REPEAT;
  }

  /**
   * Returns true if key has no input action in an event loop.
  **/
  static bool isKeyNone(KeyCode key) {
    return glfwGetKey(Platform.getWindow().getHandle(), key) == GLFW_RELEASE;
  }

  /**
   * Returns true if mouse button was just pressed in an event loop.
  **/
  static bool isMouseButtonDown(MouseButton btn) {
    return isMouseButtonHold(btn) && !mouseBtnState[btn];
  }

  /**
   * Returns true if mouse button was just released in an event loop.
  **/
  static bool isMouseButtonUp(MouseButton btn) {
    return !isMouseButtonHold(btn) && mouseBtnState[btn];
  }

  /**
   * Returns true if mouse button is still pressed in an event loop.
   * Use case: shooting something.
  **/
  static bool isMouseButtonHold(MouseButton btn) {
    return glfwGetMouseButton(Platform.getWindow().getHandle(), btn) == GLFW_PRESS;
  }

  /**
   * Returns true if mouse button has no input action in an event loop.
  **/
  static bool isMouseButtonNone(MouseButton btn) {
    return glfwGetMouseButton(Platform.getWindow().getHandle(), btn) == GLFW_RELEASE;
  }

  /**
   * Returns a 2d vector containing mouse position in the current window.
   * You can choose what window to test with the given argument.
  **/
  static Vector2F getMousePostion(Window window = Platform.getWindow()) nothrow {
    double x, y;
    glfwGetCursorPos(window.getHandle(), &x, &y);
    return Vector2F(cast(float)x, cast(float)y);
  }

  /**
   * Returns a reference to current mouse picker.
  **/
  static MousePicker getMousePicker() nothrow {
    return mousePicker;
  }
}