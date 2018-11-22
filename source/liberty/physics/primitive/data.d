/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/physics/primitive/data.d)
 * Documentation:
 * Coverage:
**/
module liberty.physics.primitive.data;

struct CollisionData {
  bool Collides;
  float Distance;

  this(bool collides, float distance) {
    Collides = collides;
    Distance = distance;
  }
}
