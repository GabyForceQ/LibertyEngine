/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/window/wrapper/errors.d, _errors.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.window.wrapper.errors;

import liberty.core.logger.meta : ExceptionConstructor;

/**
 * A failing Window function should <b>always</b> throw a $(D WindowException).
**/
final class WindowException : Exception {
  mixin(ExceptionConstructor);
}

/**
 *
**/
enum WindowErrors : string {
  /**
   *
  **/
  FailedToCreateWindow = "Failed to create window",

  /**
   *
  **/
  FiledToAccessWindow = "Failed to access window. Window does not exist"
}