/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/vulkan/backend.d, _backend.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.vulkan.backend;
version (__Vulkan__) :
import liberty.graphics.common.backend : VideoBackend;
import liberty.core.utils.meta : ExceptionConstructor;

/// The one exception type thrown in this wrapper.
/// A failing Vulkan function should <b>always</b> throw an $(D VKException).
class VKException : Exception {
    
    mixin(ExceptionConstructor);

}
///
final class VKBackend : VideoBackend {

}