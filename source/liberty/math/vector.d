/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/math/vector.d)
 * Documentation:
 * Coverage:
**/
module liberty.math.vector;
import std.traits : isFloatingPoint;
import liberty.math.traits : isVector;
import liberty.math.quaternion : Quaternion;

import liberty.math.functions;

/// T = type of elements.
/// N = number of elements (2, 3, 4).
struct Vector(T, ubyte N) if (N >= 2 && N <= 4) {
    ///
    alias size = N;
    ///
    alias type = T;
	/// Fields definition.
    union {
        ///
        T[N] v;
	    ///
        struct {
            ///
            T x;
            ///
            alias r = x;
            ///
            alias p = y;
            ///
            T y;
            ///
            alias g = y;
            ///
            alias q = y;
            static if (N >= 3) {
                ///
                T z;
                ///
                alias b = z;
                ///
                alias s = z;
            }
            static if (N == 4) {
                ///
                T w;
                ///
                alias a = w;
                ///
                alias t = w;
            }
        }
    }
    static if (N == 2 && is(T == float) || is(T == int)) {
        /// Vector2 with values of 0.
        static const Vector!(T, 2) zero = Vector!(T, 2)(0, 0);
        /// Vector2 with values of 1.
        static const Vector!(T, 2) one = Vector!(T, 2)(1, 1);
        /// Vector2 pointing up.
        static const Vector!(T, 2) up = Vector!(T, 2)(0, -1);
        /// Vector2 pointing right.
        static const Vector!(T, 2) right = Vector!(T, 2)(1, 0);
        /// Vector2 pointing down.
        static const Vector!(T, 2) down = Vector!(T, 2)(0, 1);
        /// Vector2 pointing left.
        static const Vector!(T, 2) left = Vector!(T, 2)(-1, 0);
        ///
        unittest {
            assert(Vector!(T, 2).zero == Vector!(T, 2)(0, 0));
            assert(Vector!(T, 2).one == Vector!(T, 2)(1, 1));
            assert(Vector!(T, 2).up == Vector!(T, 2)(0, 1));
            assert(Vector!(T, 2).right == Vector!(T, 2)(1, 0));
            assert(Vector!(T, 2).down == Vector!(T, 2)(0, -1));
            assert(Vector!(T, 2).left == Vector!(T, 2)(-1, 0));
        }
    } else static if (N == 3 && is(T == float)) {
        /// Vector3 with values of 0.
        static const Vector!(T, 3) zero = Vector!(T, 3)(0, 0, 0);
        /// Vector3 with values of 1.
        static const Vector!(T, 3) one = Vector!(T, 3)(1, 1, 1);
        /// Vector3 pointing up.
        static const Vector!(T, 3) up = Vector!(T, 3)(0, 1, 0);
        /// Vector3 pointing right.
        static const Vector!(T, 3) right = Vector!(T, 3)(1, 0, 0);
        /// Vector3 pointing down.
        static const Vector!(T, 3) down = Vector!(T, 3)(0, -1, 0);
        /// Vector3 pointing left.
        static const Vector!(T, 3) left = Vector!(T, 3)(-1, 0, 0);
        /// Vector3 pointing forward.
        static const Vector!(T, 3) forward = Vector!(T, 3)(0, 0, 1);
        /// Vector3 pointing backward.
        static const Vector!(T, 3) backward = Vector!(T, 3)(0, 0, -1);
        ///
        unittest {
            assert(Vector!(T, 3).zero == Vector!(T, 3)(0, 0, 0));
            assert(Vector!(T, 3).one == Vector!(T, 3)(1, 1, 1));
            assert(Vector!(T, 3).up == Vector!(T, 3)(0, 1, 0));
            assert(Vector!(T, 3).down == Vector!(T, 3)(0, -1, 0));
            assert(Vector!(T, 3).right == Vector!(T, 3)(1, 0, 0));
            assert(Vector!(T, 3).left == Vector!(T, 3)(-1, 0, 0));
            assert(Vector!(T, 3).forward == Vector!(T, 3)(0, 0, 1));
            assert(Vector!(T, 3).backward == Vector!(T, 3)(0, 0, -1));
        }
    }
    ///
    this(U...)(U values) pure nothrow {
        import std.meta : allSatisfy;
        import std.traits : isAssignable;
        enum bool isAsgn(U) = isAssignable!(T, U);
        static if ((U.length == N) && allSatisfy!(isAsgn, U)) {
            static foreach (i, x; values) {
                v[i] = x;
            }
        } /*else static if ((U.length == 2) && is(U[0] : Vector2!T) && is(U[1] : T) && is(this == Vector3!T)) {
            v[0] = U[0].x;
			v[1] = U[0].y;
			v[2] = U[1];
        }*/
        else static if ((U.length == 1) && isAsgn!U && (!is(U[0] : Vector))) {
            v[] = values[0];
        } else static if (U.length == 1 && is(U[0] : T[])) {
            v = values[0];
        } else static if (U.length == 0) {
            v[] = cast(T)0;
        } else {
            static assert(false, "Cannot create a vector from given arguments!");
        }
    }
    ///
    pure nothrow unittest {
        auto v1 = Vector2I(4, 2);
        assert (v1.v == [4, 2]);
        auto v2 = Vector2I(5);
        assert (v2.v == [5, 5]);
        auto v3 = Vector3I([1, 2, 3]);
        assert (v3.v == [1, 2, 3]);
        auto v4 = Vector4I();
        assert (v4.v == [0, 0, 0, 0]);
        auto v5 = Vector3I(Vector2I(1, 3), 5);
        assert (v5.v == [1, 3, 5]);
        auto v6 = Vector4I(Vector3I(-2, 1, 3), 5);
        assert (v6.v == [-2, 1, 3, 5]);
        auto v7 = Vector4I(Vector2I(1, 3), Vector2I(5, 4));
        assert (v7.v == [1, 3, 5, 4]);
    }
    // TODO: remove this constructors
	static if (N == 3) {
		this(Vector2!T xy, T z) { v[0] = xy.x; v[1] = xy.y; v[2] = z; }
	} else static if (N == 4) {
		this(Vector2!T xy, Vector2!T zw) { v[0] = xy.x; v[1] = xy.y; v[2] = zw.x; v[3] = zw.y; }
		this(Vector3!T xyz, T w) { v[0] = xyz.x; v[1] = xyz.y; v[2] = xyz.z; v[3] = w; }
	}
    /// Assign a Vector from a compatible type.
    ref Vector opAssign(U)(U rhs) pure nothrow {
        static if (is(U : Vector)) {
            static foreach (i; 0..N) {
                v[i] = rhs.v[i];
            }
        } else static if (is(U : T)) {
            v[] = rhs;
        } else static if (is(U : T[])) {
            assert (rhs.length == N, "Static array's lenght must be equal to vector's length!");
            v = rhs;
        } else {
            static assert (0, "Cannot assign a variable of type " ~ U.stringof ~ " within a variable of type " ~ Vector.stringof);
        }
        return this;
    }
    ///
    pure nothrow unittest {
        auto v1 = Vector3I();
        v1 = Vector3I(7, 8, 9);
        assert (v1.v == [7, 8, 9]);
        auto v2 = Vector2F();
        v2 = 3.4f;
        assert (v2.v == [3.4f, 3.4f]);
        auto v3 = Vector4I();
        v3 = [1, 3, 5, -6];
        assert (v3.v == [1, 3, 5, -6]);
    }
    ///
    bool opEquals(U)(U rhs) pure nothrow const {
        static if (is(U : Vector)) {
            static foreach (i; 0..N) {
                if (v[i] != rhs.v[i]) {
                    return false;
                }
            }
        } else static if (is(U : T)) {
            static foreach (i; 0..N) {
                if (v[i] != rhs) {
                    return false;
                }
            }
        } else {
            static assert (0, "Cannot compare a variable of type " ~ U.stringof ~ " with a variable of type " ~ Vector.stringof);
        }
        return true;
    }
    ///
    pure nothrow unittest {
        auto v1 = Vector2F(4.5f, 6.0f);
        assert (v1 == Vector2F(4.5f, 6.0f));
        assert (v1 != Vector2F(4.5f, 8.0f));
        auto v2 = Vector3I(-1, -1, -1);
        assert (v2 == -1);
        assert (v2 != 0);
    }
	///
	Vector opUnary(string op)() pure const nothrow if (op == "+" || op == "-" || op == "~" || op == "!") {
		Vector ret = void;
		static foreach (i; 0..N) {
			mixin("ret.v[i] = " ~ op ~ "v[i];");
		}
		return ret;
	}
    ///
    pure nothrow unittest {
        auto v1 = Vector2I(2, -5);
        assert ((+v1).v == [2, -5]);
        assert ((-v1).v == [-2, 5]);
        assert ((~v1).v == [-3, 4]);
        // *** BUG ***
        //auto v2 = Vector!(bool, 2)(true, false);
        //assert ((!v2).v == [false, true]);
    }
	///
	Vector opBinary(string op, U)(U rhs) pure nothrow const {
		Vector ret = void;
        static if (is(U : Vector)) {
            static foreach (i; 0..N) {
				mixin("ret.v[i] = cast(T)(v[i] " ~ op ~ " rhs.v[i]);");
			}
        } else static if (is(U : T)) {
			static foreach (i; 0..N) {
				mixin("ret.v[i] = cast(T)(v[i] " ~ op ~ " rhs);");
			}
		} else {
            static assert (0, "Cannot assign a variable of type " ~ U.stringof ~ " within a variable of type " ~ Vector.stringof);
		}
		return ret;
	}
    ///
    pure nothrow unittest {
        auto v1 = Vector2I(4, -5);
        auto v2 = Vector2I(7, 2);
        auto v3 = v1 + v2;
        assert (v3.v == [11, -3]);
        v3 = v2 - 2;
        assert (v3.v == [5, 0]);
    }
	///
    Vector opBinaryRight(string op, U)(U lhs) pure nothrow const {
        Vector ret = void;
        static if (is(U : Vector)) {
            static foreach (i; 0..N) {
		        mixin("ret.v[i] = cast(T)(lhs.v[i] " ~ op ~ " v[i]);");
	        }
        } else static if (is(U : T)) {
	        static foreach (i; 0..N) {
		        mixin("ret.v[i] = cast(T)(lhs " ~ op ~ " v[i]);");
	        }
        } else  {
            static assert (0, "Cannot assign a variable of type " ~ U.stringof ~ " within a variable of type " ~ Vector.stringof);
        }
	    return ret;
    }
    ///
    pure nothrow unittest {
        auto v1 = Vector2I(4, -5);
        auto v2 = 3 + v1;
        assert (v2.v == [7, -2]);
    }
    ///
	ref Vector opOpAssign(string op, U)(U rhs) pure nothrow {
        static if (is(U : Vector) || is(U : T)) {
            mixin("this = this " ~ op ~ " rhs;");
        } else {
            static assert (0, "Cannot assign a variable of type " ~ U.stringof ~ " within a variable of type " ~ Matrix.stringof);
        }
		return this;
	}
	///
    pure nothrow unittest {
        auto v1 = Vector2I(2, -8);
        v1 += 3;
        assert (v1.v == [5, -5]);
        auto v2 = Vector2I(1, 2);
        v1 -= v2;
        assert (v1.v == [4, -7]);
    }
	///
	ref T opIndex(size_t i) pure nothrow {
		return v[i];
	}
	///
	ref const(T) opIndex(size_t i) pure nothrow const {
		return v[i];
	}
	///
	T opIndexAssign(U : T)(U x, size_t i) pure nothrow {
		return v[i] = x;
	}
	///
	U opCast(U)() pure nothrow const if (isVector!U && U.size == size) {
		U ret = void;
		static foreach (i; 0..N) {
			mixin("ret.v[i] = cast(U.type)v[i];");
		}
		return ret;
	}
    ///
    pure nothrow unittest {
        auto v1 = Vector2F(1.3f, -5.7f);
        auto v2 = cast(Vector2I)v1;
        assert (v2.v == [1, -5]);
    }
	///
	int opDollar() pure nothrow const {
		return N;
	}
	///
	T[] opSlice() pure nothrow {
		return v[];
	}
	///
	T[] opSlice(int a, int b) pure nothrow {
		return v[a..b];
	}
	/// Returns a pointer to content.
    inout(T)* ptr() pure nothrow inout {
        return v.ptr;
    }
    /// Converts current vector to a string.
    string toString() nothrow const {
        try {
            import std.string : format;
            return format("%s", v);
        } catch (Exception e) {
            assert (0);
        }
    }
    ///
    pure nothrow unittest {
        auto v = Vector!(uint, 2)(2, 4);
        assert (v.toString() == "[2, 4]");
    }
	///
	T squaredMagnitude() pure nothrow const {
		T sumSquares = 0;
		static foreach (i; 0..N) {
			mixin("sumSquares += v[i] * v[i];");
		}
		return sumSquares;
	}
	///
	T squaredDistanceTo(Vector v) pure nothrow const {
		return (v - this).squaredMagnitude();
	}
	static if (isFloatingPoint!T) {
		/// Returns Euclidean length.
		T magnitude() pure nothrow const {
            import liberty.math.functions : sqrt;
			return sqrt(squaredMagnitude());
		}
		/// Returns inverse of Euclidean length.
		T inverseMagnitude() pure nothrow const {
            import liberty.math.functions : sqrt;
			return 1 / sqrt(squaredMagnitude());
		}
		/// Faster but less accurate inverse of Euclidean length. Returns inverse of Euclidean length.
		T fastInverseMagnitude() pure nothrow const {
            import liberty.math.functions : inverseSqrt;
			return inverseSqrt(squaredMagnitude());
		}
		/// Returns Euclidean distance between this and other.
		T distanceTo(Vector other) pure nothrow const {
			return (other - this).magnitude();
		}
		/// In-place normalization.
		void normalize() pure nothrow {
			auto invMag = inverseMagnitude();
			v[] *= invMag;
		}
		/// Returns normalized vector.
		Vector normalized() pure nothrow const {
			Vector res = this;
			res.normalize();
			return res;
		}
		/// Faster but less accurate in-place normalization.
		void fastNormalize() pure nothrow {
			auto invLength = fastInverseMagnitude();
			v[] *= invLength;
		}
		/// Faster but less accurate vector normalization. Returns normalized vector.
		Vector fastNormalized() pure nothrow const {
			Vector ret = this;
			ret.fastNormalize();
			return ret;
		}
		static if (N == 3) {
			/// Gets an orthogonal vector from a 3D vector.
			Vector getOrthogonalVector() pure nothrow const {
        import liberty.math.functions : abs;
				return abs(x) > abs(z) ? Vector(-y, x, 0.0) : Vector(0.0, -z, y);
			}
		}
	}

  static if (is(T == float) && N == 3) {
    ref Vector!(T, 3) rotate(float angle, Vector!(T, 3) axis) {
      float sinHalfAngle = sin(radians(angle / 2));
      float cosHalfAngle = cos(radians(angle / 2));

      float rX = axis.x * sinHalfAngle;
      float rY = axis.y * sinHalfAngle;
      float rZ = axis.z * sinHalfAngle;
      float rW = cosHalfAngle;

      Quaternion!T rotation = Quaternion!T(rX, rY, rZ, rW);
      Quaternion!T conjugate = rotation.inversed();
      Quaternion!T w = rotation.mul(this) * conjugate;

      x = w.x;
      y = w.y;
      z = w.z;

      return this;
    }
  }
}
///
template Vector2(T) {
	alias Vector2 = Vector!(T, 2);
}
///
template Vector3(T) {
	alias Vector3 = Vector!(T, 3);
}
///
template Vector4(T) {
	alias Vector4 = Vector!(T, 4);
}
///
alias Vector2I = Vector2!int ;
///
alias Vector2U = Vector2!uint;
///
alias Vector2F = Vector2!float;
///
alias Vector2D = Vector2!double;
///
alias Vector3I = Vector3!int;
///
alias Vector3U = Vector3!uint;
///
alias Vector3F = Vector3!float;
///
alias Vector3D = Vector3!double;
///
alias Vector4I = Vector4!int;
///
alias Vector4U = Vector4!uint;
///
alias Vector4F = Vector4!float;
///
alias Vector4D = Vector4!double;
/// Element-wise minimum.
Vector!(T, N) minByElem(T, int N)(const Vector!(T, N) a, const Vector!(T, N) b) pure nothrow {
    import std.algorithm : min;
    Vector!(T, N) ret = void;
    static foreach (i; 0..N) {
	    ret.v[i] = min(a.v[i], b.v[i]);
    }
    return ret;
}
/// Element-wise maximum.
Vector!(T, N) maxByElem(T, int N)(const Vector!(T, N) a, const Vector!(T, N) b) pure nothrow {
    import std.algorithm : max;
    Vector!(T, N) ret = void;
    static foreach (i; 0..N) {
	    ret.v[i] = max(a.v[i], b.v[i]);
    }
    return ret;
}
/// Element-wise absolute value.
Vector!(T, N) absByElem(T, int N)(const Vector!(T, N) a) pure nothrow {
    import liberty.math.functions : abs;
    Vector!(T, N) ret = void;
    static foreach (i; 0..N) {
	    ret.v[i] = abs(a.v[i]);
    }
    return ret;
}
/// Returns dot product.
T dot(T, int N)(const Vector!(T, N) a, const Vector!(T, N) b) pure nothrow {
    T sum = 0;
    static foreach (i; 0..N) {
	    sum += a.v[i] * b.v[i];
    }
    return sum;
}
/// Returns 3D cross product.
Vector!(T, 3) cross(T)(const Vector!(T, 3) a, const Vector!(T, 3) b) pure nothrow {
    return Vector!(T, 3)(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
}
/// Returns 3D reflect.
Vector!(T, N) reflect(T, int N)(const Vector!(T, N) a, const Vector!(T, N) b) pure nothrow {
    return a - (2 * dot(b, a)) * b;
}
///
static assert (Vector2F.sizeof == 8);
///
static assert (Vector3D.sizeof == 24);
///
static assert (Vector4I.sizeof == 16);
