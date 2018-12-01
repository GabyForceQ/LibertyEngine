/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/window.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.window;

import std.string : toStringz;

import bindbc.glfw;

import liberty.core.engine;
import liberty.input.event;
import liberty.logger;

/**
 * It represents an OS window.
**/
final class Window {
  private {
    int width;
    int height;
    GLFWwindow* handle;
    int frameBufferWidth;
    int frameBufferHeight;
    bool fullscreen;
    int lastXStartPos;
    int lastYStartPos;
    int lastXSize;
    int lastYSize;
    // getTitle, setTitle
    string title;
  }

  /**
   * Create a new system window specifying the width, the height and its title.
  **/
  this(int width, int height, string title) {
    // Set window size and title
    this.width = width;
    this.height = height;
    this.title = title;

    Logger.info(InfoMessage.Creating, typeof(this).stringof);

    // Create window internally
    handle = glfwCreateWindow(width, height, title.toStringz, null, null);

    resizeFrameBuffer();
    glfwSetFramebufferSizeCallback(handle, &EventManager.frameBufferResizeCallback);

    // Create the current context
    glfwMakeContextCurrent(handle);

    // Check if window is created
    if (this.handle is null)
      Logger.error("Failed to create window", typeof(this).stringof);

    Logger.info(InfoMessage.Created, typeof(this).stringof);
  }

  ~this() {
    Logger.info(InfoMessage.Destroying, typeof(this).stringof);

    // Destroy the window if not null
    if (handle !is null) {
      glfwTerminate();
      handle = null;
    } else {
      Logger.warning(
        "You are trying to destory a non-existent window",
        typeof(this).stringof
      );
    }

    Logger.info(InfoMessage.Destroyed, typeof(this).stringof);
  }

  /**
   * Returns window width.
  **/
  int getWidth() pure nothrow const {
    return width;
  }

  /**
   * Returns window height.
  **/
  int getHeight() pure nothrow const {
    return height;
  }

  /**
   * Returns handle to this window.
  **/
  GLFWwindow* getHandle() pure nothrow {
    return handle;
  }

  /**
   * Resize the current frame buffer of the window.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) resizeFrameBuffer() {
    glfwGetFramebufferSize(handle, &width, &height);
    return this;
  }

  /**
   * Enter or leave fullscreen mode.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setFullscreen(bool fullscreen) {
    if (fullscreen) {
      // Backup window position and window size
      glfwGetWindowPos(handle, &lastXStartPos, &lastYStartPos);
      glfwGetWindowSize(handle, &lastXSize, &lastYSize);

      // Get resolution of monitor
      const(GLFWvidmode)* mode = glfwGetVideoMode(glfwGetPrimaryMonitor());

      // Switch to fullscreen
      glfwSetWindowMonitor(handle, glfwGetPrimaryMonitor(), 0, 0, mode.width, mode.height, 0);
    } else
      // Restore last window size and position
      glfwSetWindowMonitor(handle, null, lastXStartPos, lastYStartPos, lastXSize, lastYSize, 0);

    // Update vsync state
    if (CoreEngine.isVSyncEnabled())
      CoreEngine.enableVSync();
    else
      CoreEngine.disableVSync();

    this.fullscreen = fullscreen;
    return this;
  }

  /**
   * Swap between window fullscreen and windowed mode.
  **/
  typeof(this) swapFullscreen() {
    return setFullscreen(!fullscreen);
  }

  /**
   * Returns true if window is in fullscreen mode.
  **/
  bool isFullscreen() pure nothrow const {
    return fullscreen;
  }

  /**
   * Returns true if window should close.
  **/
  bool shouldClose() {
    return cast(bool)glfwWindowShouldClose(handle);
  }

  /**
   * Set window title.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setTitle(string title) nothrow {
    this.title = title;
    glfwSetWindowTitle(handle, title.toStringz);
    return this;
  }

  /**
   * Returns window title.
  **/
  string getTitle() pure nothrow const {
    return title;
  }
}
