/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/backend/opengl.d, _opengl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.backend.opengl;

import derelict.util.exception : ShouldThrow;
import derelict.opengl : 
  DerelictGL3, GLenum, GLuint, GLint, GLfloat,
  glGetString, glGetStringi, glGetIntegerv,
  glClearDepth, glClear, glGetError,
  glGetFloatv, glActiveTexture, glClearColor,
  glEnable, glFrontFace, glCullFace, glDisable,
  GL_FRONT, GL_CULL_FACE, GL_DEPTH_TEST, GL_CW,
  GL_NUM_EXTENSIONS, GL_EXTENSIONS, 
  GL_MAX_COLOR_ATTACHMENTS, GL_NO_ERROR,
  GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT,
  GL_VERSION, GL_VENDOR, GL_RENDERER,
  GL_SHADING_LANGUAGE_VERSION, GL_TEXTURE0,
  GL_INVALID_ENUM, GL_INVALID_VALUE,
  GL_INVALID_OPERATION, GL_OUT_OF_MEMORY,
  GL_TEXTURE_2D;

import liberty.core.logger.constants : InfoMessage;
import liberty.core.logger.manager : Logger;
import liberty.graphics.backend.gfx : GfxBackend;
import liberty.graphics.constants : Vendor;

/**
 *
**/
final class GLBackend : GfxBackend {
  /**
   * Load OpenGL library.
  **/
  this() @trusted {
    Logger.self.info(
      InfoMessage.Creating,
      typeof(this).stringof
    );

    ShouldThrow missingSymFunc(string symName) {
      if (symName == "glGetSubroutineUniformLocation") {
        return ShouldThrow.No;
      }
      if (symName == "glVertexAttribL1d") {
        return ShouldThrow.No;
      }
      return ShouldThrow.Yes;
    }
    DerelictGL3.missingSymbolCallback = &missingSymFunc;
    DerelictGL3.load();
    getLimits(false);

    Logger.self.info(
      InfoMessage.Created,
      typeof(this).stringof
    );
  }

  ~this() {
    Logger.self.info(
      InfoMessage.Destroyed,
      typeof(this).stringof
    );
  }

  /**
   *
  **/
  override void reloadContext() @trusted {
    DerelictGL3.reload();
    getLimits(true);
  }

  /**
   *
  **/
  override void clearColor(float r, float g, float b, float a) @trusted {
    glClearColor(r, g, b, a);
  }

  /**
   *
  **/
  override void enable3DCapabilities() @trusted {
    glFrontFace(GL_CW);
    glCullFace(GL_FRONT);
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);

    // todo: depth clamp.

    // todo: 2d capabilities
    enableTextures();
  }

  /**
   *
  **/
  override void enableTextures() @trusted {
    glEnable(GL_TEXTURE_2D);
  }

  /**
   *
  **/
  override void disableTextures() @trusted {
    glDisable(GL_TEXTURE_2D);
  }

  /**
   *
  **/
  override void clearScreen() @trusted {
    glClearDepth(1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  }

  /**
   * Returns true if the OpenGL extension is supported.
  **/
  override bool supportsExtension(string extension) pure nothrow @safe {
    foreach (el; _extensions) {
      if (el == extension) {
        return true;
      }
    }
    return false;
  }

  /**
   * Check for pending OpenGL errors, log a message if there is.
   * Only for debug purpose since this check will be disabled in a release build.
  **/
  debug override void debugCheck() nothrow @trusted {
    GLint er = glGetError();
    if (er != GL_NO_ERROR) {
      flushGLErrors();
      assert(false, "OpenGL error: " ~ getErrorString(er));
    }
  }

  /**
   * Checks pending OpenGL errors.
  **/
  override void runtimeCheck() @trusted {
    GLint er = glGetError();
    if (er != GL_NO_ERROR) {
      string getErrorString = getErrorString(er);
      flushGLErrors();
      Logger.self.error(
        getErrorString,
        typeof(this).stringof
      );
    }
  }

  /**
   * Checks pending OpenGL errors.
   * Returns true if at least one OpenGL error was pending.
   * OpenGL error status is cleared.
  **/
  override bool runtimeCheckNothrow() nothrow {
    immutable GLint r = glGetError();
    if (r != GL_NO_ERROR) {
      flushGLErrors();
      return false;
    }
    return true;
  }

  /**
   *
  **/
  const(char)[] getString(GLenum name) @trusted {
    import std.string : fromStringz;
    const(char)* sZ = glGetString(name);
    runtimeCheck();
    if (sZ is null) {
      return "(unknown)";
    } else {
      return sZ.fromStringz;
    }
  }

  /**
   *
  **/
  const(char)[] getString(GLenum name, GLuint index) @trusted {
    import std.string : fromStringz;
    const(char)* sZ = glGetStringi(name, index);
    runtimeCheck();
    if (sZ is null) {
      return "(unknown)";
    } else {
      return sZ.fromStringz;
    }
  }

  /**
   * Returns OpenGL major version.
  **/
  override int getMajorVersion() pure nothrow const @safe {
    return _majorVersion;
  }

  /**
   * Returns OpenGL minor version.
  **/
  override int getMinorVersion() pure nothrow const @safe {
    return _minorVersion;
  }

  /**
   * Returns OpenGL version string.
  **/
  override const(char)[] getVersionString() @safe {
    return getString(GL_VERSION);
  }

  /**
   * Returns the company responsible for this OpenGL implementation.
  **/
  override const(char)[] getVendorString() @safe {
    return getString(GL_VENDOR);
  }

  /**
   * Tries to detect the driver maker. Returns identified vendor.
  **/
  override Vendor getVendor() @safe {
    import std.algorithm.searching : canFind;
    const(char)[] s = getVendorString();
    if (canFind(s, "AMD")) {
      return Vendor.Amd;
    } else if (canFind(s, "NVIDIA")) {
      return Vendor.Nvidia;
    } else if (canFind(s, "Intel")) {
      return Vendor.Intel;
    } else {
      return Vendor.Other;
    }
  }

  /**
   * Returns the name of the renderer.
  **/
  override const(char)[] getGraphicsEngineString() @safe {
      return getString(GL_RENDERER);
  }

  /**
   * Returns GLSL version string.
  **/
  override const(char)[] getShadingVersionString() @safe {
    return getString(GL_SHADING_LANGUAGE_VERSION);
  }

  /**
   * Returns a slice made up of available extension names.
  **/
  override string[] getExtensions() pure nothrow @safe {
    return _extensions;
  }

  /**
   *
  **/
  int getInt(GLenum pname) @trusted {
    GLint param;
    glGetIntegerv(pname, &param);
    runtimeCheck();
    return param;
  }

  /**
   *
  **/
  float getFloat(GLenum pname) @trusted {
    GLfloat res;
    glGetFloatv(pname, &res);
    runtimeCheck();
    return res;
  }

  /**
   *
  **/
  override int getMaxColorAttachments() pure nothrow const @safe {
    return _maxColorAttachments;
  }

  /**
   *
  **/
  override void getActiveTexture(int texture_id) @trusted {
    glActiveTexture(GL_TEXTURE0 + texture_id);
    runtimeCheck();
  }

  package static string getErrorString(GLint er) pure nothrow @safe {
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

  private void flushGLErrors() nothrow @trusted {
    int timeout;
    while (++timeout <= 5) {
      immutable GLint r = glGetError();
      if (r == GL_NO_ERROR) {
        break;
      }
    }
  }

  private void getLimits(bool isReload) @safe {
      import std.algorithm.searching : countUntil;
      import std.conv : to;
      import std.array : split;
      if (isReload) {
          const(char)[] verString = getVersionString;
          int firstSpace = cast(int)countUntil(verString, " ");
          if (firstSpace != -1) {
              verString = verString[0..firstSpace];
          }
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
          if (_majorVersion < 3) {
              _extensions = split(getString(GL_EXTENSIONS).idup);
          } else {
              immutable int numExtensions = getInt(GL_NUM_EXTENSIONS);
              _extensions.length = 0;
              for (int i; i < numExtensions; ++i) {
                  _extensions ~= getString(GL_EXTENSIONS, i).idup;
              }
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