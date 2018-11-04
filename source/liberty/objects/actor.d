/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/objects/actor.d)
 * Documentation:
 * Coverage:
**/
module liberty.objects.actor;

import liberty.logger : Logger;
import liberty.objects.node : SceneNode;

/**
 * An actor has action mapping implemented.
**/
abstract class Actor : SceneNode {
  /**
   *
  **/
  this(string id, SceneNode parent) {
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
  this(string id, SceneNode parent) {
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