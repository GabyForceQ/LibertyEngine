/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/opengl/backend.d, _backend.d)
 * Documentation:
 * Coverage:
 */
// TODO: Optimize imports.
// TODO: Get rid of public import.
// TODO: Extensions string[] with defaults.
module liberty.graphics.opengl.backend;
version (__OpenGL__) :
import core.stdc.stdlib;
import derelict.sdl2.sdl : SDL_GL_SwapWindow;
import std.string, std.conv, std.array, std.algorithm;
public import derelict.opengl.types: GLVersion;
import derelict.opengl;
import derelict.util.exception : ShouldThrow;
import derelict.opengl.gl;
import liberty.graphics.renderer : Vendor;
import liberty.graphics.video.backend : VideoBackend;
import liberty.core.engine;
/// The one exception type thrown in this wrapper.
/// A failing OpenGL function should <b>always</b> throw an $(D GLException).
class GLException : Exception {
    ///
    this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) pure nothrow @safe {
        super(message, file, line, next);
    }
}
///
final class GLBackend : VideoBackend {
    /// Load OpenGL library.
    /// Throws: $(D GLException) on error.
    this() @trusted {
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
    }
    /// Returns true if the OpenGL extension is supported.
    override bool supportsExtension(string extension) pure nothrow @safe @nogc {
        foreach (el; _extensions) {
            if (el == extension) {
                return true;
            }
        }
        return false;
    }
    /// Reload OpenGL function pointers.
    /// Once a first OpenGL context has been created, you should call reload() to get the context you want.
    /// This will attempt to load every OpenGL function except deprecated.
    /// Warning: This may be dangerous because drivers may miss some functions!
    override void reload() @trusted {
        DerelictGL3.reload();
        getLimits(true);
    }
    /// Check for pending OpenGL errors, log a message if there is.
    /// Only for debug purpose since this check will be disabled in a release build.
    debug override void debugCheck() nothrow @trusted {
        GLint er = glGetError();
        if (er != GL_NO_ERROR) {
            flushGLErrors();
            assert(false, "OpenGL error: " ~ errorString(er));
        }
    }
    /// Checks pending OpenGL errors.
    /// Throws: $(D GLException) if at least one OpenGL error was pending.
    override void runtimeCheck() @trusted {
        GLint er = glGetError();
        if (er != GL_NO_ERROR) {
            string errorString = errorString(er);
            flushGLErrors();
            throw new GLException(errorString);
        }
    }
    /// Checks pending OpenGL errors.
    /// Returns true if at least one OpenGL error was pending.
    /// OpenGL error status is cleared.
    override bool runtimeCheckNothrow() nothrow {
        immutable GLint r = glGetError();
        if (r != GL_NO_ERROR) {
            flushGLErrors();
            return false;
        }
        return true;
    }
    /// Returns OpenGL string returned by $(D glGetString).
    const(char)[] getString(GLenum name) @trusted {
        const(char)* sZ = glGetString(name);
        runtimeCheck();
        if (sZ is null) {
            return "(unknown)";
        } else {
            return sZ.fromStringz;
        }
    }
    /// Returns OpenGL string returned by $(D glGetStringi).
    const(char)[] getString(GLenum name, GLuint index) @trusted {
        const(char)* sZ = glGetStringi(name, index);
        runtimeCheck();
        if (sZ is null) {
            return "(unknown)";
        } else {
            return sZ.fromStringz;
        }
    }
    /// Returns OpenGL major version.
    override int majorVersion() pure nothrow const @safe @nogc @property {
        return _majorVersion;
    }
    /// Returns OpenGL minor version.
    override int minorVersion() pure nothrow const @safe @nogc @property {
        return _minorVersion;
    }
    /// Returns OpenGL version string.
    override const(char)[] versionString() @safe {
        return getString(GL_VERSION);
    }
    /// Returns the company responsible for this OpenGL implementation.
    override const(char)[] vendorString() @safe {
        return getString(GL_VENDOR);
    }
    /// Tries to detect the driver maker. Returns identified vendor.
    override Vendor vendor() @safe {
        const(char)[] s = vendorString();
        if (canFind(s, "AMD") || canFind(s, "ATI") || canFind(s, "Advanced Micro Devices")) {
            return Vendor.Amd;
        } else if (canFind(s, "NVIDIA") || canFind(s, "nouveau") || canFind(s, "Nouveau")) {
            return Vendor.Nvidia;
        } else if (canFind(s, "Intel")) {
            return Vendor.Intel;
        } else if (canFind(s, "Mesa")) {
            return Vendor.Mesa;
        } else if (canFind(s, "Microsoft")) {
            return Vendor.Microsoft;
        } else if (canFind(s, "Apple")) {
            return Vendor.Apple;
        } else {
            return Vendor.Other;
        }
    }
    /// Returns the name of the renderer.
    /// This name is typically specific to a particular configuration of a hardware platform.
    override const(char)[] graphicsEngineString() @safe {
        return getString(GL_RENDERER);
    }
    /// Returns GLSL version string.
    override const(char)[] glslVersionString() @safe {
        return getString(GL_SHADING_LANGUAGE_VERSION);
    }
    /// Returns a slice made up of available extension names.
    override string[] extensions() pure nothrow @safe @nogc {
        return _extensions;
    }
	/// Returns the requested int returned by $(D glGetFloatv).
    /// Throws: $(D GLException) if at least one OpenGL error was pending.
    int getInt(GLenum pname) @trusted {
        GLint param;
        glGetIntegerv(pname, &param);
        runtimeCheck();
        return param;
    }
    /// Returns the requested float returned by $(D glGetFloatv).
    /// Throws: $(D GLException) if at least one OpenGL error was pending.
    float getFloat(GLenum pname) @trusted {
        GLfloat res;
        glGetFloatv(pname, &res);
        runtimeCheck();
        return res;
    }
    /// Returns the maximum number of color attachments. This is the number of targets a fragment shader can output to.
    /// You can rely on this number being at least 4 if MRT is supported.
    override int maxColorAttachments() pure nothrow const @safe @nogc @property {
        return _maxColorAttachments;
    }

    /// Sets the "active texture" which is more precisely active texture unit.
    /// Throws: $(D GLException) on error.
    override void activeTexture(int texture_id) @trusted @property {
        glActiveTexture(GL_TEXTURE0 + texture_id);
        runtimeCheck();
    }
    ///
    override void resizeViewport() @trusted {
        glViewport(0, 0, CoreEngine.get.mainWindow.size.x, CoreEngine.get.mainWindow.size.y);
    }
    ///
    override void clear() @trusted {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
    ///
    override void clearColor(float r, float g, float b, float a) @trusted {
        glClearColor(r, g, b, a);
    }
    /// Swap OpenGL buffers.
    /// Throws: $(D GLException) on error.
    override void swapBuffers() @trusted {
        if (CoreEngine.get.mainWindow.glContext is null) { // TODO
            throw new GLException("swapBuffers() failed: not an OpenGL window");
        }
        SDL_GL_SwapWindow(CoreEngine.get.mainWindow._window); // TODO
    }
    package static string errorString(GLint er) pure nothrow @safe @nogc {
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
    private void getLimits(bool isReload) @safe {
        if (isReload) {
            const(char)[] verString = versionString;
            int firstSpace = cast(int)countUntil(verString, " ");
            if (firstSpace != -1) {
                verString = verString[0..firstSpace];
            }
            const(char)[][] verParts = std.array.split(verString, ".");
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
                _extensions = std.array.split(getString(GL_EXTENSIONS).idup);
            } else {
                immutable int numExtensions = getInt(GL_NUM_EXTENSIONS);
                _extensions.length = 0;
                for (int i = 0; i < numExtensions; ++i) {
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
    private void flushGLErrors() nothrow @trusted @nogc {
        int timeout;
        while (++timeout <= 5) {
            immutable GLint r = glGetError();
            if (r == GL_NO_ERROR) {
                break;
            }
        }
    }
}
