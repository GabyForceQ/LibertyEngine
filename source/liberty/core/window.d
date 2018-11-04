/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/window.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.window;

import bindbc.glfw;

import liberty.core.engine : CoreEngine;
import liberty.input.event : Event;
import liberty.logger : Logger, InfoMessage;

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
	}

	/**
	 * Create a new system window specifying the width, the height and its title.
	**/
	this(int width, int height, string title) {
		// Set window size
		this.width = width;
		this.height = height;

		Logger.info(InfoMessage.Creating, typeof(this).stringof);
    
		// Create window internally
    handle = glfwCreateWindow(width, height, cast(const(char)*)title, null, null);

		resizeFrameBuffer();
		glfwSetFramebufferSizeCallback(handle, &Event.frameBufferResizeCallback);

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
	 * Returns frame buffer width.
	**/
	int getFrameBufferWidth() pure nothrow const {
		return frameBufferWidth;
	}

	/**
	 * Returns frame buffer height.
	**/
	int getFrameBufferHeight() pure nothrow const {
		return frameBufferHeight;
	}

	/**
	 * Resize the current frame buffer of the window.
	 * Returns reference to this.
	**/
	Window resizeFrameBuffer() {
		glfwGetFramebufferSize(handle, &frameBufferWidth, &frameBufferHeight);
		return this;
	}

	/**
	 * Enter or leave fullscreen mode.
	 * Returns reference to this.
	**/
	Window setFullscreen(bool fullscreen) {
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
	 * Toggle window fullscreen/windowed mode.
	**/
	Window toggleFullscreen() {
		return setFullscreen(!fullscreen);
	}

	/**
	 * Returns true if window is in fullscreen mode.
	**/
	bool isFullscreen() pure nothrow const {
		return fullscreen;
	}
}