/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/imaging/image.d, _image.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.imaging.image;
import derelict.freeimage.freeimage;
import derelict.util.exception;
import std.conv, std.string;
///
class ImageException : Exception {
    ///
    @safe pure nothrow this(string message, string file =__FILE__, size_t line = __LINE__, Throwable next = null) {
        super(message, file, line, next);
    }
}
///
final class Image {
	private bool _libInitialized;
    /// Loads the FreeImage library and logs some information.
    /// Throws: FreeImageException on error.
    this(bool useExternalPlugins = false) {
        try {
            DerelictFI.load();
        } catch (DerelictException e) {
            throw new ImageException(e.msg);
        }
        _libInitialized = true;
    }
	///
    ~this() {
        if (_libInitialized) {
            debug import liberty.core.memory : ensureNotInGC;
            debug ensureNotInGC("FreeImage");
            _libInitialized = false;
        }
    }
	///
    const(char)[] version_() {
        const(char)* versionZ = FreeImage_GetVersion();
        return fromStringz(versionZ);
    }
	///
    const(char)[] copyright_()  {
        const(char)* copyrightZ = FreeImage_GetCopyrightMessage();
        return fromStringz(copyrightZ);
    }
}