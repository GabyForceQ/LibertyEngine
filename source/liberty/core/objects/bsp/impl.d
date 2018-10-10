/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/bsp/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.bsp.impl;

import liberty.core.objects.entity : Entity;
import liberty.core.objects.node : WorldObject;

/**
 *
**/
abstract class BSPVolume : Entity {
  /**
   *
  **/
  this(string id, WorldObject parent) {
    super(id, parent);
  }

  /**
   *
  **/
  override void render() {}
}
