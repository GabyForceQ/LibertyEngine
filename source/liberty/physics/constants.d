/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/physics/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.physics.constants;

/**
 * Type of force or torque that can be applied on a RigidBody
**/
enum ForceMode : ubyte {
  FORCE,
  IMPULSE,
  VELOCITY,
  ACCELERATION
}

/**
 * Type of force that can be applied on a RigidBody at an arbitrary point
**/
enum PointForceMode : ubyte {
  FORCE,
  IMPULSE
}
