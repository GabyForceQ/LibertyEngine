/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/physics/primitive/sphere.d)
 * Documentation:
 * Coverage:
**/
module liberty.physics.primitive.sphere;

import liberty.math.vector;
import liberty.physics.primitive.data;

class SphereCollider {
  private {
    Vector3F center;
    float radius;
  }

  this(Vector3F center, float radius)   {
    this.center = center;
    this.radius = radius;
  }

  Vector3F getCenter()   {
    return center;
  }

  float getRadius()   const {
    return radius;
  }

  CollisionData collideSphere(SphereCollider rhs) {
    const float radius_distance = radius + rhs.radius;
    float center_distance = (cast(Vector3F)rhs.center - cast(Vector3F)center).magnitude;
    return CollisionData(center_distance < radius_distance, center_distance - radius_distance);
  }
}
