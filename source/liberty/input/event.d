/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/input/event.d)
 * Documentation:
 * Coverage:
**/
module liberty.input.event;

import bindbc.glfw;

import liberty.math.vector;
import liberty.core.engine;
import liberty.input.keyboard.constants;
import liberty.input.mouse.constants;
import liberty.input.impl;
import liberty.core.platform;
import liberty.graphics.engine;

package(liberty) class EventManager {
  private {
    static bool firstMouse = true;
    static float lastX;
    static float lastY;
  }

  static void initialize() {
    lastX = Platform.getWindow().getHeight() / 2.0f;
    lastY = Platform.getWindow().getWidth() / 2.0f;
  }

  extern (C) static void mouseCallback(GLFWwindow* window, double xPos, double yPos) nothrow {
    try {
      if (firstMouse) {
        lastX = xPos;
        lastY = yPos;
        firstMouse = false;
      }

      const xOffset = xPos - lastX;
      const yOffset = lastY - yPos;

      Input
        .getMouse()
        .setPreviousPostion(Vector2F(lastX, lastY))
        .setPosition(Vector2F(xPos, yPos));

      lastX = xPos;
      lastY = yPos;

      CoreEngine.scene.camera.processMouseMovement(xOffset, yOffset);
    } catch (Exception e) {}
  }

  extern (C) static void joystickCallback(int joy, int event) nothrow {
    try {
      if (event == GLFW_CONNECTED) {
        Input
          .getJoystick()
          .setConnected(true)
          .processButtons();
      } else if (event == GLFW_DISCONNECTED)
        Input
          .getJoystick()
          .setConnected(false);
      }
    catch (Exception e) {}
  }

  extern (C) static void scrollCallback(GLFWwindow* window, double xOffset, double yOffset) nothrow {
    try {
      CoreEngine.scene.camera.processMouseScroll(yOffset);
    } catch (Exception e) {}
  }

  extern (C) static void frameBufferResizeCallback(GLFWwindow* window, int width, int height) nothrow {
    try {
      GfxEngine.resizeFrameBufferViewport(width, height);
    } catch (Exception e) {}
  }

  static void updateLastMousePosition() {
    Input
      .getMouse()
      .setLastPosition(Vector2F(lastX, lastY));
  }
}
