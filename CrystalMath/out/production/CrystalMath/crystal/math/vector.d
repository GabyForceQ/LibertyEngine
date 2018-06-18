/**
 * Copyright:   Copyright (C) 2018 Gabrot, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.math.vector;
import std.traits : isAssignable, isStaticArray, isDynamicArray;
/// T = type of elements
/// N = number of elements (2, 3, 4)
struct Vector(T, ubyte N) if (N >= 2 && N <= 4) {
	///
	alias size = N;
	///
	alias type = T;
	///
    union {
        T[N] v;
        struct {
            static if (N >= 1) { T x; alias r = x; alias p = x; }
            static if (N >= 2) { T y; alias g = y; alias q = y; }
            static if (N >= 3) { T z; alias b = z; alias s = z; }
            static if (N >= 4) { T w; alias a = w; alias t = w; }
        }
    }
    static if (N == 2 && is(T == float)) {
        /// Vector2 with values of 0
        static const Vector!(T, 2) zero = Vector!(T, 2)(0, 0);
        /// Vector2 with values of 1
        static const Vector!(T, 2) one = Vector!(T, 2)(1, 1);
        /// Vector2 pointing up
        static const Vector!(T, 2) up = Vector!(T, 2)(0, 1);
        /// Vector2 pointing right
        static const Vector!(T, 2) right = Vector!(T, 2)(1, 0);
        /// Vector2 pointing down
        static const Vector!(T, 2) down = Vector!(T, 2)(0, -1);
        /// Vector2 pointing left
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
        /// Vector3 with values of 0
        static const Vector!(T, 3) zero = Vector!(T, 3)(0, 0, 0);
        /// Vector3 with values of 1
        static const Vector!(T, 3) one = Vector!(T, 3)(1, 1, 1);
        /// Vector3 pointing up
        static const Vector!(T, 3) up = Vector!(T, 3)(0, 1, 0);
        /// Vector3 pointing right
        static const Vector!(T, 3) right = Vector!(T, 3)(1, 0, 0);
        /// Vector3 pointing down
        static const Vector!(T, 3) down = Vector!(T, 3)(0, -1, 0);
        /// Vector3 pointing left
        static const Vector!(T, 3) left = Vector!(T, 3)(-1, 0, 0);
        /// Vector3 pointing forward
        static const Vector!(T, 3) forward = Vector!(T, 3)(0, 0, 1);
        /// Vector3 pointing backward
        static const Vector!(T, 3) backward = Vector!(T, 3)(0, 0, -1);
        ///
        unittest {
            assert(Vector!(T, 3).zero == Vector!(T, 3)(0, 0, 0));
            assert(Vector!(T, 3).one == Vector!(T, 3)(1, 1, 1));
            assert(Vector!(T, 3).up == Vector!(T, 3)(0, 1, 0));
            assert(Vector!(T, 3).right == Vector!(T, 3)(1, 0, 0));
            assert(Vector!(T, 3).down == Vector!(T, 3)(0, -1, 0));
            assert(Vector!(T, 3).left == Vector!(T, 3)(-1, 0, 0));
            assert(Vector!(T, 3).forward == Vector!(T, 3)(0, 0, 1)); // check
            assert(Vector!(T, 3).backward == Vector!(T, 3)(0, 0, -1)); // check
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
    ref Vector opAssign(U)(U val) pure nothrow @nogc if (isAssignable!(T, U)) {
        foreach (e; v) {
            e = val;
        }
        return this;
    }
    ///
    unittest {
        auto v = Vector!(float, 2)(0.0f, 6.78f);
        assert (v.x == 0.0f && v.y == 6.78f);
    }
    /// Assign a Vector with a static array.
    ref Vector opAssign(U)(U rhs) pure nothrow @nogc if ((isStaticArray!(U) && isAssignable!(T, typeof(rhs[0])) && (rhs.length == N))) {
        v[0..N]= rhs[0..N];
        return this;
    }
    ///
    unittest {
        auto v = Vector!(int, 3)([3, 4, 5]);
        assert (v.x == 3 && v.y == 4 && v.z == 5);
    }
    /// Assign a Vector with a dynamic array.
    ref Vector opAssign(U)(U rhs) pure nothrow @nogc if (isDynamicArray!(U) && isAssignable!(T, typeof(rhs[0])))
    //in(rhs.length == N, "rhs lenght must be equal to current vector size") 2.081.0
    in {
        assert (rhs.length == N, "rhs lenght must be equal to current vector size");
    } do {
        v[0..N]= rhs[0..N];
        return this;
    }
    ///
    unittest {
        // TODO
    }
    /// Assign from a direct convertible Vector.
    ref Vector opAssign(U)(U rhs) pure nothrow @nogc if (is(U : Vector)) {
        v[] = rhs.v[];
        return this;
    }
    ///
    unittest {
        // TODO
    }
    /// Assign from other vectors types with same size and compatible type.
    ref Vector opAssign(U)(U rhs) pure nothrow @nogc if (isVector!U && isAssignable!(T, U.type) && (!is(U: Vector)) && (U.size == size)) {
        v[0..N] = rhs.v[0..N];
        return this;
    }
    ///
    unittest {
        auto v = Vector!(int, 3)([3, 4, 5]);
        v = Vector!(int, 3)(7, 8, 9);
        assert (v.x == 7 && v.y == 8 && v.z == 9);
    }
    /// Returns a pointer to content.
    inout(T)* ptr() pure nothrow inout @nogc @property {
        return v.ptr;
    }
    /// Converts current vector to a string.
    string toString() const nothrow {
	    try {
		    import std.string : format;
		    return format("%s", v);
	    } catch (Exception e) {
		    assert (0);
	    }
    }
    ///
    unittest {
        auto v = Vector!(uint, 2)([2, 4]);
        assert (v.toString() == "[2, 4]");
    }
}
/// True if T is some kind of Vector
enum isVector(T) = is(T : Vector!U, U...);
///
unittest {
    static assert (isVector!Vector2F);
    static assert (isVector!Vector3I);
    static assert (isVector!(Vector4!uint));
    static assert (!isVector!real);
}
/// The numeric type used to measure coordinates of a vector.
alias DimensionType(T : Vector!U, U...) = U[0];
///
unittest {
    static assert (is(DimensionType!Vector2F == float));
    static assert (is(DimensionType!Vector3D == double));
}
///
template Vector2(T) { alias Vector2 = Vector!(T, 2); }
///
template Vector3(T) { alias Vector3 = Vector!(T, 3); }
///
template Vector4(T) { alias Vector4 = Vector!(T, 4); }
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