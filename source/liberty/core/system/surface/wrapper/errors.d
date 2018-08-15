module liberty.core.system.surface.wrapper.errors;

import liberty.core.logger.meta : ExceptionConstructor;

/**
 * A failing Surface function should <b>always</b> throw a $(D SurfaceException).
**/
final class SurfaceException : Exception {
  mixin(ExceptionConstructor);
}

/**
 *
**/
enum SurfaceErrors : string {
  /**
   *
  **/
  FailedToCreateRGBSurface = "Failed to create the RGB surface",

  /**
   *
  **/
  FailedToConvertSurface = "Failed to convert the surface to the new format",

  /**
   *
  **/
  FailedToLockSurface = "Failed to lock the surface",

  /**
   *
  **/
  FailedToUnlockSurface = "Failed to unlock the surface",

  /**
   *
  **/
  FailedToBlitSurface = "Failed to blit surface",

  /**
   *
  **/
  FailedToBlitScaled = "Failed to blit scaled",

  /**
   *
  **/
  FailedToSetColorKey = "Failed to set color key"
}