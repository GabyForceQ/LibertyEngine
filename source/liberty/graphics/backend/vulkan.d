/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/backend/vulkan.d, _vulkan.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.backend.vulkan;

version (none):

import liberty.core.logger.meta : ExceptionConstructor;
import liberty.graphics.backend.root : RootBackend;
import liberty.graphics.constants : Vendor;

/**
 * A failing Vulkan function should <b>always</b> throw a $(D VKException).
**/
class VKException : Exception {
  mixin(ExceptionConstructor);
}

/**
 *
**/
final class VKBackend : RootBackend {
  /**
   * Load Vulkan library.
   * Throws $(D VKException) on error.
  **/
  this() @trusted {
  }
}