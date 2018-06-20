/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.math.matrix;
import std.meta : allSatisfy;
import std.traits : isAssignable;
import crystal.math.vector : Vector;
///
enum MatrixOrder : ubyte {
	///
	RowMajor = 0x00,
	///
	ColumnMajor = 0x01
}
version (__Lite__) {
} else {
	/// Number of elements of MatrixOrder enumeration (!LiteVersion).
	enum MatrixOrderCount = __traits(allMembers, MatrixOrder).length;
}
version = __RowMajor__;
version (__RowMajor__) {
	enum CurrentMatrixOrder = MatrixOrder.RowMajor;
} else {
	enum CurrentMatrixOrder = MatrixOrder.ColumnMajor;
}
/// T = Type of elements.
/// R = Number of rows.
/// C = Number of columns.
/// O = Matrix order. It can be RowMajor or ColumnMajor.
struct Matrix(T, int R, int C = R, MatrixOrder O = CurrentMatrixOrder) if (R >= 2 && R <= 4 && C >= 2 && C <= 4) {
	///
	alias type = T;
	///
	enum rowCount = R;
	///
	enum columnCount = C;
	///
	enum order = 0;
	///
	enum bool isSquare = (R == C);
	static if (O == MatrixOrder.RowMajor) {
		///
		alias RowType = Vector!(T, C) ;
		///
		alias ColumnType = Vector!(T, R);
		/// Fields definition.
		union {
			/// All elements.
			T[C * R] v;
			/// All rows.
			RowType[R] row;
			/// Components.
			T[C][R] c;
		}
	} else {
	
	}
	///
	this(U...)(U values) pure nothrow @nogc @safe {
		static if ((U.length == C * R) && allSatisfy!(isThisTAssignable, U)) {
			static foreach (i, x; values) {
				v[i] = x;
			}
		} else static if ((U.length == 1) && isThisTAssignable!U && (!is(U[0] : Matrix))) {
			v[] = values[0];
		} else static if (U.length == 0) {
			v[] = cast(T)0;
		} else {
			static assert(false, "Cannot create a matrix from given arguments!");
		}
	}
	///
	pure nothrow @safe unittest {
		// Create a matrix using all values.
		auto matrix1 = Matrix!(int, 2)(1, 2, 3, 4);
		assert (matrix1.v == [1, 2, /**/ 3, 4]);
		// Create a matrix from one value.
		auto matrix2 = Matrix!(float, 2)(5.2f);
		assert (matrix2.v == [5.2f, 5.2f, /**/ 5.2f, 5.2f]);
		// Create a matrix with no value (implicit 0).
		auto matrix3 = Matrix!(short, 2)();
		assert (matrix3.v == [0, 0, /**/ 0, 0]);
	}
	/// Construct a matrix from columns.
	static Matrix fromColumns(ColumnType[] columns) pure nothrow @nogc @safe
	in {
		assert(columns.length == C);
	} do {
		Matrix ret;
		// todo
		return ret;
	}
	///
	pure nothrow @safe unittest {
		// todo
	}
	/// Construct a matrix from rows.
	static Matrix fromRows(RowType[] rows) pure nothrow @nogc @safe
	in {
		assert(rows.length == R);
	} do {
		Matrix ret;
		ret.row[] = rows[];
		return ret;
	}
	///
	pure nothrow @safe unittest {
		auto row = Vector!(double, 2)(2.0, 4.5);
		auto matrix = Matrix!(double, 2).fromRows([row, row]);
		assert (matrix.v == [2.0, 4.5, /**/ 2.0, 4.5]);
	}
	/// Returns an identity matrix.
	static Matrix identity() pure nothrow @nogc @safe {
		Matrix ret;
		static foreach (i; 0 .. R) {
			static foreach (j; 0 .. C) {
				static if (i == j) {
					ret.c[i][j] = 1;
				} else {
					ret.c[i][j] = 0;
				}
			}
		}
		return ret;
	}
	///
	pure nothrow @safe unittest {
		auto matrix = Matrix!(uint, 3).identity();
		assert (matrix.v == [1, 0, 0, /**/ 0, 1, 0, /**/ 0, 0, 1]);
	}
	/// Returns a constant matrix.
	static Matrix constant(U)(U x) pure nothrow @nogc @safe {
		Matrix ret;
		static foreach (i; 0 .. R * C) {
			ret.v[i] = cast(T)x;
		}
		return ret;
	}
	///
	pure nothrow @safe unittest {
		auto matrix = Matrix!(int, 2, 3).constant(7);
		assert (matrix.v == [7, 7, 7, /**/ 7, 7, 7]);
	}
	/// Returns a pointer to content.
	inout(T)* ptr() pure nothrow inout @nogc @property {
		return v.ptr;
	}
	private template isThisAssignable(T) {
		enum bool isThisAssignable = isAssignable!(Matrix, T);
	}
	private template isThisConvertible(T) {
		enum bool isThisConvertible = (!is(T : Matrix)) && isThisAssignable!T;
	}
	private template isThisTAssignable(U) {
		enum bool isThisTAssignable = isAssignable!(T, U);
	}
	private template isThisRowConvertible(U) {
		enum bool isThisRowConvertible = is(U : RowType);
	}
	private template isThisColumnConvertible(U) {
		enum bool isThisColumnConvertible = is(U : ColumnType);
	}
}
///
template isMatrixInstance(U) {
	private static void isMatrix(T, int R, int C, MatrixOrder O)(Matrix!(T, R, C, O) x) {}
	enum bool isMatrixInstance = is(typeof(isMatrix(U.init)));
}
///
template Matrix2(T) {
	alias Matrix2 = Matrix!(T, 2);
}
///
template Matrix3(T) {
	alias Matrix3 = Matrix!(T, 3);
}
///
template Matrix4(T) {
	alias Matrix4 = Matrix!(T, 4);
}
///
template Matrix2x3(T) {
	alias Matrix2x3 = Matrix!(T, 2, 3);
}
///
template Matrix2x4(T) {
	alias Matrix2x4 = Matrix!(T, 2, 4);
}
///
template Matrix3x2(T) {
	alias Matrix3x2 = Matrix!(T, 3, 2);
}
///
template Matrix3x4(T) {
	alias Matrix3x4 = Matrix!(T, 3, 4);
}
///
template Matrix4x2(T) {
	alias Matrix4x2 = Matrix!(T, 4, 2);
}
///
template Matrix4x3(T) {
	alias Matrix4x3 = Matrix!(T, 4, 3);
}
///
alias Matrix2F = Matrix2!float;
///
alias Matrix3F = Matrix3!float;
///
alias Matrix4F = Matrix4!float;
///
alias Matrix2x3F = Matrix2x3!float;
///
alias Matrix2x4F = Matrix2x4!float;
///
alias Matrix3x2F = Matrix3x2!float;
///
alias Matrix3x4F = Matrix3x4!float;
///
alias Matrix4x2F = Matrix4x2!float;
///
alias Matrix4x3F = Matrix4x3!float;