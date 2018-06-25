// TODO: Optimize imports.
// TODO: Get rid of public import.
// TODO: Extensions string[] with defaults.
module crystal.graphics.opengl.backend;
version (__OpenGL__) :
import core.stdc.stdlib;
import derelict.sdl2.sdl : SDL_GL_SwapWindow;
import std.string, std.conv, std.array, std.algorithm;
public import derelict.opengl.types: GLVersion;
import derelict.opengl;
import derelict.util.exception : ShouldThrow;
import derelict.opengl.gl;
import crystal.graphics.renderer : Vendor;
import crystal.graphics.video.backend : VideoBackend;
import crystal.core.engine;
/// The one exception type thrown in this wrapper.
/// A failing OpenGL function should <b>always</b> throw an $(D GLException).
class GLException : Exception {
    ///
    @safe pure nothrow this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
        super(message, file, line, next);
    }
}
///
final class GLBackend : VideoBackend {
    /// Load OpenGL library.
    /// Throws: $(D GLException) on error.
    this() {
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
    override bool supportsExtension(string extension) {
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
    override void reload() {
        DerelictGL3.reload();
        getLimits(true);
    }
    /// Check for pending OpenGL errors, log a message if there is.
    /// Only for debug purpose since this check will be disabled in a release build.
    debug override void debugCheck() {
        GLint er = glGetError();
        if (er != GL_NO_ERROR) {
            flushGLErrors();
            assert(false, "OpenGL error: " ~ getErrorString(er));
        }
    }
    /// Checks pending OpenGL errors.
    /// Throws: $(D GLException) if at least one OpenGL error was pending.
    override void runtimeCheck() {
        GLint er = glGetError();
        if (er != GL_NO_ERROR) {
            string errorString = getErrorString(er);
            flushGLErrors();
            throw new GLException(errorString);
        }
    }
    /// Checks pending OpenGL errors.
    /// Returns true if at least one OpenGL error was pending.
    /// OpenGL error status is cleared.
    override bool runtimeCheckNothrow() nothrow {
        GLint r = glGetError();
        if (r != GL_NO_ERROR) {
            flushGLErrors();
            return false;
        }
        return true;
    }
    /// Returns OpenGL string returned by $(D glGetString).
    const(char)[] getString(GLenum name) {
        const(char)* sZ = glGetString(name);
        runtimeCheck();
        if (sZ is null) {
            return "(unknown)";
        } else {
            return sZ.fromStringz;
        }
    }
    /// Returns OpenGL string returned by $(D glGetStringi).
    const(char)[] getString(GLenum name, GLuint index) {
        const(char)* sZ = glGetStringi(name, index);
        runtimeCheck();
        if (sZ is null) {
            return "(unknown)";
        } else {
            return sZ.fromStringz;
        }
    }
    /// Returns OpenGL major version.
    override int getMajorVersion() pure const nothrow {
        return _majorVersion;
    }

    /// Returns OpenGL minor version.
    override int getMinorVersion() pure const nothrow {
        return _minorVersion;
    }
    /// Returns OpenGL version string.
    override const(char)[] getVersionString() {
        return getString(GL_VERSION);
    }
    /// Returns the company responsible for this OpenGL implementation.
    override const(char)[] getVendorString() {
        return getString(GL_VENDOR);
    }
    /// Tries to detect the driver maker.
    /// Returns identified vendor.
    override Vendor getVendor() {
        const(char)[] s = getVendorString();
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
    override const(char)[] getGraphicsEngineString() {
        return getString(GL_RENDERER);
    }
    /// Returns GLSL version string.
    override const(char)[] getGLSLVersionString() {
        return getString(GL_SHADING_LANGUAGE_VERSION);
    }
    /// Returns a slice made up of available extension names.
    override string[] getExtensions() pure nothrow {
        return _extensions;
    }
	/// Returns the requested int returned by $(D glGetFloatv).
    /// Throws: $(D GLException) if at least one OpenGL error was pending.
    int getInt(GLenum pname) {
        GLint param;
        glGetIntegerv(pname, &param);
        runtimeCheck();
        return param;
    }
    /// Returns the requested float returned by $(D glGetFloatv).
    /// Throws: $(D GLException) if at least one OpenGL error was pending.
    float getFloat(GLenum pname) {
        GLfloat res;
        glGetFloatv(pname, &res);
        runtimeCheck();
        return res;
    }
    /// Returns the maximum number of color attachments. This is the number of targets a fragment shader can output to.
    /// You can rely on this number being at least 4 if MRT is supported.
    override int maxColorAttachments() pure const nothrow {
        return _maxColorAttachments;
    }

    /// Sets the "active texture" which is more precisely active texture unit.
    /// Throws: $(D GLException) on error.
    override void setActiveTexture(int texture_id) {
        glActiveTexture(GL_TEXTURE0 + texture_id);
        runtimeCheck();
    }
    ///
    override void resizeViewport() {
        glViewport(0, 0, CoreEngine.getMainWindow().getSize().x, CoreEngine.getMainWindow().getSize().y);
    }
    ///
    override void clear() {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
    ///
    override void clearColor(float r, float g, float b, float a) {
        glClearColor(r, g, b, a);
    }
    /////
    //override void clearColor(ubyte r, ubyte g, ubyte b, ubyte a) {
    //    glClearColor(r / 255.0f, g / 255.0f, b / 255.0f, a / 255.0f);
    //}
    /// Swap OpenGL buffers.
    /// Throws: $(D GLException) on error.
    override void swapBuffers() {
        if (CoreEngine.getMainWindow.getGLContext() is null) { // TODO
            throw new GLException("swapBuffers() failed: not an OpenGL window");
        }
        SDL_GL_SwapWindow(CoreEngine.getMainWindow()._window); // TODO
    }
    package static string getErrorString(GLint er) pure nothrow {
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
    private void getLimits(bool isReload) {
        if (isReload) {
            const(char)[] verString = getVersionString();
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
                int numExtensions = getInt(GL_NUM_EXTENSIONS);
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
    private void flushGLErrors() nothrow {
        int timeout = 0;
        while (++timeout <= 5) {
            GLint r = glGetError();
            if (r == GL_NO_ERROR) {
                break;
            }
        }
    }
}
