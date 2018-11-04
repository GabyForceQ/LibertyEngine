/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/security/types.d)
 * Documentation:
 * Coverage:
**/
module liberty.security.types;

import liberty.security.constants : SecureLevel;

/**
 *
**/
struct Crypted(T) {

  /**
   *
  **/
  alias type = T;

  /**
   *
  **/
  alias value this;

  private {
    T _value;
    T _cryptedKey;
    SecureLevel _secureLevel;
  }

  /**
   *
  **/
  this(T value, SecureLevel secure_level = SecureLevel.Level0) pure nothrow {
    _secureLevel = secure_level;
    _value = value;
    final switch (_secureLevel) with (SecureLevel) {
      case Level0:
      case Level1:
      case Level2:
      case Level3:
        generateRandomKey();
        cryptWithKey();
        break;
      case Custom:
        break;
    }
  }

  /**
   *
  **/
  void setValue(T value) pure nothrow {
  }

  /**
   *
  **/
  T getValue() pure nothrow const {
    return _value - _cryptedKey;
  }

  private void generateRandomKey() nothrow {
    import std.random : uniform, Random;
    auto rnd = Random(73);
    _cryptedKey = uniform!T(rnd);
  }

  private void cryptWithKey() pure nothrow {
    _value += _cryptedKey;
  }

  private void decryptWithKey() pure nothrow {
    _value -= _cryptedKey;
  }
}