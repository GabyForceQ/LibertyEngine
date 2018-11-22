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

import liberty.core.platform;
import liberty.core.window;
import liberty.math.vector;
import liberty.input.keyboard.impl;
import liberty.input.mouse.impl;
import liberty.input.mouse.picker;
import liberty.input.joystick.impl;
import liberty.input.profiler.impl;

/**
 *
**/
final abstract class Input {
  private {
    static Keyboard keyboard;
    static Mouse mouse;
    static Joystick joystick;
    static MousePicker mousePicker;
    static InputProfiler[string] profilerMap;
  }

  /**
   * Create the implicit mouse picker.
  **/
  static void initialize() {
    keyboard = new Keyboard();
    mouse = new Mouse();
    joystick = new Joystick();
    mousePicker = new MousePicker();
  }

  /**
   * Returns reference to keyboard.
  **/
  static Keyboard getKeyboard() nothrow {
    return keyboard;
  }

  /**
   * Returns reference to mouse.
  **/
  static Mouse getMouse() nothrow {
    return mouse;
  }

  /**
   * Returns reference to joystick.
  **/
  static Joystick getJoystick() nothrow {
    return joystick;
  }

  /**
   * Returns reference to mouse picker.
  **/
  static MousePicker getMousePicker() nothrow {
    return mousePicker;
  }

  /**
   * Returns mouse position in normalized device coordinates.
  **/
  static Vector2F getNormalizedDeviceCoords(Vector2F mousePos = mouse.getPostion(),
    Window window = Platform.getWindow())
  do {
    return Vector2F(
      (2.0f * mousePos.x) / window.getWidth() - 1.0f,
      -((2.0f * mousePos.y) / window.getHeight() - 1.0f)
    );
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

  package(liberty) static void update() {
    keyboard.update();
    mouse.update();
    joystick.update();
  }
}