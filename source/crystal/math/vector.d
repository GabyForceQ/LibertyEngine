/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/CrystalEngine/blob/master/source/crystal/math/vector.d, _vector.d)
 * Documentation:
 * Coverage:
 */
module crystal.math.vector;
import std.traits : isFloatingPoint;
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
    static if (N == 2 && is(T == float)) {
        /// Vector2 with values of 0.
        static const Vector!(T, 2) zero = Vector!(T, 2)(0, 0);
        /// Vector2 with values of 1.
        static const Vector!(T, 2) one = Vector!(T, 2)(1, 1);
        /// Vector2 pointing up.
        static const Vector!(T, 2) up = Vector!(T, 2)(0, 1);
        /// Vector2 pointing right.
        static const Vector!(T, 2) right = Vector!(T, 2)(1, 0);
        /// Vector2 pointing down.
        static const Vector!(T, 2) down = Vector!(T, 2)(0, -1);
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
            assert(Vector!(T, 3).right == Vector!(T, 3)(1, 0, 0));
            assert(Vector!(T, 3).down == Vector!(T, 3)(0, -1, 0));
            assert(Vector!(T, 3).left == Vector!(T, 3)(-1, 0, 0));
            assert(Vector!(T, 3).forward == Vector!(T, 3)(0, 0, 1));
            assert(Vector!(T, 3).backward == Vector!(T, 3)(0, 0, -1));
        }
    }
    ///
    this(U...)(U values) pure nothrow @safe @nogc {
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
    pure nothrow @safe unittest {
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
    ref Vector opAssign(U)(U rhs) pure nothrow @nogc @safe {
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
    pure nothrow @safe unittest {
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
    bool opEquals(U)(U rhs) pure nothrow const @safe @nogc {
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
    pure nothrow @safe unittest {
        auto v1 = Vector2F(4.5f, 6.0f);
        assert (v1 == Vector2F(4.5f, 6.0f));
        assert (v1 != Vector2F(4.5f, 8.0f));
        auto v2 = Vector3I(-1, -1, -1);
        assert (v2 == -1);
        assert (v2 != 0);
    }
	///
	Vector opUnary(string op)() pure const nothrow @safe @nogc if (op == "+" || op == "-" || op == "~" || op == "!") {
		Vector ret;
		static foreach (i; 0..N) {
			mixin("ret.v[i] = " ~ op ~ "v[i];");
		}
		return ret;
	}
    ///
    pure nothrow @safe @nogc unittest {
        auto v1 = Vector2I(2, -5);
        assert ((+v1).v == [2, -5]);
        assert ((-v1).v == [-2, 5]);
        assert ((~v1).v == [-3, 4]);
        // *** BUG ***
        //auto v2 = Vector!(bool, 2)(true, false);
        //assert ((!v2).v == [false, true]);
    }
	///
	Vector opBinary(string op, U)(U rhs) pure nothrow const @safe @nogc {
		Vector ret;
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
    pure nothrow @safe @nogc unittest {
        auto v1 = Vector2I(4, -5);
        auto v2 = Vector2I(7, 2);
        auto v3 = v1 + v2;
        assert (v3.v == [11, -3]);
        v3 = v2 - 2;
        assert (v3.v == [5, 0]);
    }
	///
    Vector opBinaryRight(string op, U)(U lhs) pure nothrow const @safe @nogc {
        Vector ret;
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
    pure nothrow @safe @nogc unittest {
        auto v1 = Vector2I(4, -5);
        auto v2 = 3 + v1;
        assert (v2.v == [7, -2]);
    }
    ///
	ref Vector opOpAssign(string op, U)(U rhs) pure nothrow @safe @nogc {
        static if (is(U : Vector) || is(U : T)) {
            mixin("this = this " ~ op ~ " rhs;");
        } else {
            static assert (0, "Cannot assign a variable of type " ~ U.stringof ~ " within a variable of type " ~ Matrix.stringof);
        }
		return this;
	}
	///
    pure nothrow @safe @nogc unittest {
        auto v1 = Vector2I(2, -8);
        v1 += 3;
        assert (v1.v == [5, -5]);
        auto v2 = Vector2I(1, 2);
        v1 -= v2;
        assert (v1.v == [4, -7]);
    }
	///
	ref T opIndex(size_t i) pure nothrow @safe @nogc {
		return v[i];
	}
	///
	ref const(T) opIndex(size_t i) pure nothrow const @safe @nogc {
		return v[i];
	}
	///
	T opIndexAssign(U : T)(U x, size_t i) pure nothrow @safe @nogc {
		return v[i] = x;
	}
	///
	U opCast(U)() pure nothrow const @safe @nogc if (isVector!U && U.size == size) {
		U ret;
		static foreach (i; 0..N) {
			mixin("ret.v[i] = cast(U.type)v[i];");
		}
		return ret;
	}
    ///
    pure nothrow @safe @nogc unittest {
        auto v1 = Vector2F(1.3f, -5.7f);
        auto v2 = cast(Vector2I)v1;
        assert (v2.v == [1, -5]);
    }
	///
	int opDollar() pure nothrow const @safe @nogc {
		return N;
	}
	///
	T[] opSlice() pure nothrow @safe @nogc {
		return v[];
	}
	///
	T[] opSlice(int a, int b) pure nothrow @safe @nogc {
		return v[a..b];
	}
	/// Returns a pointer to content.
    inout(T)* ptr() pure nothrow inout @nogc @property {
        return v.ptr;
    }
    /// Converts current vector to a string.
    string toString() nothrow const @safe {
        try {
            import std.string : format;
            return format("%s", v);
        } catch (Exception e) {
            assert (0);
        }
    }
    ///
    pure nothrow @safe unittest {
        auto v = Vector!(uint, 2)(2, 4);
        assert (v.toString() == "[2, 4]");
    }
	///
	T squaredMagnitude() pure nothrow const @safe @nogc {
		T sumSquares = 0;
		static foreach (i; 0..N) {
			mixin("sumSquares += v[i] * v[i];");
		}
		return sumSquares;
	}
	///
	T squaredDistanceTo(Vector v) pure nothrow const @safe @nogc {
		return (v - this).squaredMagnitude();
	}
	static if (isFloatingPoint!T) {
		/// Returns Euclidean length.
		T magnitude() pure nothrow const @safe @nogc {
            import crystal.math.functions : sqrt;
			return sqrt(squaredMagnitude());
		}
		/// Returns inverse of Euclidean length.
		T inverseMagnitude() pure nothrow const @safe @nogc {
            import crystal.math.functions : sqrt;
			return 1 / sqrt(squaredMagnitude());
		}
		/// Faster but less accurate inverse of Euclidean length. Returns inverse of Euclidean length.
		T fastInverseMagnitude() pure nothrow const @safe @nogc {
            import crystal.math.functions : inverseSqrt;
			return inverseSqrt(squaredMagnitude());
		}
		/// Returns Euclidean distance between this and other.
		T distanceTo(Vector other) pure nothrow const @safe @nogc {
			return (other - this).magnitude();
		}
		/// In-place normalization.
		void normalize() pure nothrow @safe @nogc {
			auto invMag = inverseMagnitude();
			v[] *= invMag;
		}
		/// Returns normalized vector.
		Vector normalized() pure nothrow const @safe @nogc {
			Vector res = this;
			res.normalize();
			return res;
		}
		/// Faster but less accurate in-place normalization.
		void fastNormalize() pure nothrow @safe @nogc {
			auto invLength = fastInverseMagnitude();
			v[] *= invLength;
		}
		/// Faster but less accurate vector normalization. Returns normalized vector.
		Vector fastNormalized() pure nothrow const @safe @nogc {
			Vector ret = this;
			ret.fastNormalize();
			return ret;
		}
		static if (N == 3) {
			/// Gets an orthogonal vector from a 3D vector.
			Vector getOrthogonalVector() pure nothrow const @safe @nogc {
                import crystal.math.functions : abs;
				return abs(x) > abs(z) ? Vector(-y, x, 0.0) : Vector(0.0, -z, y);
			}
		}
	}
}
/// True if T is some kind of Vector.
enum isVector(T) = is(T : Vector!U, U...);
///
pure nothrow @safe @nogc unittest {
    static assert (isVector!Vector2F);
    static assert (isVector!Vector3I);
    static assert (isVector!(Vector4!uint));
    static assert (!isVector!real);
}
/// The numeric type used to measure coordinates of a vector.
alias DimensionType(T : Vector!U, U...) = U[0];
///
pure nothrow @safe @nogc unittest {
    static assert (is(DimensionType!Vector2F == float));
    static assert (is(DimensionType!Vector3D == double));
    static assert (is(DimensionType!Vector4U == uint));
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
Vector!(T, N) minByElem(T, int N)(const Vector!(T, N) a, const Vector!(T, N) b) pure nothrow @safe @nogc {
    import std.algorithm : min;
    Vector!(T, N) ret;
    static foreach (i; 0..N) {
	    ret.v[i] = min(a.v[i], b.v[i]);
    }
    return ret;
}
/// Element-wise maximum.
Vector!(T, N) maxByElem(T, int N)(const Vector!(T, N) a, const Vector!(T, N) b) pure nothrow @safe @nogc {
    import std.algorithm : max;
    Vector!(T, N) ret;
    static foreach (i; 0..N) {
	    ret.v[i] = max(a.v[i], b.v[i]);
    }
    return ret;
}
/// Element-wise absolute value.
Vector!(T, N) absByElem(T, int N)(const Vector!(T, N) a) pure nothrow @safe @nogc {
    import crystal.math.functions : abs;
    Vector!(T, N) ret;
    static foreach (i; 0..N) {
	    ret.v[i] = abs(a.v[i]);
    }
    return ret;
}
/// Returns dot product.
T dot(T, int N)(const Vector!(T, N) a, const Vector!(T, N) b) pure nothrow @safe @nogc {
    T sum = 0;
    static foreach (i; 0..N) {
	    sum += a.v[i] * b.v[i];
    }
    return sum;
}
/// Returns 3D cross product.
Vector!(T, 3) cross(T)(const Vector!(T, 3) a, const Vector!(T, 3) b) pure nothrow @safe @nogc {
    return Vector!(T, 3)(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
}
/// Returns 3D reflect.
Vector!(T, N) reflect(T, int N)(const Vector!(T, N) a, const Vector!(T, N) b) pure nothrow @safe @nogc {
    return a - (2 * dot(b, a)) * b;
}
///
static assert (Vector2F.sizeof == 8);
///
static assert (Vector3D.sizeof == 24);
///
static assert (Vector4I.sizeof == 16);
