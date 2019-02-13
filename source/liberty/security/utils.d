/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/security/utils.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - Is it char[] ok? Or it should be byte[].
**/
module liberty.security.utils;

/**
 *
**/
char[] encrypt(char[] input, char shift)   { // byte?
  auto result = input.dup;
  result[] += shift;
  return result;
}

/**
 *
**/
char[] decrypt(char[] input, char shift)   { // byte?
  auto result = input.dup;
  result[] -= shift;
  return result;
}
