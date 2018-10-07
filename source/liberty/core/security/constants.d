/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/security/constants.d, _constants.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - Is it char[] ok? Or it should be byte[].
 *  - SecureLevel.Custom
**/
module liberty.core.security.constants;

/**
 *
**/
enum SecureLevel: ubyte {
  /**
   * The key is initialized once when program executes.
  **/
  Level0 = 0x00,

  /**
   * The key is changed when value is initialized. 
   * It inherits from Level0.
  **/
  Level1 = 0x01,
  
  /**
   * The key is changed every frame. 
   * It inherits from Level1.
  **/
  Level2 = 0x02,
  
  /**
   * The key is changed every tick. 
   * Inherits Level2.
   * The most secure level.
   * It decreases CPU performance drastically.
   * Recommended when storing money or similar things.
  **/
  Level3 = 0x03,
  
  /**
   * The key is changed when developer wants.
   * To use this Level developer should create some rules.
  **/
  Custom = 0xFF
}