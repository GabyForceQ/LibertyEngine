/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/skybox/vertex.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.skybox.vertex;

import liberty.graphics.vertex.meta;
import liberty.math.vector;

/**
 *
**/
struct SkyBoxVertex {
  mixin GfxVertexSpec;

  /**
   *
  **/
  Vector3F position;
}