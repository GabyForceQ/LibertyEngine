/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.core.securetypes;
///
enum SecureLevel: ubyte {
    /// Crypted Key is initialized once when program executes.
    Level0 = 0x00,
    /// Crypted Key is changed when value is initialized. Inherits Level0.
    Level1 = 0x01,
    /// Crypted Key is changed every frame. Inherits Level1.
    Level2 = 0x02,
    /// Crypted Key is changed every tick. Inherits Level2.
    /// The most secure level but unfortunately it decreases CPU performance.
    /// It drastically decrease CPU performance when used in most declarations.
    /// Recommended for keeping money or similar things.
    Level3 = 0x03,
    /// Crypted Key is changed when developer wants.
    /// To use this Level developer should create some rules.
    Custom = 0xFF
}
///
struct Crypted(T) {
    ///
    alias type = T;
    ///
    alias value this;
    private {
        T _value;
        T _cryptedKey;
        SecureLevel _secureLevel;
    }
    ///
    this(T value, SecureLevel secure_level = SecureLevel.Level0) pure nothrow @nogc @safe @property {
        _secureLevel = secure_level;
        _value = value;
        final switch (_secureLevel) with (SecureLevel) {
            case Level0:
            case Level1:
            case Level2:
            case Level3:
                generateRandomKey;
                cryptWithKey;
                break;
            case Custom:
                break;
        }
    }
    ///
    void value(T value) pure nothrow @nogc @safe @property {
    }
    ///
    T value() pure nothrow const @nogc @safe @property {
        return _value - _cryptedKey;
    }
    private void generateRandomKey() nothrow @nogc @safe {
        import std.random : uniform, Random;
        auto rnd = Random(73);
        _cryptedKey = uniform!T(rnd);
    }
    private void cryptWithKey() pure nothrow @nogc @safe {
        _value += _cryptedKey;
    }
    private void decryptWithKey() pure nothrow @nogc @safe {
        _value -= _cryptedKey;
    }
}
///
char[] encrypt(char[] input, char shift) pure nothrow @safe { // byte?
	auto result = input.dup;
	result[] += shift;
	return result;
}
///
char[] decrypt(char[] input, char shift) pure nothrow @safe { // byte?
	auto result = input.dup;
	result[] -= shift;
	return result;
}