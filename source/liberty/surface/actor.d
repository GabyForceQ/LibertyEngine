module liberty.surface.actor;

import liberty.logger;
import liberty.surface.ui.frame;
import liberty.surface.ui.widget;

/**
 *
**/
abstract class Actor2D : Widget {
  /**
   *
  **/
  this(string id, Frame frame) {
    super(id, frame);
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
  this(string id, Frame frame) {
    if (this.hasInstance) {
      Logger.error(
        "Cannot have multiple instances", 
        typeof(this).stringof
      );
    }
    super(id, frame);
    this.hasInstance = true;
  }
}