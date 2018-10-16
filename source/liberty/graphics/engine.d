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
  import derelict.opengl;

import derelict.util.exception : ShouldThrow;
import derelict.glfw3.glfw3 : glfwSwapInterval, glfwSwapBuffers;

import liberty.core.math.vector : Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.core.logger : Logger, InfoMessage;
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
  }

  @disable this();

  /**
   *
  **/
  static void initialize() {
    Logger.info(InfoMessage.Creating, typeof(this).stringof);

    ShouldThrow missingSymbolFunc(string name) {
      if (name == "glGetSubroutineUniformLocation")
        return ShouldThrow.No;
      if (name == "glVertexAttribL1d")
        return ShouldThrow.No;
      return ShouldThrow.Yes;
    }
    
    version (__OPENGL__) {
      DerelictGL3.missingSymbolCallback = &missingSymbolFunc;
      DerelictGL3.load();
    }

    getLimits(false);

    Logger.info(InfoMessage.Created, typeof(this).stringof);
  }

  /**
   *
  **/
  static void reloadFeatures() {
    Logger.info("Start realoading OpenGL", typeof(this).stringof);

    version (__OPENGL__)
      DerelictGL3.reload();
    
    getLimits(true);

    version (__OPENGL__)
      glEnable(GL_DEPTH_TEST);

    Logger.info("Finish realoading OpenGL", typeof(this).stringof);
  }

  /**
   *
  **/
  static void render() {
    clearScreen();
    CoreEngine.getScene().render();
    glfwSwapBuffers(Platform.getWindow().getHandle());
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
  static void enableVSync() {
    glfwSwapInterval(1);
  }

  /**
   *
  **/
  static void disableVSync() {
    glfwSwapInterval(0);
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

  private static void getLimits(bool isReload) {
    version (__OPENGL__) {
      import std.algorithm.searching : countUntil;
      import std.conv : to;
      import std.array : split;
      if (isReload) {
        const(char)[] verString = getVersionString;
        int firstSpace = cast(int)countUntil(verString, " ");
        if (firstSpace != -1)
          verString = verString[0..firstSpace];
        const(char)[][] verParts = split(verString, ".");
        if (verParts.length < 2) {
          cant_parse:
          _majorVersion = 1;
          _minorVersion = 1;
        } else {
          try {
            _majorVersion = to!int(verParts[0]);
          } catch (Exception e) {
            goto cant_parse;
          }
          try {
            _minorVersion = to!int(verParts[1]);
          } catch (Exception e) {
            goto cant_parse;
          }
        }
        if (_majorVersion < 3)
          _extensions = split(getString(GL_EXTENSIONS).idup);
        else {
          immutable int numExtensions = getInt(GL_NUM_EXTENSIONS);
          _extensions.length = 0;
          for (int i; i < numExtensions; ++i)
            _extensions ~= getString(GL_EXTENSIONS, i).idup;
        }
        _maxColorAttachments = getInt(GL_MAX_COLOR_ATTACHMENTS);
      } else {
        _majorVersion = 1;
        _minorVersion = 1;
        _extensions = [];
        _maxColorAttachments = 0;
      }
    }
  }

  static void enable3DCapabilities() {
    version (__OPENGL__) {
      glFrontFace(GL_CW);
      glCullFace(GL_FRONT);
      glEnable(GL_CULL_FACE);
      glEnable(GL_DEPTH_TEST);
    }
    enableTextures();
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