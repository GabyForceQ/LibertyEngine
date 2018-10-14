/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:			    $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/math/functions.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.math.functions;

public import std.math;
import std.traits : isIntegral, isSigned, isFloatingPoint;

import liberty.core.math.vector : Vector2F, Vector3F;

version (D_InlineAsm_X86) {
  version = AsmX86;
} else version (D_InlineAsm_X86_64) {
  version = AsmX86;
}

/**
 * Convert from radians to degrees.
**/
T degrees(T)(T x) pure nothrow if (!isIntegral!T) {
  return x * (180 / PI);
}

/**
 * Convert from degrees to radians.
**/
T radians(T)(T x) pure nothrow if (!isIntegral!T) {
  return x * (PI / 180);
}

/**
 * Linear interpolation.
**/
S lerp(S, T)(S a, S b, T t) pure nothrow if (is(typeof(t * b + (1 - t) * a) : S)) {
  return t * b + (1 - t) * a;
}

/**
 * Clamp x in [min, max].
**/
T clamp(T)(T x, T min, T max) pure nothrow {
  if (x < min) {
    return min;
  } else if (x > max) {
    return max;
  }
  return x;
}

/**
 * Integer truncation.
**/
long ltrunc(real x) nothrow {
  return cast(long)(trunc(x));
}

/**
 * Integer flooring.
**/
long lfloor(real x) nothrow {
  return cast(long)(floor(x));
}

/**
 * Returns fractional part of x.
**/
T fract(T)(real x) nothrow {
  return x - lfloor(x);
}

/**
 * Safe asin. Input clamped to [-1, 1].
**/
T safeAsin(T)(T x) pure nothrow {
	return asin(clamp!T(x, -1, 1));
}

/**
 * Safe acos. Input clamped to [-1, 1].
**/
T safeAcos(T)(T x) pure nothrow {
	return acos(clamp!T(x, -1, 1));
}

/**
 * If x < edge => 0.0 is returned, otherwise 1.0 is returned.
**/
T step(T)(T edge, T x) pure nothrow {
	return (x < edge) ? 0 : 1;
}

/**
 *
**/
T smoothStep(T)(T a, T b, T t) pure nothrow {
	if (t <= a) {
		return 0;
	} else if (t >= b) {
		return 1;
	}
	T x = (t - a) / (b - a);
	return x * x * (3 - 2 * x);
}

/**
 * Returns true of i is a power of 2.
**/
bool isPowerOf2(T)(T i) pure nothrow if (isIntegral!T)
in {
	assert(i >= 0);
} do {
	return (i != 0) && ((i & (i - 1)) == 0);
}

/**
 * Integer log2.
**/
int ilog2(T)(T i) nothrow if (isIntegral!T)
in {
	assert(i > 0);
	assert(isPowerOf2(i));
} do {
	int result;
	while (i > 1) {
		i = i / 2;
		result++;
	}
	return result;
}

/**
 * Computes next power of 2.
**/
int nextPowerOf2(int i) pure nothrow
out(result) {
	assert(isPowerOf2(result));
} do {
	int v = i - 1;
	v |= v >> 1;
	v |= v >> 2;
	v |= v >> 4;
	v |= v >> 8;
	v |= v >> 16;
	v++;
	return v;
}

/**
 * Computes next power of 2.
**/
long nextPowerOf2(long i) pure nothrow
out(result) {
	assert(isPowerOf2(result));
} do {
	long v = i - 1;
	v |= v >> 1;
	v |= v >> 2;
	v |= v >> 4;
	v |= v >> 8;
	v |= v >> 16;
	v |= v >> 32;
	v++;
	return v;
}

/**
 * Computes sin(x)/x accurately.
**/
T sinOverX(T)(T x) pure nothrow {
	if (1 + x * x == 1) {
		return 1;
	}
	return sin(x) / x;
}

/**
 * Signed integer modulo a/b where the remainder is guaranteed to be in [0..b], even if a is negative.
 * Only supports positive dividers.
**/
T moduloWrap(T)(T a, T b) pure nothrow if (isSigned!T)
in {
	assert(b > 0);
} do {
	T x;
	if (a >= 0) {
		a = a % b;
	} else {
		const rem = a % b;
		x = (rem == 0) ? 0 : (-rem + b);
	}
	assert(x >= 0 && x < b);
	return x;
}

/**
 *
**/
pure nothrow unittest {
	assert(nextPowerOf2(3) == 4);
	assert(nextPowerOf2(21) == 32);
	assert(nextPowerOf2(1000) == 1024);
}

/**
 * SSE approximation of reciprocal square root.
**/
T inverseSqrt(T)(T x) pure nothrow if (isFloatingPoint!T) {
	version(AsmX86) {
		static if (is(T == float)) {
			float result;
			asm pure nothrow {
				movss XMM0, x;
				rsqrtss XMM0, XMM0;
				movss result, XMM0;
			}
			return result;
		} else {
			return 1 / sqrt(x);
		}
	} else {
		return 1 / sqrt(x);
	}
}

/**
 *
**/
pure nothrow unittest {
	assert (abs(inverseSqrt!float(1) - 1) < 1e-3 );
	assert (abs(inverseSqrt!double(1) - 1) < 1e-3 );
}

/**
 *
**/
float barryCentric(Vector3F p1, Vector3F p2, Vector3F p3, Vector2F pos) {
	const float det = (p2.z - p3.z) * (p1.x - p3.x) + (p3.x - p2.x) * (p1.z - p3.z);
	const float l1 = ((p2.z - p3.z) * (pos.x - p3.x) + (p3.x - p2.x) * (pos.y - p3.z)) / det;
	const float l2 = ((p3.z - p1.z) * (pos.x - p3.x) + (p1.x - p3.x) * (pos.y - p3.z)) / det;
	const float l3 = 1.0f - l1 - l2;
	return l1 * p1.y + l2 * p2.y + l3 * p3.y;
}