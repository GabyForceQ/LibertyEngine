/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/actor.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.actor;

import liberty.core.logger : Logger;
import liberty.core.objects.node : WorldObject;

/**
 * An actor has action mapping implemented.
**/
abstract class Actor : WorldObject {
  /**
   *
  **/
  this(string id, WorldObject parent) {
    type = "core";
    super(id, parent);
  }
}

/**
 *
**/
abstract class UniqueActor : Actor {
  private static bool hasInstance;
  /**
   *
  **/
  this(string id, WorldObject parent) {
    type = "core";

    if (this.hasInstance) {
      Logger.error(
        "Cannot have multiple instances", 
        typeof(this).stringof
      );
    }
    super(id, parent);
    this.hasInstance = true;
  }
}