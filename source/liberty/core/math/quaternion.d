/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:			    $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/math/quaternion.d, _quaternion.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.math.quaternion;
import liberty.core.math.vector : Vector;
import liberty.core.math.matrix : Matrix;
import liberty.core.math.traits : isMatrixInstance;
///
struct Quaternion(T) {
	///
	alias type = T;
	union {
		Vector!(T, 4u) v;
		struct {
			T x, y, z, w;
		}
	}
	/// Constructs a Quaternion from a value.
	this(U)(U x) pure nothrow if (isAssignable!U) {
		opAssign!U(x);
	}
	/// Constructs a Quaternion from coordinates.
	this(T qw, T qx, T qy, T qz) pure nothrow {
		x = qx;
		y = qy;
		z = qz;
		w = qw;
	}
	/// Constructs a Quaternion from axis + angle.
	static Quaternion fromAxis(Vector!(T, 3) axis, T angle) pure nothrow {
		import liberty.core.math.functions : sin, cos;
		Quaternion q = void;
		axis.normalize();
		T cos_a = cos(angle / 2);
		T sin_a = sin(angle / 2);
		q.x = sin_a * axis.x;
		q.y = sin_a * axis.y;
		q.z = sin_a * axis.z;
		q.w = cos_a;
		return q;
	}
	/// Constructs a Quaternion from Euler angles.
	static Quaternion fromEulerAngles(T roll, T pitch, T yaw) pure nothrow {
		import liberty.core.math.functions : sin, cos;
		Quaternion q = void;
		T sinPitch = sin(pitch / 2);
		T cosPitch = cos(pitch / 2);
		T sinYaw = sin(yaw / 2);
		T cosYaw = cos(yaw / 2);
		T sinRoll = sin(roll / 2);
		T cosRoll = cos(roll / 2);
		T cosPitchCosYaw = cosPitch * cosYaw;
		T sinPitchSinYaw = sinPitch * sinYaw;
		q.x = sinRoll * cosPitchCosYaw    - cosRoll * sinPitchSinYaw;
		q.y = cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw;
		q.z = cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw;
		q.w = cosRoll * cosPitchCosYaw    + sinRoll * sinPitchSinYaw;
		return q;
	}
	/// Converts a quaternion to Euler angles.
	Vector!(T, 3) toEulerAngles() pure nothrow const {
		import liberty.core.math.functions : atan2, sqrt, PI;
		Matrix!(T, 3) m = cast(Matrix!(T, 3))(this);
		T pitch, yaw, roll;
		T s = sqrt(m.c[0][0] * m.c[0][0] + m.c[1][0] * m.c[1][0]);
		if (s > T.epsilon) {
			pitch = - atan2(m.c[2][0], s);
			yaw = atan2(m.c[1][0], m.c[0][0]);
			roll = atan2(m.c[2][1], m.c[2][2]);
		} else  {
			pitch = m.c[2][0] < 0.0f ? PI /2 : -PI / 2;
			yaw = -atan2(m.c[0][1], m.c[1][1]);
			roll = 0.0f;
		}
		return Vector!(T, 3)(roll, pitch, yaw);
	}
	/// Assign from another Quaternion.
	ref Quaternion opAssign(U)(U u) pure nothrow if (isQuaternionInstance!U && is(U._T : T)) {
		v = u.v;
		return this;
	}
	/// Assign from a vector of 4 elements.
	ref Quaternion opAssign(U)(U u) pure nothrow if (is(U : Vector!(T, 4u))) {
		v = u;
		return this;
	}
	/// Converts to a string.
	string toString() const nothrow {
		import std.string : format;
		try {
			return format("%s", v);
		} catch (Exception e) {
			assert(0);
		}
	}
	/// Normalizes a quaternion.
	void normalize() pure nothrow {
		v.normalize();
	}
	/// Returns normalized quaternion.
	Quaternion normalized() pure nothrow const {
		Quaternion ret = void;
		ret.v = v.normalized();
		return ret;
	}
	/// Inverses a quaternion in-place.
	void inverse() pure nothrow {
		x = -x;
		y = -y;
		z = -z;
	}
	/// Returns inverse of quaternion.
	Quaternion inversed() pure nothrow const {
		Quaternion ret = void;
		ret.v = v;
		ret.inverse();
		return ret;
	}
	///
	ref Quaternion opOpAssign(string op, U)(U q) pure nothrow if (is(U : Quaternion) && (op == "*")) {
		T nx = w * q.x + x * q.w + y * q.z - z * q.y,
		ny = w * q.y + y * q.w + z * q.x - x * q.z,
		nz = w * q.z + z * q.w + x * q.y - y * q.x,
		nw = w * q.w - x * q.x - y * q.y - z * q.z;
		x = nx;
		y = ny;
		z = nz;
		w = nw;
		return this;
	}
	///
	ref Quaternion opOpAssign(string op, U)(U operand) pure nothrow if (isConvertible!U) {
		Quaternion conv = operand;
		return opOpAssign!op(conv);
	}
	///
	Quaternion opBinary(string op, U)(U operand) pure nothrow const if (is(U: Quaternion) || (isConvertible!U)) {
		Quaternion temp = this;
		return temp.opOpAssign!op(operand);
	}
	/// Compare two Quaternions.
	bool opEquals(U)(U other) pure const if (is(U : Quaternion)) {
		return v == other.v;
	}
	/// Compare Quaternion and other types.
	bool opEquals(U)(U other) pure nothrow const if (isConvertible!U) {
		Quaternion conv = other;
		return opEquals(conv);
	}
	/// Convert to a 3x3 rotation matrix.
	U opCast(U)() pure nothrow const if (isMatrixInstance!U && is(U.type : type) && (U.rowCount == 3) && (U.columnCount == 3)) {
		T norm = x*x + y*y + z*z + w*w;
		T s = (norm > 0) ? 2 / norm : 0;
		T xx = x * x * s, xy = x * y * s, xz = x * z * s, xw = x * w * s,
		yy = y * y * s, yz = y * z * s, yw = y * w * s,
		zz = z * z * s, zw = z * w * s;
		return Matrix!(U.type, 3)(1 - (yy + zz), (xy - zw), (xz + yw), (xy + zw), 1 - (xx + zz), (yz - xw), (xz - yw), (yz + xw), 1 - (xx + yy));
	}
	/// Converts a to a 4x4 rotation matrix.
	U opCast(U)() pure nothrow const if (isMatrixInstance!U && is(U.type : type) && (U.rowCount == 4) && (U.columnCount == 4)) {
		auto m3 = cast(Matrix!(U.type, 3))(this);
		return cast(U)(m3);
	}
	///
	static Quaternion identity() pure nothrow {
		Quaternion q = void;
		q.x = q.y = q.z = 0;
		q.w = 1;
		return q;
	}

  import liberty.core.math.vector : Vector3F;

  static if (is(T == float)) {
    Quaternion mul(Vector3F r) {
      float w_ = -x * r.x - y * r.y - z * r.z;
      float x_ =  w * r.x + y * r.z - z * r.y;
      float y_ =  w * r.y + z * r.x - x * r.z;
      float z_ =  w * r.z + x * r.y - y * r.x;
      
      return Quaternion(x_, y_, z_, w_);
    }
  }

	private enum bool isAssignable(T) = is(typeof({ T x; Quaternion v = x; }()));
	private enum bool isConvertible(T) = (!is(T : Quaternion)) && isAssignable!T;
}
///
alias QuaternionF = Quaternion!float;
///
alias QuaternionD = Quaternion!double;
/// Returns linear interpolation for quaternions.
Quaternion!T lerp(T)(Quaternion!T a, Quaternion!T b, float t) pure nothrow {
	Quaternion!T ret;
	ret.v = funcs.lerp(a.v, b.v, t);
	return ret;
}
/// Returns nlerp of quaternions.
Quaternion!T nlerp(T)(Quaternion!T a, Quaternion!T b, float t) pure nothrow
in {
	assert(t >= 0 && t <= 1);
} do {
	Quaternion!T ret;
	ret.v = funcs.lerp(a.v, b.v, t);
	ret.v.normalize();
	return ret;
}
/// Returns slerp of quaternions.
Quaternion!T slerp(T)(Quaternion!T a, Quaternion!T b, T t) pure nothrow
in {
	assert(t >= 0 && t <= 1);
} do {
	Quaternion!T ret;
	T dotProduct = dot(a.v, b.v);
	if (dotProduct < 0) {
		b.v *= -1;
		dotProduct = dot(a.v, b.v);
	}
	immutable T threshold = 10 * T.epsilon;
	if ((1 - dotProduct) > threshold) {
		return lerp(a, b, t);
	}
	T theta_0 = funcs.safeAcos(dotProduct);
	T theta = theta_0 * t;
	vec3!T v2 = dot(b.v, a.v * dotProduct);
	v2.normalize();
	ret.v = dot(b.v, a.v * dotProduct);
	ret.v.normalize();
	ret.v = a.v * cos(theta) + ret.v * sin(theta);
	return ret;
}