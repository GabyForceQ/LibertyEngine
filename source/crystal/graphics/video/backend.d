/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
// TODO: Window background transparency.
module crystal.graphics.video.backend;
import crystal.graphics.renderer : Vendor;
///
class UnsupportedVideoFeatureException : Exception {
    ///
    this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) pure nothrow @safe {
        super(message, file, line, next);
    }
}
///
abstract class VideoBackend {
	protected {
        string[] _extensions;
        int _majorVersion;
        int _minorVersion;
        int _maxColorAttachments;
    }
    ///
    bool supportsExtension(string extension);
	///
	void reload();
	///
	debug void debugCheck();
	///
	void runtimeCheck();
	///
	bool runtimeCheckNothrow() nothrow;
	///
	int getMajorVersion() pure nothrow const;
	///
	int getMinorVersion() pure nothrow const;
	///
	const(char)[] getVersionString();
	///
	const(char)[] getVendorString();
	///
	Vendor getVendor();
	///
	const(char)[] getGraphicsEngineString();
	///
	const(char)[] getGLSLVersionString();
	///
	string[] getExtensions() pure nothrow;
	///
	int maxColorAttachments() pure nothrow const;
	///
	void setActiveTexture(int texture_id);
	///
	void resizeViewport();
	///
	void clear();
	///
	void clearColor(float r, float g, float b, float a);
	/////
	//void clearColor(ubyte r, ubyte g, ubyte b, ubyte a);
	///
	void swapBuffers();
}