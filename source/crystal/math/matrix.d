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
import std.traits : isAssignable, isFloatingPoint;
import crystal.math.vector : Vector, Vector3, dot, cross;
import crystal.math.functions;
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
//version = __RowMajor__;
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
	///
	ColumnType column(int j) pure nothrow const @safe @nogc {
		ColumnType ret;
		static foreach (i; 0..R) {
			ret.v[i] = c[i][j];
		}
		return ret;
	}
	///
	Matrix opBinary(string op)(T factor) pure nothrow const @safe @nogc if (op == "*") {
		Matrix ret;
		static foreach (i; 0..R) {
			static foreach (j; 0..C) {
				ret.c[i][j] = c[i][j] * factor;
			}
		}
		return result;
	}
	///
	ColumnType opBinary(string op)(RowType x) pure nothrow const @safe @nogc if (op == "*") {
		ColumnType ret;
		static foreach (i; 0..R) {
			T sum = 0;
			static foreach (j; 0..C) {
				sum += c[i][j] * x.v[j];
			}
			res.v[i] = sum;
		}
		return ret;
	}
	///
	auto opBinary(string op, U)(U x) pure nothrow const @safe @nogc if (isMatrixInstance!U && (U.rowCount == C) && (op == "*")) {
		Matrix!(T, R, U.columnCount) ret;
		static foreach (i; 0..R) {
			static foreach (j; 0..U.columnCount) {
				T sum = 0;
				static foreach (k; 0..C) {
					sum += c[i][k] * x.c[k][j];
				}
				ret.c[i][j] = sum;
			}
		}
		return ret;
	}
	///
	Matrix opBinary(string op, U)(U rhs) pure nothrow const @safe @nogc if (is(U : Matrix) && (op == "+" || op == "-")) {
		Matrix ret;
		static foreach (i; 0..R) {
			static foreach (j; 0..C) {
				mixin("ret.c[i][j] = c[i][j] " ~ op ~ " rhs.c[i][j];");
			}
		}
		return ret;
	}
	///
	ref Matrix opOpAssign(string op, U)(U rhs) pure nothrow @safe @nogc if (is(U : Matrix)) {
		mixin("Matrix ret = this " ~ op ~ " rhs;");
		return opAssign!Matrix(ret);
	}
	///
	ref Matrix opOpAssign(string op, U)(U rhs) pure nothrow @safe @nogc if (isConvertible!U) {
		Matrix conv = rhs;
		return opOpAssign!op(conv);
	}
	///
	Matrix opUnary(string op)() pure nothrow const @safe @nogc if (op == "+" || op == "-" || op == "~" || op == "!") {
		Matrix ret;
		static foreach (i; 0..R) {
			mixin("ret.v[i] = " ~ op ~ "v[i];");
		}
		return ret;
	}
	///
	U opCast(U)() pure nothrow const @safe @nogc if (isMatrixInstance!U) {
		U ret = U.identity();
		enum min_r = R < U.rowCount ? R : U.rowCount;
		enum min_c = C < U.columnCount ? C : U.columnCount;
		static foreach (i; 0..min_r) {
			static foreach (j; 0..min_c) {
				ret.c[i][j] = cast(U.type)(c[i][j]);
			}
		}
		return ret;
	}
	///
	bool opEquals(U)(U rhs) pure nothrow const @safe @nogc if (is(U : Matrix)) {
		static foreach (i; 0..R * C) {
			if (v[i] != rhs.v[i]) {
				return false;
			}
		}
		return true;
	}
	///
	bool opEquals(U)(U rhs) pure nothrow const @safe @nogc if ((isAssignable!U) && (!is(U: Matrix))) {
		Matrix conv = rhs;
		return opEquals(conv);
	}
	/// Returns a pointer to content.
	inout(T)* ptr() pure nothrow inout @nogc @property {
		return v.ptr;
	}
	static if (isSquare && isFloatingPoint!T && R == 2) {
		/// Returns inverse of matrix 2x2.
		Matrix inverse() pure nothrow const @safe @nogc {
			T invDet = 1 / (c[0][0] * c[1][1] - c[0][1] * c[1][0]);
			return Matrix(c[1][1] * invDet, -c[0][1] * invDet, -c[1][0] * invDet, c[0][0] * invDet);
		}
	}
	static if (isSquare && isFloatingPoint!T && R == 3) {
		/// Returns inverse of matrix 3x3.
		Matrix inverse() pure nothrow const @safe @nogc {
			T det = c[0][0] * (c[1][1] * c[2][2] - c[2][1] * c[1][2]) - c[0][1] * (c[1][0] * c[2][2] - c[1][2] * c[2][0]) + c[0][2] * (c[1][0] * c[2][1] - c[1][1] * c[2][0]);
			T invDet = 1 / det;
			Matrix ret;
			ret.c[0][0] =  (c[1][1] * c[2][2] - c[2][1] * c[1][2]) * invDet;
			ret.c[0][1] = -(c[0][1] * c[2][2] - c[0][2] * c[2][1]) * invDet;
			ret.c[0][2] =  (c[0][1] * c[1][2] - c[0][2] * c[1][1]) * invDet;
			ret.c[1][0] = -(c[1][0] * c[2][2] - c[1][2] * c[2][0]) * invDet;
			ret.c[1][1] =  (c[0][0] * c[2][2] - c[0][2] * c[2][0]) * invDet;
			ret.c[1][2] = -(c[0][0] * c[1][2] - c[1][0] * c[0][2]) * invDet;
			ret.c[2][0] =  (c[1][0] * c[2][1] - c[2][0] * c[1][1]) * invDet;
			ret.c[2][1] = -(c[0][0] * c[2][1] - c[2][0] * c[0][1]) * invDet;
			ret.c[2][2] =  (c[0][0] * c[1][1] - c[1][0] * c[0][1]) * invDet;
			return ret;
		}
	}
	static if (isSquare && isFloatingPoint!T && R == 4) {
		/// Returns inverse of matrix 4x4.
		Matrix inverse() pure nothrow const @safe @nogc {
			T det2_01_01 = c[0][0] * c[1][1] - c[0][1] * c[1][0];
			T det2_01_02 = c[0][0] * c[1][2] - c[0][2] * c[1][0];
			T det2_01_03 = c[0][0] * c[1][3] - c[0][3] * c[1][0];
			T det2_01_12 = c[0][1] * c[1][2] - c[0][2] * c[1][1];
			T det2_01_13 = c[0][1] * c[1][3] - c[0][3] * c[1][1];
			T det2_01_23 = c[0][2] * c[1][3] - c[0][3] * c[1][2];
			T det3_201_012 = c[2][0] * det2_01_12 - c[2][1] * det2_01_02 + c[2][2] * det2_01_01;
			T det3_201_013 = c[2][0] * det2_01_13 - c[2][1] * det2_01_03 + c[2][3] * det2_01_01;
			T det3_201_023 = c[2][0] * det2_01_23 - c[2][2] * det2_01_03 + c[2][3] * det2_01_02;
			T det3_201_123 = c[2][1] * det2_01_23 - c[2][2] * det2_01_13 + c[2][3] * det2_01_12;
			T det = - det3_201_123 * c[3][0] + det3_201_023 * c[3][1] - det3_201_013 * c[3][2] + det3_201_012 * c[3][3];
			T invDet = 1 / det;
			T det2_03_01 = c[0][0] * c[3][1] - c[0][1] * c[3][0];
			T det2_03_02 = c[0][0] * c[3][2] - c[0][2] * c[3][0];
			T det2_03_03 = c[0][0] * c[3][3] - c[0][3] * c[3][0];
			T det2_03_12 = c[0][1] * c[3][2] - c[0][2] * c[3][1];
			T det2_03_13 = c[0][1] * c[3][3] - c[0][3] * c[3][1];
			T det2_03_23 = c[0][2] * c[3][3] - c[0][3] * c[3][2];
			T det2_13_01 = c[1][0] * c[3][1] - c[1][1] * c[3][0];
			T det2_13_02 = c[1][0] * c[3][2] - c[1][2] * c[3][0];
			T det2_13_03 = c[1][0] * c[3][3] - c[1][3] * c[3][0];
			T det2_13_12 = c[1][1] * c[3][2] - c[1][2] * c[3][1];
			T det2_13_13 = c[1][1] * c[3][3] - c[1][3] * c[3][1];
			T det2_13_23 = c[1][2] * c[3][3] - c[1][3] * c[3][2];
			T det3_203_012 = c[2][0] * det2_03_12 - c[2][1] * det2_03_02 + c[2][2] * det2_03_01;
			T det3_203_013 = c[2][0] * det2_03_13 - c[2][1] * det2_03_03 + c[2][3] * det2_03_01;
			T det3_203_023 = c[2][0] * det2_03_23 - c[2][2] * det2_03_03 + c[2][3] * det2_03_02;
			T det3_203_123 = c[2][1] * det2_03_23 - c[2][2] * det2_03_13 + c[2][3] * det2_03_12;
			T det3_213_012 = c[2][0] * det2_13_12 - c[2][1] * det2_13_02 + c[2][2] * det2_13_01;
			T det3_213_013 = c[2][0] * det2_13_13 - c[2][1] * det2_13_03 + c[2][3] * det2_13_01;
			T det3_213_023 = c[2][0] * det2_13_23 - c[2][2] * det2_13_03 + c[2][3] * det2_13_02;
			T det3_213_123 = c[2][1] * det2_13_23 - c[2][2] * det2_13_13 + c[2][3] * det2_13_12;
			T det3_301_012 = c[3][0] * det2_01_12 - c[3][1] * det2_01_02 + c[3][2] * det2_01_01;
			T det3_301_013 = c[3][0] * det2_01_13 - c[3][1] * det2_01_03 + c[3][3] * det2_01_01;
			T det3_301_023 = c[3][0] * det2_01_23 - c[3][2] * det2_01_03 + c[3][3] * det2_01_02;
			T det3_301_123 = c[3][1] * det2_01_23 - c[3][2] * det2_01_13 + c[3][3] * det2_01_12;
			Matrix ret;
			ret.c[0][0] = - det3_213_123 * invDet;
			ret.c[1][0] = + det3_213_023 * invDet;
			ret.c[2][0] = - det3_213_013 * invDet;
			ret.c[3][0] = + det3_213_012 * invDet;
			ret.c[0][1] = + det3_203_123 * invDet;
			ret.c[1][1] = - det3_203_023 * invDet;
			ret.c[2][1] = + det3_203_013 * invDet;
			ret.c[3][1] = - det3_203_012 * invDet;
			ret.c[0][2] = + det3_301_123 * invDet;
			ret.c[1][2] = - det3_301_023 * invDet;
			ret.c[2][2] = + det3_301_013 * invDet;
			ret.c[3][2] = - det3_301_012 * invDet;
			ret.c[0][3] = - det3_201_123 * invDet;
			ret.c[1][3] = + det3_201_023 * invDet;
			ret.c[2][3] = - det3_201_013 * invDet;
			ret.c[3][3] = + det3_201_012 * invDet;
			return ret;
		}
	}
	/// Returns transposed matrix.
	Matrix!(T, C, R) transposed() pure nothrow const @safe @nogc {
		Matrix!(T, C, R) ret;
		static foreach (i; 0..C) {
			static foreach (j; 0..R) {
				ret.c[i][j] = c[j][i];
			}
		}
		return ret;
	}
	static if (isSquare && R > 2) {
		/// Makes a diagonal matrix from a vector.
		static Matrix diag(Vector!(T, R) v) pure nothrow @safe @nogc {
			Matrix ret;
			static foreach (i; 0..R) {
				static foreach (j; 0..C) {
					ret.c[i][j] = (i == j) ? v.v[i] : 0;
				}
			}
			return ret;
		}
		/// In-place translate by (v, 1).
		void translate(Vector!(T, R-1) v) pure nothrow @safe @nogc {
			T _dot = 0;
			static foreach (i; 0..R) {
				static foreach (j; 0..C - 1) {
					_dot += v.v[j] * c[i][j];
				}
				c[i][C - 1] += _dot;
				_dot = 0;
			}
		}
		/// Make a translation matrix.
		static Matrix translation(Vector!(T, R-1) v) pure nothrow @safe @nogc {
			Matrix ret = identity();
			static foreach (i; 0..R - 1) {
				ret.c[i][C - 1] += v.v[i];
			}
			return ret;
		}
		/// In-place matrix scaling.
		void scale(Vector!(T, R-1) v) pure nothrow @safe @nogc {
			static foreach (i; 0..R) {
				static foreach (j; 0..C - 1) {
					c[i][j] *= v.v[j];
				}
			}
		}
		/// Make a scaling matrix.
		static Matrix scaling(Vector!(T, R-1) v) pure nothrow @safe @nogc {
			Matrix ret = identity();
			static foreach (i; 0..R - 1) {
				ret.c[i][i] = v.v[i];
			}
			return ret;
		}
	}
	static if (isSquare && (R == 3 || R == 4) && isFloatingPoint!T) {
		///
		static Matrix rotateAxis(int i, int j)(T angle) pure nothrow @safe @nogc {
			Matrix ret = identity();
			const T cosa = cos(angle);
			const T sina = sin(angle);
			ret.c[i][i] = cosa;
			ret.c[i][j] = -sina;
			ret.c[j][i] = sina;
			ret.c[j][j] = cosa;
			return ret;
		}
		/// Returns rotation matrix along axis X.
		alias rotateXAxix = rotateAxis!(1, 2);
		/// Returns rotation matrix along axis Y.
		alias rotateYAxis = rotateAxis!(2, 0);
		/// Returns rotation matrix along axis Z.
		alias rotateZAxis = rotateAxis!(0, 1);
		/// In-place rotation by (v, 1)
		void rotate(T angle, Vector3!T axis) pure nothrow @safe @nogc {
			this = rotation(angle, axis, this);
		}
		///
		void rotateX(T angle) pure nothrow @safe @nogc {
			this = rotation(angle, Vector3!T(1, 0, 0), this);
		}
		///
		void rotateY(T angle) pure nothrow @safe @nogc {
			this = rotation(angle, Vector3!T(0, 1, 0), this);
		}
		///
		void rotateZ(T angle) pure nothrow @safe @nogc {
			this = rotation(angle, Vector3!T(0, 0, 1), this);
		}
		///
		static Matrix rotation(T angle, Vector3!T axis, Matrix m = identity()) pure nothrow @safe @nogc {
			Matrix ret = m;
			const T c = cos(angle);
			const oneMinusC = 1 - c;
			const T s = sin(angle);
			axis = axis.normalized();
			T x = axis.x,
			y = axis.y,
			z = axis.z;
			T xy = x * y,
			yz = y * z,
			xz = x * z;
			ret.c[0][0] = x * x * oneMinusC + c;
			ret.c[0][1] = x * y * oneMinusC - z * s;
			ret.c[0][2] = x * z * oneMinusC + y * s;
			ret.c[1][0] = y * x * oneMinusC + z * s;
			ret.c[1][1] = y * y * oneMinusC + c;
			ret.c[1][2] = y * z * oneMinusC - x * s;
			ret.c[2][0] = z * x * oneMinusC - y * s;
			ret.c[2][1] = z * y * oneMinusC + x * s;
			ret.c[2][2] = z * z * oneMinusC + c;
			return ret;
		}
	}
	static if (isSquare && R == 4 && isFloatingPoint!T) {
		/// Returns orthographic projection.
		static Matrix orthographic(T left, T right, T bottom, T top, T near, T far) pure nothrow @safe @nogc {
			T dx = right - left,
			dy = top - bottom,
			dz = far - near;
			T tx = -(right + left) / dx;
			T ty = -(top + bottom) / dy;
			T tz = -(far + near) / dz;
			return Matrix(2 / dx, 0, 0, tx, 0, 2 / dy, 0, ty, 0, 0, -2 / dz, tz, 0, 0, 0, 1);
		}
		/// Returns perspective projection.
		static Matrix perspective(T FOVInRadians, T aspect, T zNear, T zFar) pure nothrow @safe @nogc {
			T f = 1 / tan(FOVInRadians / 2);
			T d = 1 / (zNear - zFar);
			return Matrix(f / aspect, 0, 0, 0, 0, f, 0, 0, 0, 0, (zFar + zNear) * d, 2 * d * zFar * zNear, 0, 0, -1, 0);
		}
		/// Returns lookAt projection.
		static Matrix lookAt(Vector3!T eye, Vector3!T target, Vector3!T up) pure nothrow @safe @nogc {
			Vector3!T Z = (eye - target).normalized();
			Vector3!T X = cross(-up, Z).normalized();
			Vector3!T Y = cross(Z, -X);
			return Matrix(-X.x, -X.y, -X.z, dot(X, eye), Y.x, Y.y, Y.z, -dot(Y, eye), Z.x, Z.y, Z.z, -dot(Z, eye), 0, 0, 0, 1);
		}
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