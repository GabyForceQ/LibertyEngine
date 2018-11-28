/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.engine;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.math.vector;
import liberty.core.engine;
import liberty.logger;
import liberty.core.platform;
import liberty.graphics.constants;

import liberty.graphics.backend.impl;

/**
 * Graphics engine base class.
**/
final abstract class GfxEngine {
  private {
    static GfxBackend backend;
  }

  /**
   * Initialize graphics engine by creating the backend.
  **/
  static void initialize() {
    backend = GfxBackend.createBackend();
  }

  /**
   * Returns graphics backend.
  **/
  static GfxBackend getBackend() nothrow {
    return backend;
  }

  /**
   * Resize the frame buffer viewport.
   * If backend is not created then it will generate a warning message.
  **/
  static void resizeFrameBufferViewport(int width, int height) nothrow {
    try {
      if (backend !is null) {
        version (__OPENGL__)
          glViewport(0, 0, width, height);
      } else
        Logger.warning(
          "You are trying to resize frame buffer viewport without a backend",
          typeof(this).stringof
        );
    } catch (Exception e) {}
  }

  /**
   *
  **/
  static void enableAlphaBlend() {
    version (__OPENGL__) {
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }
  }

  /**
   *
  **/
  static void disableBlend() {
    version (__OPENGL__)
      glDisable(GL_BLEND);
  }

  /**
   *
  **/
  static bool supportsExtension(string extension) nothrow {
    foreach (el; backend.getInfo().extensions)
      if (el == extension)
        return true;
    return false;
  }

  /**
   *
  **/
  debug static void runtimeCheckErr() {
    version (__OPENGL__) {
      immutable GLint er = glGetError();
      if (er != GL_NO_ERROR) {
        string getErrorString = getErrorString(er);
        flushErrors();
        Logger.error(getErrorString, typeof(this).stringof);
      }
    }
  }

  /**
   *
  **/
  debug static bool runtimeCheckWarn() {
    version (__OPENGL__) {
      immutable GLint er = glGetError();
      if (er != GL_NO_ERROR) {
        string getErrorString = getErrorString(er);
        flushErrors();
        Logger.warning(getErrorString, typeof(this).stringof);
        return false;
      }
      return true;
    }
    else
      return true;
  }

  static const(char)[] getString(uint name) {
    import std.string : fromStringz;
    
    version (__OPENGL__)
      const(char)* sZ = glGetString(name);
    else
      const(char)* sZ = "";
    
    debug runtimeCheckErr();
    
    if (sZ is null)
      return "(unknown)";
    else
      return sZ.fromStringz;
  }

  static const(char)[] getString(uint name, uint index) {
    import std.string : fromStringz;

    version (__OPENGL__)
      const(char)* sZ = glGetStringi(name, index);
    else
      const(char)* sZ = "";
    
    debug runtimeCheckErr();
    
    if (sZ is null)
      return "(unknown)";
    else
      return sZ.fromStringz;
  }

  static const(char)[] getVersionString() {
    version (__OPENGL__)
      return getString(GL_VERSION);
    else
      return "";
  }

  static const(char)[] getVendorString() {
    version (__OPENGL__)
      return getString(GL_VENDOR);
    else
      return "";
  }

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

  static const(char)[] getRendererString() {
    version (__OPENGL__)
      return getString(GL_RENDERER);
    else
      return "";
  }

  static const(char)[] getShadingVersionString() {
    version (__OPENGL__)
      return getString(GL_SHADING_LANGUAGE_VERSION);
    else
      return "";
  }

  static string[] getExtensions() nothrow {
    return backend.getInfo().extensions;
  }

  static int getInt(uint pname) {
    version (__OPENGL__) {
      GLint param;
      glGetIntegerv(pname, &param);
      debug runtimeCheckErr();
      return param;
    }
    else
      return 0;
  }

  static float getFloat(uint pname) {
    version (__OPENGL__) {
      GLfloat res;
      glGetFloatv(pname, &res);
      debug runtimeCheckErr();
      return res;
    }
    else
      return 0;
  }

  static int getMaxColorAttachments() nothrow {
    return backend.getInfo().maxColorAttachments;
  }

  static void getActiveTexture(int texture_id) {
    version (__OPENGL__)
      glActiveTexture(GL_TEXTURE0 + texture_id);
    
    debug runtimeCheckErr();
  }

  private static string getErrorString(int er) nothrow {
    version (__OPENGL__)
      switch (er) {
        case GL_NO_ERROR:
          return "GL_NO_ERROR";
        case GL_INVALID_ENUM:
          return "GL_INVALID_ENUM";
        case GL_INVALID_VALUE:
          return "GL_INVALID_VALUE";
        case GL_INVALID_OPERATION:
          return "GL_INVALID_OPERATION";
        case GL_OUT_OF_MEMORY:
          return "GL_OUT_OF_MEMORY";
        default:
          return "Unknown OpenGL error";
      }
    else
      return "";
  }

  private static void flushErrors() nothrow {
    int timeout;
    while (++timeout <= 5)
      version (__OPENGL__) {
        immutable GLint r = glGetError();
        if (r == GL_NO_ERROR)
          break;
      }
  }
}