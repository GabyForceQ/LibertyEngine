/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.engine;

import bindbc.opengl;

import liberty.math.vector;
import liberty.core.engine;
import liberty.logger;
import liberty.core.platform;
import liberty.graphics.constants;

import liberty.graphics.backend.impl;

/// Graphics engine base class.
final abstract class GfxEngine {
  ///
  static GfxBackend backend;

  /// Initialize graphics engine by creating the backend.  
  static void initialize() {
    backend = GfxBackend.createBackend();
  }
  
  /// Resize the frame buffer viewport.
  /// If backend is not created then it will generate a warning message.
  static void resizeFrameBufferViewport(int width, int height)  {
    try {
      if (backend !is null) {
        glViewport(0, 0, width, height);
      } else
        Logger.warning(
          "You are trying to resize frame buffer viewport without a backend",
          typeof(this).stringof
        );
    } catch (Exception e) {}
  }

  ///
  debug static void runtimeCheckErr() {
    immutable GLint er = glGetError();

    if (er != GL_NO_ERROR) {
      string getErrorString = getErrorString(er);
      flushErrors;
      Logger.error(getErrorString, typeof(this).stringof);
    }
  }

  ///
  debug static bool runtimeCheckWarn() {
    immutable GLint er = glGetError();
    
    if (er != GL_NO_ERROR) {
      string getErrorString = getErrorString(er);
      flushErrors;
      Logger.warning(getErrorString, typeof(this).stringof);
      return false;
    }

    return true;
  }

  ///
  static const(char)[] getString(uint name) {
    import std.string : fromStringz;
    
    const(char)* sZ = glGetString(name);
    debug runtimeCheckErr;
    
    return (sZ is null) ? "(unknown)" : sZ.fromStringz;
  }

  ///
  static const(char)[] getString(uint name, uint index) {
    import std.string : fromStringz;

    const(char)* sZ = glGetStringi(name, index);
    debug runtimeCheckErr;

    return (sZ is null) ? "(unknown)" : sZ.fromStringz;
  }

  ///
  static const(char)[] getVersionString() {
    return getString(GL_VERSION);
  }

  ///
  static const(char)[] getVendorString() {
    return getString(GL_VENDOR);
  }

  ///
  static GfxVendor getVendor() {
    import std.algorithm.searching : canFind;
    
    const(char)[] s = getVendorString();
    if (canFind(s, "AMD"))
      return GfxVendor.AMD;
    else if (canFind(s, "NVIDIA"))
      return GfxVendor.NVIDIA;
    else if (canFind(s, "Intel"))
      return GfxVendor.INTEL;

    return GfxVendor.UNKNOWN;
  }

  ///
  static const(char)[] getRendererString() {
    return getString(GL_RENDERER);
  }

  ///
  static const(char)[] getShadingVersionString() {
    return getString(GL_SHADING_LANGUAGE_VERSION);
  }

  ///
  static int getInt(uint pname) {
    GLint param;
    glGetIntegerv(pname, &param);
    debug runtimeCheckErr;
    return param;
  }

  ///
  static float getFloat(uint pname) {
    GLfloat res;
    glGetFloatv(pname, &res);
    debug runtimeCheckErr;
    return res;
  }

  private static string getErrorString(int er)  {
    switch (er) {
      case GL_NO_ERROR: return "GL_NO_ERROR";
      case GL_INVALID_ENUM: return "GL_INVALID_ENUM";
      case GL_INVALID_VALUE: return "GL_INVALID_VALUE";
      case GL_INVALID_OPERATION: return "GL_INVALID_OPERATION";
      case GL_OUT_OF_MEMORY: return "GL_OUT_OF_MEMORY";
      default: return "Unknown OpenGL error";
    }
  }

  private static void flushErrors()  {
    int timeout;
    while (++timeout <= 5) {
      immutable r = glGetError();
      if (r == GL_NO_ERROR)
        break;
    }
  }
}