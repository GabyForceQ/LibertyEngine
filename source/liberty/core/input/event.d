/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/input/event.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.input.event;

import bindbc.glfw;

import liberty.core.math.vector : Vector2F;
import liberty.core.engine : CoreEngine, EngineState;
import liberty.core.input.constants : KeyCode, MouseButton;
import liberty.core.input.impl : Input;
import liberty.core.platform : Platform;
import liberty.graphics.engine : GfxEngine;

package(liberty.core) class Event {
  private {
    static bool firstMouse = true;
	  static float lastX;
	  static float lastY;
  }

  static void initialize() {
    lastX = Platform.getWindow().getHeight() / 2.0f;
    lastY = Platform.getWindow().getWidth() / 2.0f;
  }

  extern(C) static void mouseCallback(GLFWwindow* window, double xPos, double yPos) nothrow {
    if (firstMouse) {
      lastX = xPos;
      lastY = yPos;
      firstMouse = false;
    }

    float xOffset = xPos - lastX;
    float yOffset = lastY - yPos;

    Input.setPreviousMousePostion(Vector2F(lastX, lastY));
    Input.setMousePosition(Vector2F(xPos, yPos));

    lastX = xPos;
    lastY = yPos;

    try {
      CoreEngine.getScene().getActiveCamera().processMouseMovement(xOffset, yOffset);
    } catch (Exception e) {}
  }

  extern(C) static void scrollCallback(GLFWwindow* window, double xOffset, double yOffset) nothrow {
    try {
      CoreEngine.getScene().getActiveCamera().processMouseScroll(yOffset);
    } catch (Exception e) {}
  }

  extern(C) static void frameBufferResizeCallback(GLFWwindow* window, int width, int height) nothrow {
    GfxEngine.resizeFrameBufferViewport(width, height);
  }

  static void updateLastMousePosition() {
    Input.setLastMousePosition(Vector2F(lastX, lastY));
  }
}