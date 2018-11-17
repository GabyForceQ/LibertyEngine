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

import liberty.math.vector;
import liberty.input.joystick.constants;
import liberty.input.keyboard.constants;
import liberty.input.mouse.constants;
import liberty.input.picker;
import liberty.input.profiler;
import liberty.core.platform;
import liberty.core.window;

/**
 *
**/
final class Input {
  private {
    static bool joystickConnected;
    static bool[KEYBOARD_BUTTONS] keyState;
    static bool[MOUSE_BUTTONS] mouseBtnState;
    static bool[JOYSTICK_BUTTONS] joystickBtnState;
    static Vector2F mousePosition;
    static Vector2F previousMousePosition;
    static Vector2F lastMousePosition;
    static CursorType cursorType;
    static MousePicker mousePicker;
    static ubyte* joystickButtons;
    static InputProfiler[string] profilerMap;
  }

  @disable this();

  package(liberty) static void update() {
    static foreach (i; 0..KEYBOARD_BUTTONS)
      keyState[i] = isKeyHold(cast(KeyboardButton)i);
    
    static foreach (i; 0..MOUSE_BUTTONS)
      mouseBtnState[i] = isMouseButtonHold(cast(MouseButton)i);
    
    if (joystickConnected)
      static foreach (i; 0..JOYSTICK_BUTTONS)
        joystickBtnState[i] = isJoystickButtonHold(cast(JoystickButton)i);
  
    processJoystickButtons();
  }

  /**
   * Create the implicit mouse picker.
  **/
  static void initialize() {
    mousePicker = new MousePicker();
    
    const int present1 = glfwJoystickPresent(JoystickNumber.NO_1);
    if (present1)
      joystickConnected = true;

    processJoystickButtons();
  }

  /**
   *
  **/
  static bool isKeyboardAction(KeyboardButton key, KeyboardAction action) {
    final switch (action) with (KeyboardAction) {
      case NONE:
        return isKeyNone(key);
      case DOWN:
        return isKeyDown(key);
      case UP:
        return isKeyUp(key);
      case HOLD:
        return isKeyHold(key);
      case REPEAT:
        return isKeyRepeat(key);
    }
  }

  /**
   *
  **/
  static bool isJoystickAction(JoystickButton button, JoystickAction action) {
    final switch (action) with (JoystickAction) {
      case NONE:
        return isJoystickButtonNone(button);
      case DOWN:
        return isJoystickButtonDown(button);
      case UP:
        return isJoystickButtonUp(button);
      case HOLD:
        return isJoystickButtonHold(button);
    }
  }

  /**
   *
  **/
  static bool isMouseAction(MouseButton button, MouseAction action) {
    final switch (action) with (MouseAction) {
      case NONE:
        return isMouseButtonNone(button);
      case DOWN:
        return isMouseButtonDown(button);
      case UP:
        return isMouseButtonUp(button);
      case HOLD:
        return isMouseButtonHold(button);
    }
  }

  /**
   * Returns true if key was just pressed in an event loop.
  **/
  static bool isKeyDown(KeyboardButton key) {
    return isKeyHold(key) && !keyState[key];
  }

  /**
   * Returns true if key was just released in an event loop.
  **/
  static bool isKeyUp(KeyboardButton key) {
    return !isKeyHold(key) && keyState[key];
  }

  /**
   * Returns true if key is still pressed in an event loop.
   * Use case: player movement.
  **/
  static bool isKeyHold(KeyboardButton key) {
    return glfwGetKey(Platform.getWindow().getHandle(), key) == GLFW_PRESS;
  }

  /**
   * Returns true if key is still pressed in an event loop after a while since pressed.
   * Strongly recommended for text input.
  **/
  static bool isKeyRepeat(KeyboardButton key) {
    return glfwGetKey(Platform.getWindow().getHandle(), key) == GLFW_REPEAT;
  }

  /**
   * Returns true if key has no input action in an event loop.
  **/
  static bool isKeyNone(KeyboardButton key) {
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
   * Returns true if joystick button was just pressed in an event loop.
  **/
  static bool isJoystickButtonDown(JoystickButton btn) {
    return isJoystickButtonHold(btn) && !joystickBtnState[btn];
  }

  /**
   * Returns true if joystick button was just released in an event loop.
  **/
  static bool isJoystickButtonUp(JoystickButton btn) {
    return !isJoystickButtonHold(btn) && joystickBtnState[btn];
  }

  /**
   * Returns true if joystick button is still pressed in an event loop.
   * Use case: shooting something.
  **/
  static bool isJoystickButtonHold(return JoystickButton btn) {
    return joystickConnected ? joystickButtons[btn] == GLFW_PRESS : false;
  }

  /**
   * Returns true if joystick button has no input action in an event loop.
  **/
  static bool isJoystickButtonNone(JoystickButton btn) {
    return joystickConnected ? joystickButtons[btn] == GLFW_RELEASE : false;
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
  static Vector2F getNormalizedDeviceCoords(Vector2F mousePos = getMousePostion(),
    Window window = Platform.getWindow())
  do {
    return Vector2F(
      (2.0f * mousePos.x) / window.getWidth() - 1.0f,
      -((2.0f * mousePos.y) / window.getHeight() - 1.0f)
    );
  }

  /**
   * Returns true if joystick is connected.
  **/
  static bool isJoystickConnected() nothrow {
    return joystickConnected;
  }

  /**
   *
  **/
  static InputProfiler createProfile(string id) nothrow {
    profilerMap[id] = new InputProfiler(id);
    return profilerMap[id];
  }

  /**
   *
  **/
  static void removeProfile(string id) nothrow {
    profilerMap.remove(id);
  }

  /**
   *
  **/
  static InputProfiler getProfile(string id) nothrow {
    return profilerMap[id];
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

  static package void setJoystickConnected(bool value) nothrow {
    joystickConnected = value;
  }

  static package void processJoystickButtons() nothrow {
    int count;
    joystickButtons = glfwGetJoystickButtons(JoystickNumber.NO_1, &count);
  }
}