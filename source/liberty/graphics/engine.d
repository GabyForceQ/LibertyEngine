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

import liberty.math.vector : Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.logger : Logger, InfoMessage;
import liberty.core.platform : Platform;
import liberty.graphics.color : Color;
import liberty.graphics.constants : GfxVendor;

/**
 *
**/
class GfxEngine {
  private {
    static string[] _extensions;
    static int _majorVersion;
    static int _minorVersion;
    static int _maxColorAttachments;
    static bool wireframe;
  }

  @disable this();

  /**
   *
  **/
  static void toggleWireframe() {
    if (!wireframe) {
      version (__OPENGL__)
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    } else {
      version (__OPENGL__)
        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    }

    wireframe = !wireframe;
  }

  /**
   *
  **/
  static void initialize() {
    Logger.info(InfoMessage.Creating, typeof(this).stringof);

    Logger.info(InfoMessage.Created, typeof(this).stringof);
  }

  /**
   *
  **/
  static void reloadFeatures() {
    Logger.info("Start realoading OpenGL", typeof(this).stringof);

    const res = loadOpenGL();
    if (res == glSupport.gl45)
      Logger.info("OpenGL 4.5 loaded", typeof(this).stringof);
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

  static void enableDepthTest() {
    version (__OPENGL__) {
      glEnable(GL_DEPTH_TEST);
    }
  }

  static void disableDepthTest() {
    version (__OPENGL__) {
      glDisable(GL_DEPTH_TEST);
    }
  }

  static void enableTextures() {
    version (__OPENGL__)
      glEnable(GL_TEXTURE_2D);
  }

  static void disableTextures() {
    version (__OPENGL__)
      glDisable(GL_TEXTURE_2D);
  }

  static bool supportsExtension(string extension) nothrow {
    foreach (el; _extensions)
      if (el == extension)
        return true;
    return false;
  }

  debug static void runtimeCheck() {
    version (__OPENGL__) {
      GLint er = glGetError();
      if (er != GL_NO_ERROR) {
        string getErrorString = getErrorString(er);
        flushErrors();
        //Logger.error(getErrorString, typeof(this).stringof);
        Logger.warning(getErrorString, typeof(this).stringof);
      }
    }
  }

  debug static bool runtimeCheckNothrow() nothrow {
    version (__OPENGL__) {
      immutable GLint r = glGetError();
      if (r != GL_NO_ERROR) {
        flushErrors();
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
    
    debug runtimeCheck();
    
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
    
    debug runtimeCheck();
    
    if (sZ is null)
      return "(unknown)";
    else
      return sZ.fromStringz;
  }

  static int getMajorVersion() nothrow {
    return _majorVersion;
  }

  static int getMinorVersion() nothrow {
    return _minorVersion;
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
    return _extensions;
  }

  static int getInt(uint pname) {
    version (__OPENGL__) {
      GLint param;
      glGetIntegerv(pname, &param);
      debug runtimeCheck();
      return param;
    }
    else
      return 0;
  }

  static float getFloat(uint pname) {
    version (__OPENGL__) {
      GLfloat res;
      glGetFloatv(pname, &res);
      debug runtimeCheck();
      return res;
    }
    else
      return 0;
  }

  static int getMaxColorAttachments() nothrow {
    return _maxColorAttachments;
  }

  static void getActiveTexture(int texture_id) {
    version (__OPENGL__)
      glActiveTexture(GL_TEXTURE0 + texture_id);
    
    debug runtimeCheck();
  }

  private static string getErrorString(int er) nothrow {
    version (__OPENGL__)
      switch(er) {
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
    while (++timeout <= 5) {
      version (__OPENGL__) {
        immutable GLint r = glGetError();
        if (r == GL_NO_ERROR)
          break;
      }
    }
  }
}