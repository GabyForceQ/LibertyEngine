/**
 * Copyright:       Copyright (C) 2018 Gabrot, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.math.functions;
import std.traits : isIntegral;
version( D_InlineAsm_X86 ) {
    version = AsmX86;
} else version( D_InlineAsm_X86_64 ) {
    version = AsmX86;
}
/// Convert from radians to degrees.
T degrees(T)(T x) pure nothrow @nogc if (!isIntegral!T) {
    return x * (180 / PI);
}
/// Convert from degrees to radians.
T radians(T)(T x) pure nothrow @nogc if (!isIntegral!T) {
    return x * (PI / 180);
}