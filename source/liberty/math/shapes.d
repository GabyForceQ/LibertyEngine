/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:			    $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/math/shapes.d)
 * Documentation:
 * Coverage:
**/
module liberty.math.shapes;

import std.traits : isFloatingPoint;

import liberty.math.vector;
import liberty.math.box;
///
struct Segment(T, int N) if (N == 2 || N == 3) {
	///
	alias PointType = Vector!(T, N);
	///
	PointType a, b;
	///
	static if (N == 3 && isFloatingPoint!T) {
		///
		bool intersect(Plane!T plane, out PointType intersection, out T progress)   const {
			import liberty.math.functions : abs;
			import liberty.math.vector : dot;
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
		T area()   const {
			import liberty.math.functions : abs;
			return abs(signedArea());
		}
		/// Returns signed area of a 2D triangle.
		T signedArea()   const {
			return ((b.x * a.y - a.x * b.y) + (c.x * b.y - b.x * c.y) + (a.x * c.y - c.x * a.y)) / 2;
		}
	}
	static if (N == 3 && isFloatingPoint!T) {
		/// Returns triangle normal.
		Vector!(T, 3) computeNormal()   const {
			import liberty.math.vector : cross;
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
	this(in PointType center_, T radius_)   {
		center = center_;
		radius = radius_;
	}
	///
	bool contains(in Sphere s)   const {
		if (s.radius > radius) {
			return false;
		}
		T innerRadius = radius - s.radius;
		return squaredDistanceTo(s.center) < innerRadius * innerRadius;
	}
	///
	T squaredDistanceTo(PointType p)   const {
		return center.squaredDistanceTo(p);
	}
	///
	bool intersects(Sphere s)   const {
		T outerRadius = radius + s.radius;
		return squaredDistanceTo(s.center) < outerRadius * outerRadius;
	}
	static if (isFloatingPoint!T) {
		///
		T distanceTo(PointType p)   const {
			return center.distanceTo(p);
		}
		static if(N == 2) {
			/// Returns circle area.
			T area()   const {
				import liberty.math.functions : PI;
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
	PointType progress(T t)  const 
	{
		return origin + direction * t;
	}
	static if (N == 3 && isFloatingPoint!T) {
		///
		bool intersect(Triangle!(T, 3) triangle, out T t, out T u, out T v)   const {
			import liberty.math.functions : abs;
			import liberty.math.vector : dot, cross;
			PointType edge1 = triangle.b - triangle.a;
			PointType edge2 = triangle.c - triangle.a;
			PointType pvec = cross(direction, edge2);
			T det = dot(edge1, pvec);
			if (abs(det) < T.epsilon) {
				return false;
			}
			const T invDet = 1 / det;
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
		bool intersect(Plane!T plane, out PointType intersection, out T distance)   const {
			import liberty.math.functions : abs;
			import liberty.math.vector : dot;
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
	Vector!(T, 3) n;
	///
	T d;
	///
	this(Vector!(T, 4) abcd)   {
		n = Vector!(T, 3)(abcd.x, abcd.y, abcd.z).normalized();
		d = abcd.w;
	}
	///
	this(Vector!(T, 3) origin, Vector!(T, 3) normal)   {
		import liberty.math.vector : dot;
		n = normal.normalized();
		d = -dot(origin, n);
	}
	///
	this(Vector!(T, 3) A, Vector!(T, 3) B, Vector!(T, 3) C)   {
		import liberty.math.vector : cross;
		this(C, cross(B - A, C - A));
	}
	///
	ref Plane opAssign(Plane other)   {
		n = other.n;
		d = other.d;
		return this;
	}
	///
	T signedDistanceTo(Vector!(T, 3) point)   const {
		import liberty.math.vector : dot;
		return dot(n, point) + d;
	}
	///
	T distanceTo(Vector!(T, 3) point)   const {
		import liberty.math.functions : abs;
		return abs(signedDistanceTo(point));
	}
	///
	bool isFront(Vector!(T, 3) point)   const {
		return signedDistanceTo(point) >= 0;
	}
	///
	bool isBack(Vector!(T, 3) point)   const {
		return signedDistanceTo(point) < 0;
	}
	///
	bool isOn(Vector!(T, 3) point, T epsilon)   const {
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
	this(Plane!T left, Plane!T right, Plane!T top, Plane!T bottom, Plane!T near, Plane!T far)   {
		planes[FrustumSide.Left] = left;
		planes[FrustumSide.Right] = right;
		planes[FrustumSide.Top] = top;
		planes[FrustumSide.Bottom] = bottom;
		planes[FrustumSide.Near] = near;
		planes[FrustumSide.Far] = far;
	}
	///
	bool contains(Vector!(T, 3) point)   const {
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
	FrustumScope contains(Sphere!(T, 3) sphere)   const {
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
	int contains(Box!(T, 3) box)   const {
		Vector!(T, 3)[8] corners;
		int totalIn = 0;
		T x, y, z;
		static foreach (i; 0..2) {
			static foreach (j; 0..2) {
				static foreach (k; 0..2) {
					x = i == 0 ? box.min.x : box.max.x;
					y = j == 0 ? box.min.y : box.max.y;
					z = k == 0 ? box.min.z : box.max.z;
					corners[i * 4 + j * 2 + k] = Vector!(T, 3)(x, y, z);
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
struct Rect(T) {
	///
	alias type = T;
	///
	T x;
	///
	T y;
	///
	T width;
	///
	T height;
	///
	static const Rect!T defaultData = Rect!T(10, 10, 50, 50);
	///
	this(T x, T y, T width, T height) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
}
///
alias RectI = Rect!int;
///
alias RectF = Rect!float;
///
alias RectD = Rect!double;