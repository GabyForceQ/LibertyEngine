/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.math.shapes;
import std.math;
import std.traits;
import crystal.math.vector;
import crystal.math.box;
///
struct Segment(T, int N) if (N == 2 || N == 3) {
	///
	alias PointType = Vector!(T, N);
	///
	PointType a, b;
	///
	static if (N == 3 && isFloatingPoint!T) {
		///
		bool intersect(Plane!T plane, out PointType intersection, out T progress) pure nothrow const @safe @nogc {
			PointType dir = b - a;
			T dp = dot(plane.n, dir);
			if (abs(dp) < T.epsilon) {
				progress = T.infinity;
				return false;
			}
			progress = -(dot(plane.n, a) - plane.d) / dp;
			intersection = progress * dir + a;
			return progress >= 0 && progress <= 1;
		}
	}
}
///
alias Segment2I = Segment!(int, 2);
///
alias Segment3I = Segment!(int, 3);
///
alias Segment2F = Segment!(float, 2);
///
alias Segment3F = Segment!(float, 3);
///
alias Segment2D = Segment!(double, 2);
///
alias Segment3D = Segment!(double, 3);
///
struct Triangle(T, int N) if (N == 2 || N == 3) {
	///
	alias PointType = Vector!(T, N);
	///
	PointType a, b, c;
	static if (N == 2) {
		/// Returns area of a 2D triangle.
		T area() pure nothrow const @safe @nogc {
			return abs(signedArea());
		}
		/// Returns signed area of a 2D triangle.
		T signedArea() pure nothrow const @safe @nogc {
			return ((b.x * a.y - a.x * b.y) + (c.x * b.y - b.x * c.y) + (a.x * c.y - c.x * a.y)) / 2;
		}
	}
	static if (N == 3 && isFloatingPoint!T) {
		/// Returns triangle normal.
		Vector!(T, 3) computeNormal() pure nothrow const @safe @nogc {
			return cross(b - a, c - a).normalized();
		}
	}
}
///
alias Triangle2I = Triangle!(int, 2);
///
alias Triangle3I = Triangle!(int, 3);
///
alias Triangle2F = Triangle!(float, 2);
///
alias Triangle3F = Triangle!(float, 3);
///
alias Triangle2D = Triangle!(double, 2);
///
alias Triangle3D = Triangle!(double, 3);
///
struct Sphere(T, int N) if (N == 2 || N == 3) {
	///
	alias PointType = Vector!(T, N);
	///
	PointType center;
	///
	T radius;
	///
	this(in PointType center_, T radius_) pure nothrow @safe @nogc {
		center = center_;
		radius = radius_;
	}
	///
	bool contains(in Sphere s) pure nothrow const @safe @nogc {
		if (s.radius > radius) {
			return false;
		}
		T innerRadius = radius - s.radius;
		return squaredDistanceTo(s.center) < innerRadius * innerRadius;
	}
	///
	T squaredDistanceTo(PointType p) pure nothrow const @safe @nogc {
		return center.squaredDistanceTo(p);
	}
	///
	bool intersects(Sphere s) pure nothrow const @safe @nogc {
		T outerRadius = radius + s.radius;
		return squaredDistanceTo(s.center) < outerRadius * outerRadius;
	}
	static if (isFloatingPoint!T) {
		///
		T distanceTo(PointType p) pure nothrow const @safe @nogc {
			return center.distanceTo(p);
		}
		static if(N == 2) {
			/// Returns circle area.
			T area() pure nothrow const @safe @nogc {
				return PI * (radius * radius);
			}
		}
	}
}
///
alias Sphere2I = Sphere!(int, 2);
///
alias Sphere3I = Sphere!(int, 3);
///
alias Sphere2F = Sphere!(float, 2);
///
alias Sphere3F = Sphere!(float, 3);
///
alias Sphere2D = Sphere!(double, 2);
///
alias Sphere3D = Sphere!(double, 3);
///
struct Ray(T, int N) if (N == 2 || N == 3) {
	///
	alias PointType = Vector!(T, N);
	///
	PointType origin;
	///
	PointType direction;
	///
	PointType progress(T t) pure const nothrow
	{
		return origin + direction * t;
	}
	static if (N == 3 && isFloatingPoint!T) {
		///
		bool intersect(Triangle!(T, 3) triangle, out T t, out T u, out T v) pure nothrow const @safe @nogc {
			PointType edge1 = triangle.b - triangle.a;
			PointType edge2 = triangle.c - triangle.a;
			PointType pvec = cross(direction, edge2);
			T det = dot(edge1, pvec);
			if (abs(det) < T.epsilon) {
				return false;
			}
			T invDet = 1 / det;
			PointType tvec = origin - triangle.a;
			u = dot(tvec, pvec) * invDet;
			if (u < 0 || u > 1) {
				return false;
			}
			PointType qvec = cross(tvec, edge1);
			v = dot(direction, qvec) * invDet;
			if (v < 0.0 || u + v > 1.0) {
				return false;
			}
			t = dot(edge2, qvec) * invDet;
			return true;
		}
		///
		bool intersect(Plane!T plane, out PointType intersection, out T distance) pure nothrow const @safe @nogc {
			T dp = dot(plane.n, direction);
			if (abs(dp) < T.epsilon) {
				distance = T.infinity;
				return false;
			}
			distance = -(dot(plane.n, origin) - plane.d) / dp;
			intersection = distance * direction + origin;
			return distance >= 0;
		}
	}
}
///
alias Ray2I = Ray!(int, 2);
///
alias Ray3I = Ray!(int, 3);
///
alias Ray2F = Ray!(float, 2);
///
alias Ray3F = Ray!(float, 3);
///
alias Ray2D = Ray!(double, 2);
///
alias Ray3D = Ray!(double, 3);
///
struct Plane(T) if (isFloatingPoint!T) {
	///
	alias type = T;
	///
	Vector3!T n;
	///
	T d;
	///
	this(Vector4!T abcd) pure nothrow @safe @nogc {
		n = Vector3!T(abcd.x, abcd.y, abcd.z).normalized();
		d = abcd.w;
	}
	///
	this(Vector3!T origin, Vector3!T normal) pure nothrow @safe @nogc {
		n = normal.normalized();
		d = -dot(origin, n);
	}
	///
	this(Vector3!T A, Vector3!T B, Vector3!T C) pure nothrow @safe @nogc {
		this(C, cross(B - A, C - A));
	}
	///
	ref Plane opAssign(Plane other) pure nothrow @safe @nogc {
		n = other.n;
		d = other.d;
		return this;
	}
	///
	T signedDistanceTo(Vector3!T point) pure nothrow const @safe @nogc {
		return dot(n, point) + d;
	}
	///
	T distanceTo(Vector3!T point) pure nothrow const @safe @nogc {
		return abs(signedDistanceTo(point));
	}
	///
	bool isFront(Vector3!T point) pure nothrow const @safe @nogc {
		return signedDistanceTo(point) >= 0;
	}
	///
	bool isBack(Vector3!T point) pure nothrow const @safe @nogc {
		return signedDistanceTo(point) < 0;
	}
	///
	bool isOn(Vector3!T point, T epsilon) pure nothrow const @safe @nogc {
		T sd = signedDistanceTo(point);
		return (-epsilon < sd) && (sd < epsilon);
	}
}
///
alias PlaneF = Plane!float;
///
alias PlaneD = Plane!double;
///
enum FrustumSide : ubyte {
	///
	Left = 0x00,
	///
	Right = 0x01,
	///
	Top = 0x02,
	///
	Bottom = 0x03,
	///
	Near = 0x04,
	///
	Far = 0x05
}
///
enum FrustumScope : ubyte {
	/// Object is outside the frustum.
	Outside = 0x00,
	/// Object intersects with the frustum.
	Intersect = 0x01,
	/// Object is inside the frustum.
	Inside = 0x02
}
///
struct Frustum(T) if (isFloatingPoint!T) {
	///
	enum sideCount = 6;
	///
	enum vertexCount = 8;
	///
	alias type = T;
	///
	Plane!T[6] planes;
	/// Create a frustum from 6 planes.
	this(Plane!T left, Plane!T right, Plane!T top, Plane!T bottom, Plane!T near, Plane!T far) pure nothrow @safe @nogc {
		planes[FrustumSide.Left] = left;
		planes[FrustumSide.Right] = right;
		planes[FrustumSide.Top] = top;
		planes[FrustumSide.Bottom] = bottom;
		planes[FrustumSide.Near] = near;
		planes[FrustumSide.Far] = far;
	}
	///
	bool contains(Vector3!T point) pure nothrow const @safe @nogc {
		T distance = 0;
		static foreach (i; 0..sideCount) {
			distance = planes[i].signedDistanceTo(point);
			if (distance < 0) {
				return false;
			}
		}
		return true;
	}
	///
	FrustumScope contains(Sphere!(T, 3) sphere) pure nothrow const @safe @nogc {
		T distance = 0;
		static foreach (i; 0..sideCount) {
			distance = planes[i].signedDistanceTo(sphere.center);
			if(distance < -sphere.radius) {
				return FrustumScope.Outside;
			} else if (distance < sphere.radius) {
				return FrustumScope.Intersect;
			}
		}
		return FrustumScope.Inside;
	}
	///
	int contains(Box3!T box) pure nothrow const @safe @nogc {
		Vector3!T[8] corners;
		int totalIn = 0;
		T x, y, z;
		static foreach (i; 0..2) {
			static foreach (j; 0..2) {
				static foreach (k; 0..2) {
					x = i == 0 ? box.min.x : box.max.x;
					y = j == 0 ? box.min.y : box.max.y;
					z = k == 0 ? box.min.z : box.max.z;
					corners[i * 4 + j * 2 + k] = Vector3!T(x, y, z);
				}
			}
		}
		int inCount = 0, ptIn = 0;
		static foreach (p; 0..sideCount) {
			inCount = vertexCount;
			ptIn = 1;
			static foreach (i; 0..vertexCount) {
				if (planes[p].isBack(corners[i])) {
					ptIn = 0;
					inCount--;
				}
			}
			if (inCount == 0) {
				return FrustumScope.Outside;
			}
			totalIn += ptIn;
		}
		if(totalIn == sideCount) {
			return FrustumScope.Inside;
		}
		return FrustumScope.Intersect;
	}
}
///
alias FrustumF = Frustum!float;
///
alias FrustumD = Frustum!double;
///
enum isSegment(T) = is(T : Segment!U, U...);
///
enum isTriangle(T) = is(T : Triangle!U, U...);
///
enum isSphere(T) = is(T : Sphere!U, U...);
///
enum isRay(T) = is(T : Ray!U, U...);
///
enum isPlane(T) = is(T : Plane!U, U);
///
enum isFrustum(T) = is(T : Frustum!U, U);
///
enum isSegment2D(T) = is(T : Segment!(U, 2), U);
///
enum isTriangle2D(T) = is(T : Triangle!(U, 2), U);
///
enum isSphere2D(T) = is(T : Sphere!(U, 2), U);
///
enum isRay2D(T) = is(T : Ray!(U, 2), U);
///
enum isSegment3D(T) = is(T : Segment!(U, 3), U);
///
enum isTriangle3D(T) = is(T : Triangle!(U, 3), U);
///
enum isSphere3D(T) = is(T : Sphere!(U, 3), U);
///
enum isRay3D(T) = is(T : Ray!(U, 3), U);
///
alias DimensionType(T : Segment!U, U...) = U[0];
///
alias DimensionType(T : Triangle!U, U...) = U[0];
///
alias DimensionType(T : Sphere!U, U...) = U[0];
///
alias DimensionType(T : Ray!U, U...) = U[0];
//
alias DimensionType(T : Plane!U, U) = U;
///
alias DimensionType(T : Frustum!U, U) = U;
///
pure nothrow @safe @nogc unittest {
	static assert (is(DimensionType!Segment2I == int));
	static assert (is(DimensionType!Triangle3F == float));
	static assert (is(DimensionType!Sphere2D == double));
	static assert (is(DimensionType!Ray3F == float));
	static assert (is(DimensionType!PlaneD == double));
	static assert (is(DimensionType!(Frustum!float) == float));
}
