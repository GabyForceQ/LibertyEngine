/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
// TODO: Window background transparency.
module liberty.graphics.video.backend;
import liberty.graphics.renderer : Vendor;
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
	int majorVersion() pure nothrow const;
	///
	int minorVersion() pure nothrow const;
	///
	const(char)[] versionString();
	///
	const(char)[] vendorString();
	///
	Vendor vendor();
	///
	const(char)[] graphicsEngineString();
	///
	const(char)[] glslVersionString();
	///
	string[] extensions() pure nothrow;
	///
	int maxColorAttachments() pure nothrow const;
	///
	void activeTexture(int texture_id);
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