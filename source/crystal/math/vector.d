/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.math.vector;
import std.traits : isAssignable, isStaticArray, isDynamicArray, isFloatingPoint;
import crystal.math.functions;
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
            static if (N == 3) {
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
    static if (N == 2) {
        ///
        this(T x, T y) pure nothrow @nogc @safe {
            v[0] = x;
            v[1] = y;
        }
    } else static if (N == 3) {
        ///
        this(T x, T y, T z) pure nothrow @nogc @safe {
            v[0] = x;
            v[1] = y;
            v[2] = z;
        }
    } else {
        ///
        this(T x, T y, T z, T w) pure nothrow @nogc @safe {
            v[0] = x;
            v[1] = y;
            v[2] = z;
            v[3] = w;
        }
    }
    ///
    this(T[N] arr) pure nothrow @nogc @safe {
        v = arr; // check
    }
    /// Assign a Vector from a compatible type.
    ref Vector opAssign(U)(U val) pure nothrow @nogc @safe if (isAssignable!(T, U)) {
        foreach (e; v) {
            e = val;
        }
        return this;
    }
    ///
    pure nothrow @nogc @safe unittest {
        auto v = Vector!(float, 2)(0.0f, 6.78f);
        assert (v.x == 0.0f && v.y == 6.78f);
    }
    /// Assign a Vector with a static array.
    ref Vector opAssign(U)(U rhs) pure nothrow @nogc @safe if ((isStaticArray!(U) && isAssignable!(T, typeof(rhs[0])) && (rhs.length == N))) {
        v[0..N]= rhs[0..N];
        return this;
    }
    ///
    pure nothrow @nogc @safe unittest {
        auto v = Vector!(int, 3)([3, 4, 5]);
        assert (v.x == 3 && v.y == 4 && v.z == 5);
    }
    /// Assign a Vector with a dynamic array.
    ref Vector opAssign(U)(U rhs) pure nothrow @nogc @safe if (isDynamicArray!(U) && isAssignable!(T, typeof(rhs[0])))
    //in(rhs.length == N, "rhs lenght must be equal to current vector size") 2.081.0
    in {
        assert (rhs.length == N, "rhs lenght must be equal to current vector size");
    } do {
        v[0..N] = rhs[0..N];
        return this;
    }
    ///
    pure nothrow @nogc @safe unittest {
        // TODO
    }
    /// Assign from a direct convertible Vector.
    ref Vector opAssign(U)(U rhs) pure nothrow @nogc @safe if (is(U : Vector)) {
        v[] = rhs.v[];
        return this;
    }
    ///
    pure nothrow @nogc @safe unittest {
        // TODO
    }
    /// Assign from other vectors types with same size and compatible type.
    ref Vector opAssign(U)(U rhs) pure nothrow @nogc @safe if (isVector!U && isAssignable!(T, U.type) && (!is(U: Vector)) && (U.size == size)) {
        v[0..N] = rhs.v[0..N];
        return this;
    }
    ///
    pure nothrow @nogc @safe unittest {
        auto v = Vector!(int, 3)([3, 4, 5]);
        v = Vector!(int, 3)(7, 8, 9);
        assert (v.x == 7 && v.y == 8 && v.z == 9);
    }
	///
	bool opEquals(U)(U rhs) pure nothrow const @safe @nogc if (is(U : Vector)) {
		static foreach (i; 0..N) {
			if (v[i] != rhs.v[i]) {
				return false;
			}
		}
		return true;
	}
	///
	bool opEquals(U)(U other) pure nothrow const @safe @nogc if (isConvertible!U) {
		Vector conv = rhs;
		return opEquals(conv);
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
	Vector opBinary(string op, U)(U rhs) pure nothrow const @safe @nogc if (is(U : Vector) || (isConvertible!U)) {
		Vector ret;
		static if (is(U : T)) {
			static foreach (i; 0..N) {
				mixin("ret.v[i] = cast(T)(v[i] " ~ op ~ " rhs);");
			}
		} else {
			static foreach (i; 0..N) {
				mixin("ret.v[i] = cast(T)(v[i] " ~ op ~ " rhs.v[i]);");
			}
		}
		return ret;
	}
	///
    Vector opBinaryRight(string op, U)(U lhs) pure nothrow const @safe @nogc if (isConvertible!U) {
        Vector ret;
        static if (is(U : T)) {
	        static foreach (i; 0..N) {
		        mixin("ret.v[i] = cast(T)(lhs " ~ op ~ " v[i]);");
	        }
        } else  {
	        static foreach (i; 0..N) {
		        mixin("ret.v[i] = cast(T)(lhs.v[i] " ~ op ~ " v[i]);");
	        }
        }
	    return ret;
    }
    ///
	ref Vector opOpAssign(string op, U)(U rhs) pure nothrow @safe @nogc if (is(U : Vector)) {
		static foreach (i; 0..N) {
			mixin("v[i] " ~ op ~ "= rhs.v[i];");
		}
		return this;
	}
	///
	ref Vector opOpAssign(string op, U)(U rhs) pure nothrow @safe @nogc if (isConvertible!U) {
		Vector conv = rhs;
		return opOpAssign!op(conv);
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
	U opCast(U)() pure nothrow const @safe @nogc if (isVector!U && (U.size == size)) {
		U ret;
		static foreach (i; 0..N) {
			mixin("ret.v[i] = cast(U.type)v[i];");
		}
		return ret;
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
        auto v = Vector!(uint, 2)([2, 4]);
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
			return sqrt(squaredMagnitude());
		}
		/// Returns inverse of Euclidean length.
		T inverseMagnitude() pure nothrow const @safe @nogc {
			return 1 / sqrt(squaredMagnitude());
		}
		/// Faster but less accurate inverse of Euclidean length. Returns inverse of Euclidean length.
		T fastInverseMagnitude() pure nothrow const @safe @nogc {
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
				return abs(x) > abs(z) ? Vector(-y, x, 0.0) : Vector(0.0, -z, y);
			}
		}
	}
	private enum bool isConvertible(T) = (!is(T : Vector)) && is(typeof({ T x; Vector v = x; }()));
	private enum bool isForeign(T) = (!isConvertible!T) && (!is(T: Vector));
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