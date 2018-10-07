/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/engine.d, _engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.engine;

import derelict.opengl;

import derelict.util.exception : ShouldThrow;
import derelict.glfw3.glfw3 : glfwSwapInterval, glfwSwapBuffers;
import derelict.opengl :
  DerelictGL3, glClearDepth, glClearColor, glClear, glEnable, glBlendFunc,
  GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT, GL_STENCIL_BUFFER_BIT,
  GL_DEPTH_TEST, GL_BLEND, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA;

import liberty.core.engine : CoreEngine;
import liberty.core.logger : Logger, InfoMessage;
import liberty.core.platform : Platform;
import liberty.graphics.color : Color;
import liberty.graphics.constants : Vendor;

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
    DerelictGL3.missingSymbolCallback = &missingSymbolFunc;
    DerelictGL3.load();
    getLimits(false);

    Logger.info(InfoMessage.Created, typeof(this).stringof);
  }

  /**
   *
  **/
  static void reloadFeatures() {
    Logger.info("Start realoading OpenGL", typeof(this).stringof);

    DerelictGL3.reload();
    getLimits(true);

    glEnable(GL_DEPTH_TEST);

    Logger.info("Finish realoading OpenGL", typeof(this).stringof);
  }

  /**
   *
  **/
  static void render() {
    clearScreen();

    CoreEngine.getScene().shaderList["CoreShader"].bind();
    CoreEngine.getScene().render();
    CoreEngine.getScene().shaderList["CoreShader"].unbind();

    glfwSwapBuffers(Platform.getWindow().getHandle());
  }

  /**
   *
  **/
  static void clearScreen() {
    glClearDepth(1.0);
	  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    glClearColor(0.1f, 0.1f, 0.44f, 1.0f);
  }

  /**
   *
  **/
  static void clearColor(Color color) {
    glClearColor(color.r / 255.0f, color.g / 255.0f, color.b / 255.0f, color.a / 255.0f);
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
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  }

  /**
   *
  **/
  static void resizeFrameBufferViewport(int width, int height) nothrow {
    try {
      glViewport(0, 0, width, height);
    } catch (Exception e) {}
  }

  private static void getLimits(bool isReload) {
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

  static void enable3DCapabilities() {
    glFrontFace(GL_CW);
    glCullFace(GL_FRONT);
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    enableTextures();
  }

  static void enableTextures() {
    glEnable(GL_TEXTURE_2D);
  }

  static void disableTextures() {
    glDisable(GL_TEXTURE_2D);
  }

  static bool supportsExtension(string extension) nothrow {
    foreach (el; _extensions)
      if (el == extension)
        return true;
    return false;
  }

  debug static void debugCheck() nothrow {
    GLint er = glGetError();
    if (er != GL_NO_ERROR) {
      flushGLErrors();
      assert(false, "OpenGL error: " ~ getErrorString(er));
    }
  }

  static void runtimeCheck() {
    GLint er = glGetError();
    if (er != GL_NO_ERROR) {
      string getErrorString = getErrorString(er);
      flushGLErrors();
      Logger.error(getErrorString, typeof(this).stringof);
    }
  }

  static bool runtimeCheckNothrow() nothrow {
    immutable GLint r = glGetError();
    if (r != GL_NO_ERROR) {
      flushGLErrors();
      return false;
    }
    return true;
  }

  static const(char)[] getString(GLenum name) {
    import std.string : fromStringz;
    const(char)* sZ = glGetString(name);
    runtimeCheck();
    if (sZ is null)
      return "(unknown)";
    else
      return sZ.fromStringz;
  }

  static const(char)[] getString(GLenum name, GLuint index) {
    import std.string : fromStringz;
    const(char)* sZ = glGetStringi(name, index);
    runtimeCheck();
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
    return getString(GL_VERSION);
  }

  static const(char)[] getVendorString() {
    return getString(GL_VENDOR);
  }

  static Vendor getVendor() {
    import std.algorithm.searching : canFind;
    const(char)[] s = getVendorString();
    if (canFind(s, "AMD"))
      return Vendor.Amd;
    else if (canFind(s, "NVIDIA"))
      return Vendor.Nvidia;
    else if (canFind(s, "Intel"))
      return Vendor.Intel;
    else
      return Vendor.Other;
  }

  static const(char)[] getRendererString() {
    return getString(GL_RENDERER);
  }

  static const(char)[] getShadingVersionString() {
    return getString(GL_SHADING_LANGUAGE_VERSION);
  }

  static string[] getExtensions() nothrow {
    return _extensions;
  }

  static int getInt(GLenum pname) {
    GLint param;
    glGetIntegerv(pname, &param);
    runtimeCheck();
    return param;
  }

  static float getFloat(GLenum pname) {
    GLfloat res;
    glGetFloatv(pname, &res);
    runtimeCheck();
    return res;
  }

  static int getMaxColorAttachments() nothrow {
    return _maxColorAttachments;
  }

  static void getActiveTexture(int texture_id) {
    glActiveTexture(GL_TEXTURE0 + texture_id);
    runtimeCheck();
  }

  private static string getErrorString(GLint er) nothrow {
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
  }

  private static void flushGLErrors() nothrow {
    int timeout;
    while (++timeout <= 5) {
      immutable GLint r = glGetError();
      if (r == GL_NO_ERROR)
        break;
    }
  }
}