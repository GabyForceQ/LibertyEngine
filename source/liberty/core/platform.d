/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/platform.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.platform;

import bindbc.glfw;

import liberty.core.engine;
import liberty.input.event;
import liberty.logger;
import liberty.core.window;

/**
 * A platform represents the root system for window manager.
 * Currently it supports only one window.
 * GraphicsEngine service should be initialized before attemping to initialize the platform.
**/
final abstract class Platform {
  private {
    static Window window;
  }

  /**
   * Initialize current platform.
   * It loads the GLFW library.
   * Application fails if library coudn't be loaded.
  **/
  static void initialize() {
    Logger.info(InfoMessage.Creating, typeof(this).stringof);

    // Load GLFW Library
    const res = loadGLFW();
    if (res != glfwSupport) {
      if (res == GLFWSupport.noLibrary)
        Logger.error("No GLFW library", typeof(this).stringof);
      else if (res == glfwSupport.badLibrary)
        Logger.error("Bad GLFW library", typeof(this).stringof);
    }

    if (!glfwInit()) {
      Logger.error("GLFW failed to init", typeof(this).stringof);
      return;
    }

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 5);

    // Create main window
    window = new Window(
      1280,
      720,
      "Liberty Engine v0.0.16-alpha.dev"
    );

    EventManager.initialize();

    glfwSetCursorPosCallback(window.getHandle(), &EventManager.mouseCallback);
		glfwSetScrollCallback(window.getHandle(), &EventManager.scrollCallback);
    glfwSetJoystickCallback(&EventManager.joystickCallback);

    Logger.info(InfoMessage.Created, typeof(this).stringof);
  }

  /**
   * Deinitialize current platform.
  **/
  static void deinitialize() {
    Logger.info(InfoMessage.Destroying, typeof(this).stringof);
    
    // Check if window exists before destroying it
    if (window !is null) {
      window.destroy();
      window = null;
    }

    Logger.info(InfoMessage.Destroyed, typeof(this).stringof);
  }

  /**
   * Get current platform window.
  **/
  static Window getWindow() nothrow {
    return window;
  }
}