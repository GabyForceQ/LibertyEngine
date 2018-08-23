/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/objects/actor/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.objects.actor.impl;

import liberty.core.logger.manager : Logger;
import liberty.world.objects.node.impl : WorldObject;

/**
 * An actor has action mapping implemented.
**/
abstract class Actor : WorldObject {
  /**
   *
  **/
  this(string id, WorldObject parent) {
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
    if (this.hasInstance) {
      Logger.self.error(
        "Cannot have multiple instances", 
        typeof(this).stringof
      );
    }
    super(id, parent);
    this.hasInstance = true;
  }
}