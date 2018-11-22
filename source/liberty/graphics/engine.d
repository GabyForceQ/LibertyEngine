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
import liberty.graphics.color;
import liberty.graphics.constants;

/**
 *
**/
struct GfxEngineInfo {
  /**
   *
  **/
  string[] apiExtensions;

  /**
   *
  **/
  int apiMajorVersion;

  /**
   *
  **/
  int apiMinorVersion;

  /**
   *
  **/
  int apiMaxColorAttachments;
}

/**
 *
**/
final abstract class GfxEngine {
  private {
    static GfxEngineInfo info;
    static bool wireframe;
  }

  /**
   * Set wireframe mode.
  **/
  static void setWireframe(bool value = true) {
    version (__OPENGL__)
      glPolygonMode(GL_FRONT_AND_BACK, value ? GL_LINE : GL_FILL);

    wireframe = value;
  }

  /**
   * Switch between wireframe and non-wireframe mode.
  **/
  static void toggleWireframe() {
    version (__OPENGL__)
      glPolygonMode(GL_FRONT_AND_BACK, wireframe ? GL_FILL : GL_LINE);

    wireframe = !wireframe;
  }

  /**
   *
  **/
  static void initialize() {
    Logger.info("Start realoading OpenGL", typeof(this).stringof);

    const res = loadOpenGL();
    if (res == glSupport.gl45) {
      Logger.info("OpenGL 4.5 loaded", typeof(this).stringof);
      info.apiMajorVersion = 4;
      info.apiMinorVersion = 5;
    } else if (res == glSupport.gl30) {
      Logger.info("OpenGL 3.0 loaded", typeof(this).stringof);
      info.apiMajorVersion = 3;
      info.apiMinorVersion = 0;
    }
    else
      Logger.error("No OpenGL library", typeof(this).stringof);

    enableDepthTest();

    Logger.info("Finish realoading OpenGL", typeof(this).stringof);
  }

  /**
   *
  **/
  static void clearScreen() {
    version (__OPENGL__) {
      glClearDepth(1.0);
	    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
      glClearColor(0.5f, 0.8f, 0.8f, 1.0f);
    }
  }

  /**
   *
  **/
  static void clearColor(Color color) {
    version (__OPENGL__) {
      glClearColor(color.r / 255.0f, color.g / 255.0f, color.b / 255.0f, color.a / 255.0f);
    }
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
  static void enableCulling() {
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
  }

  /**
   *
  **/
  static void disableCulling() {
    glDisable(GL_CULL_FACE);
  }

  /**
   *
  **/
  static void resizeFrameBufferViewport(int width, int height) nothrow {
    try {
      version (__OPENGL__)
        glViewport(0, 0, width, height);
    } catch (Exception e) {}
  }

  /**
   *
  **/
  static void enableDepthTest() {
    version (__OPENGL__) {
      glEnable(GL_DEPTH_TEST);
    }
  }

  /**
   *
  **/
  static void disableDepthTest() {
    version (__OPENGL__) {
      glDisable(GL_DEPTH_TEST);
    }
  }

  /**
   *
  **/
  static void enableTextures() {
    version (__OPENGL__)
      glEnable(GL_TEXTURE_2D);
  }

  /**
   *
  **/
  static void disableTextures() {
    version (__OPENGL__)
      glDisable(GL_TEXTURE_2D);
  }

  /**
   *
  **/
  static bool supportsExtension(string extension) nothrow {
    foreach (el; info.apiExtensions)
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

  static int getMajorVersion() nothrow {
    return info.apiMajorVersion;
  }

  static int getMinorVersion() nothrow {
    return info.apiMinorVersion;
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
      return GfxVendor.Amd;
    else if (canFind(s, "NVIDIA"))
      return GfxVendor.Nvidia;
    else if (canFind(s, "Intel"))
      return GfxVendor.Intel;
    else
      return GfxVendor.Other;
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
    return info.apiExtensions;
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
    return info.apiMaxColorAttachments;
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