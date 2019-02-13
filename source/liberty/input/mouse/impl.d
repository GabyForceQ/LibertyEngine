/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/mouse/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.mouse.impl;

import bindbc.glfw;

import liberty.core.platform;
import liberty.core.window;
import liberty.math.vector;
import liberty.input.mouse.constants;

/**
 *
**/
final class Mouse {
  private {
    bool[MOUSE_BUTTONS] buttonsState;
    Vector2F position;
    Vector2F previousPosition;
    Vector2F lastPosition;
    CursorType cursorType;
  }

  /**
   * Returns true if mouse button was just pressed in an event loop.
  **/
  bool isButtonDown(MouseButton button)  {
    return isButtonHold(button) && !buttonsState[button];
  }

  /**
   * Returns true if mouse button was just released in an event loop.
  **/
  bool isButtonUp(MouseButton button)  {
    return !isButtonHold(button) && buttonsState[button];
  }

  /**
   * Returns true if mouse button is still pressed in an event loop.
   * Use case: shooting something.
  **/
  bool isButtonHold(MouseButton button)  {
    return glfwGetMouseButton(Platform.getWindow().getHandle(), button) == GLFW_PRESS;
  }

  /**
   * Returns true if mouse button has no input action in an event loop.
  **/
  bool isButtonNone(MouseButton button)  {
    return glfwGetMouseButton(Platform.getWindow().getHandle(), button) == GLFW_RELEASE;
  }

  /**
   *
  **/
  bool isUnfolding(MouseButton button, MouseAction action)  {
    final switch (action) with (MouseAction) {
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
   * Returns a 2d vector containing mouse position in the current window.
   * You can choose what window to test with the given argument.
  **/
  Vector2F getPostion(Window window = Platform.getWindow())  {
    double x, y;
    glfwGetCursorPos(window.getHandle(), &x, &y);
    return Vector2F(cast(float)x, cast(float)y);
  }
  
  /**
   * Returns a 2d vector containing previous mouse position.
  **/
  Vector2F getPreviousPostion()   {
    return previousPosition;
  }

  /**
   * Returns a 2d vector containing last mouse position.
  **/
  Vector2F getLastPostion()   {
    return lastPosition;
  }

  /**
   * Returns true if mouse cursor is moving left.
  **/
  bool isMovingLeft()   const {
    return lastPosition.x > position.x;
  }

  /**
   * Returns true if mouse cursor is moving right.
  **/
  bool isMovingRight()   const {
    return lastPosition.x < position.x;
  }

  /**
   * Returns true if mouse cursor is moving up.
  **/
  bool isMovingUp()   const {
    return lastPosition.y > position.y;
  }

  /**
   * Returns true if mouse cursor is moving down.
  **/
  bool isMovingDown()   const {
    return lastPosition.y < position.y;
  }

  /**
   * Returns true if mouse cursor is moving.
  **/
  bool isMoving()   const {
    return lastPosition != position;
  }

  /**
   * Returns true if mouse cursor is staying.
  **/
  bool isStaying()   const {
    return lastPosition == position;
  }

  /**
   * Returns true if mouse cursor was moving left.
  **/
  bool wasMovingLeft()   const {
    return previousPosition.x > position.x;
  }

  /**
   * Returns true if mouse cursor was moving right.
  **/
  bool wasMovingRight()   const {
    return previousPosition.x < position.x;
  }

  /**
   * Returns true if mouse cursor was moving up.
  **/
  bool wasMovingUp()   const {
    return previousPosition.y > position.y;
  }

  /**
   * Returns true if mouse cursor was moving down.
  **/
  bool wasMovingDown()   const {
    return previousPosition.y < position.y;
  }

  /**
   * Set current cursor type.
   * For available options see $(D CursorType).
  **/
  void setCursorType(CursorType cursorType, Window window = Platform.getWindow())  {
    glfwSetInputMode(window.getHandle(), GLFW_CURSOR, cursorType);
    this.cursorType = cursorType;
  }

  /**
   * Returns the type of the cursor.
   * For available returned values see $(D CursorType).
  **/
  CursorType getCursorType()   {
    return cursorType;
  }

  package(liberty.input) void update()  {
    static foreach (i; 0..MOUSE_BUTTONS)
      buttonsState[i] = isButtonHold(cast(MouseButton)i);
  }

  package(liberty.input) Mouse setPosition(Vector2F position)   {
    this.position = position;
    return this;
  }

  package(liberty.input) Mouse setPreviousPostion(Vector2F position)   {
    previousPosition = position;
    return this;
  }

  package(liberty.input) Mouse setLastPosition(Vector2F position)   {
    lastPosition = position;
    return this;
  }
}