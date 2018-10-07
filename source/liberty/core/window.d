/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/window.d, _window.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.window;

import derelict.glfw3.glfw3;

import liberty.core.input.event : Event;
import liberty.core.logger : Logger, InfoMessage;

/**
 *
**/
final class Window {
	private {
		int width;
		int height;
    GLFWwindow* windowHandle;
    uint id;
    bool surfaceNeedRenew;
		int frameBufferWidth;
		int frameBufferHeight;
	}

	/**
	 *
	**/
	this(int width, int height, string title) {
		// Set window size
		this.width = width;
		this.height = height;

		Logger.info(InfoMessage.Creating, typeof(this).stringof);
    
		// Create window internally
    windowHandle = glfwCreateWindow(
      width,
      height,
      "Liberty Engine v0.0.15-beta.1",
      null,
      null
    );

		resizeFrameBuffer();
		glfwSetFramebufferSizeCallback(windowHandle, &Event.frameBufferResizeCallback);

		// Create the current context
    glfwMakeContextCurrent(windowHandle);

		// Check if window is created
    if (this.windowHandle is null)
      Logger.error(
        "Failed to create window", 
        typeof(this).stringof
      );

		Logger.info(InfoMessage.Created, typeof(this).stringof);

		// Store the window id
    this.id = this.getWindowId();
	}

	~this() {
		Logger.info(InfoMessage.Destroying, typeof(this).stringof);

		// Destroy the window if not null
		if (this.windowHandle !is null) {
      glfwTerminate();
      this.windowHandle = null;
    } else {
      Logger.warning(
        "You are trying to destory a non-existent window",
        typeof(this).stringof
      );
    }

		Logger.info(InfoMessage.Destroyed, typeof(this).stringof);
	}

	/**
	 *
	**/
	int getWidth() pure nothrow const {
		return width;
	}

	/**
	 *
	**/
	int getHeight() pure nothrow const {
		return height;
	}

  /**
   *
  **/
  GLFWwindow* getHandle() pure nothrow {
    return windowHandle;
  }

  /**
	 *
	**/ 
	uint getWindowId() pure nothrow const {
    return id;
  }

	/**
	 *
	**/
	int getFrameBufferWidth() pure nothrow const {
		return frameBufferWidth;
	}

	/**
	 *
	**/
	int getFrameBufferHeight() pure nothrow const {
		return frameBufferHeight;
	}

	/**
	 *
	**/
	void resizeFrameBuffer() {
		glfwGetFramebufferSize(windowHandle, &frameBufferWidth, &frameBufferHeight);
	}
}