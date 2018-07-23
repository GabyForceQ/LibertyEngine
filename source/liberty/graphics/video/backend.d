/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/video/backend.d, _backend.d)
 * Documentation:
 * Coverage:
 */
// TODO: Window background transparency.
module liberty.graphics.video.backend;
import liberty.graphics.engine : Vendor;
import liberty.core.utils.meta : ExceptionConstructor;
///
class UnsupportedVideoFeatureException : Exception {
    
	mixin(ExceptionConstructor);

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
    bool supportsExtension(string extension) pure nothrow @safe @nogc;
	///
	void reload() @trusted;
	///
	debug void debugCheck() nothrow @trusted;
	///
	void runtimeCheck() @trusted;
	///
	bool runtimeCheckNothrow() nothrow;
	///
	int majorVersion() pure nothrow const @safe @nogc @property;
	///
	int minorVersion() pure nothrow const @safe @nogc @property;
	///
	const(char)[] versionString() @safe;
	///
	const(char)[] vendorString() @safe;
	///
	Vendor vendor() @safe;
	///
	const(char)[] graphicsEngineString() @safe;
	///
	const(char)[] glslVersionString() @safe;
	///
	string[] extensions() pure nothrow @safe @nogc;
	///
	int maxColorAttachments() pure nothrow const @safe @nogc @property;
	///
	void activeTexture(int texture_id) @trusted @property;
	///
	void resizeViewport() @trusted;
	///
	void clear() @trusted;
	///
	void clearColor(float r, float g, float b, float a) @trusted;
	///
	void swapBuffers() @trusted;
}