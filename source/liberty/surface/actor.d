module liberty.surface.actor;

import liberty.logger;
import liberty.surface.impl;
import liberty.surface.ui.widget;

/**
 *
**/
abstract class Actor2D : Widget {
  /**
   *
  **/
  this(string id, Surface surface) {
    super(id, surface);
  }
}

/**
 *
**/
abstract class UniqueActor2D : Actor2D {
  private static bool hasInstance;
  /**
   *
  **/
  this(string id, Surface surface) {
    if (this.hasInstance) {
      Logger.error(
        "Cannot have multiple instances", 
        typeof(this).stringof
      );
    }
    super(id, surface);
    this.hasInstance = true;
  }
}