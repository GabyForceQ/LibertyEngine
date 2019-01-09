/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.constants;

import liberty.math.vector;

enum {
  /**
   * The default value of the exponential height fog.
  **/
  WORLD_DEFAULT_EXP_HEIGHT_FOG_COLOR = Vector3F(0.6f, 0.6f, 0.6f),

  /**
   * The default value of the kill-z area.
  **/
  WORLD_DEFUALT_KILL_Z = -10,

  /**
   * No kill-z area.
  **/
  WORLD_NO_KILL_Z = int.max
}