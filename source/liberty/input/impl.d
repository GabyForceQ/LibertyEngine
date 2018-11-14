/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.impl;

import bindbc.glfw;

import liberty.math.vector : Vector2F;
import liberty.input.constants :
  KeyCode, MouseButton, CursorType,
  KEY_CODES, MOUSE_BUTTONS;
import liberty.input.picker : MousePicker;
import liberty.core.platform : Platform;
import liberty.core.window : Window;

/**
 *
**/
final class Input {
  private {
    static bool[KEY_CODES] keyState;
    static bool[KEY_CODES] mouseBtnState;
    static Vector2F mousePosition;
    static Vector2F previousMousePosition;
    static Vector2F lastMousePosition;
    static CursorType cursorType;
    static MousePicker mousePicker;
  }

  @disable this();

  package(liberty) static void update() {
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
   * Returns a 2d vector containing previous mouse position.
  **/
  static Vector2F getPreviousMousePostion() nothrow {
    return previousMousePosition;
  }

  /**
   * Returns a 2d vector containing last mouse position.
  **/
  static Vector2F getLastMousePostion() nothrow {
    return lastMousePosition;
  }

  /**
   * Returns true if mouse cursor is moving left.
  **/
  static bool isMouseMovingLeft() nothrow {
    return lastMousePosition.x > mousePosition.x;
  }

  /**
   * Returns true if mouse cursor is moving right.
  **/
  static bool isMouseMovingRight() nothrow {
    return lastMousePosition.x < mousePosition.x;
  }

  /**
   * Returns true if mouse cursor is moving up.
  **/
  static bool isMouseMovingUp() nothrow {
    return lastMousePosition.y > mousePosition.y;
  }

  /**
   * Returns true if mouse cursor is moving down.
  **/
  static bool isMouseMovingDown() nothrow {
    return lastMousePosition.y < mousePosition.y;
  }

  /**
   * Returns true if mouse cursor is moving.
  **/
  static bool isMouseMoving() nothrow {
    return lastMousePosition != mousePosition;
  }

  /**
   * Returns true if mouse cursor is staying.
  **/
  static bool isMouseStaying() nothrow {
    return lastMousePosition == mousePosition;
  }

  /**
   * Returns true if mouse cursor was moving left.
  **/
  static bool wasMouseMovingLeft() nothrow {
    return previousMousePosition.x > mousePosition.x;
  }

  /**
   * Returns true if mouse cursor was moving right.
  **/
  static bool wasMouseMovingRight() nothrow {
    return previousMousePosition.x < mousePosition.x;
  }

  /**
   * Returns true if mouse cursor was moving up.
  **/
  static bool wasMouseMovingUp() nothrow {
    return previousMousePosition.y > mousePosition.y;
  }

  /**
   * Returns true if mouse cursor was moving down.
  **/
  static bool wasMouseMovingDown() nothrow {
    return previousMousePosition.y < mousePosition.y;
  }

  /**
   * Returns a reference to current mouse picker.
  **/
  static MousePicker getMousePicker() nothrow {
    return mousePicker;
  }

  /**
   * Set current cursor type.
   * For available options see $(D CursorType).
  **/
  static void setCursorType(CursorType cursorType, Window window = Platform.getWindow()) {
    glfwSetInputMode(window.getHandle(), GLFW_CURSOR, cursorType);
    this.cursorType = cursorType;
  }

  /**
   * Returns the type of the cursor.
   * For available returned values see $(D CursorType).
  **/
  static CursorType getCursorType() nothrow {
    return cursorType;
  }

  /**
   * Returns mouse position in normalized device coordinates.
  **/
  static Vector2F getNormalizedDeviceCoords(Vector2F mousePos = getMousePostion(), Window window = Platform.getWindow()) {
    return Vector2F(
      (2.0f * mousePos.x) / window.getWidth() - 1.0f,
      -((2.0f * mousePos.y) / window.getHeight() - 1.0f)
    );
  }

  static package void setMousePosition(Vector2F position) nothrow {
    mousePosition = position;
  }

  static package void setPreviousMousePostion(Vector2F position) nothrow {
    previousMousePosition = position;
  }

  static package void setLastMousePosition(Vector2F position) nothrow {
    lastMousePosition = position;
  }
}