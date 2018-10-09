/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/platform.d, _platform.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.platform;

import derelict.glfw3.glfw3;

import liberty.core.engine : CoreEngine;
import liberty.core.input.event : Event;
import liberty.core.logger : Logger, InfoMessage;
import liberty.core.window : Window;

/**
 * A platform represents the root system for window manager.
 * Currently it supports only one window.
 * GraphicsEngine service should be initialized before attemping to initialize the platform.
**/
final class Platform {
  private {
    static Window window;
  }

  @disable this();

  /**
   * Initialize current platform.
   * It loads the GLFW library.
   * Application fails if library coudn't be loaded.
  **/
  static void initialize() {
    Logger.info(InfoMessage.Creating, typeof(this).stringof);

    // Load GLFW Library
    try {
      DerelictGLFW3.load();
    } catch (Exception e) {
      Logger.error(
        "Failed to load GLFW library",
        typeof(this).stringof
      );
    }

    if (!glfwInit()) {
      Logger.error("GLFW failed to init", typeof(this).stringof);
      return;
    }

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0);

    // Create main window
    window = new Window(
      2560,
      1440,
      "Liberty Engine v0.0.15-beta.1"
    );

    Event.initialize();

    glfwSetCursorPosCallback(window.getHandle(), &Event.mouseCallback);
		glfwSetScrollCallback(window.getHandle(), &Event.scrollCallback);
    
    glfwSetInputMode(window.getHandle(), GLFW_CURSOR, GLFW_CURSOR_DISABLED);

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