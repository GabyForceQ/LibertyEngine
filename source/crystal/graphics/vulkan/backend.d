/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.graphics.vulkan.backend;
version (__Vulkan__) :
import liberty.core.engine;
import liberty.graphics.common.backend : VideoBackend;
/// The one exception type thrown in this wrapper.
/// A failing Vulkan function should <b>always</b> throw an $(D VKException).
class VKException : Exception {
    ///
    @safe pure nothrow this(string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
        super(message, file, line, next);
    }
}
///
final class VKBackend : VideoBackend {

}