/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:			    $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/math/matrix.d, _matrix.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.math.matrix;
import liberty.core.math.vector : Vector;
import liberty.core.math.traits : isMatrixInstance;
import liberty.config : __RowMajor__, __ColumnMajor__;
import std.traits : isFloatingPoint;

import liberty.core.math.functions;
import liberty.core.math.vector;

///
enum MatrixOrder : ubyte {
	///
	RowMajor = 0x00,
	///
	ColumnMajor = 0x01
}
static if (__RowMajor__) {
	enum CurrentMatrixOrder = MatrixOrder.RowMajor;
} else {
	enum CurrentMatrixOrder = MatrixOrder.ColumnMajor;
}
/// T = Type of elements.
/// R = Number of rows.
/// C = Number of columns.
/// O = Matrix order. It can be RowMajor or ColumnMajor.
struct Matrix(T, ubyte R, ubyte C = R, MatrixOrder O = CurrentMatrixOrder) if (R >= 2 && R <= 4 && C >= 2 && C <= 4) {
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
		///
		this(U...)(U values) pure nothrow @safe {
			import std.meta : allSatisfy;
			import std.traits : isAssignable;
			enum bool isAsgn(U) = isAssignable!(T, U);
			static if ((U.length == C * R) && allSatisfy!(isAsgn, U)) {
				static foreach (i, x; values) {
					v[i] = x;
				}
			} else static if ((U.length == 1) && isAsgn!U && (!is(U[0] : Matrix))) {
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
		static Matrix fromColumns(ColumnType[] columns) pure nothrow @safe
		in {
			assert(columns.length == C);
		} do {
			Matrix ret = void;
			// todo
			return ret;
		}
		///
		pure nothrow @safe unittest {
			// todo
		}
		/// Construct a matrix from rows.
		static Matrix fromRows(RowType[] rows) pure nothrow @safe
		in {
			assert(rows.length == R);
		} do {
			Matrix ret = void;
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
		static Matrix identity() pure nothrow @safe {
			Matrix ret = void;
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
		static Matrix constant(U)(U x) pure nothrow @safe {
			Matrix ret = void;
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
		ColumnType column(int j) pure nothrow const @safe {
			ColumnType ret = void;
			static foreach (i; 0..R) {
				ret.v[i] = c[i][j];
			}
			return ret;
		}
		///
		Matrix opBinary(string op)(T factor) pure nothrow const @safe if (op == "*") {
			Matrix ret = void;
			static foreach (i; 0..R) {
				static foreach (j; 0..C) {
					ret.c[i][j] = c[i][j] * factor;
				}
			}
			return ret;
		}
		///
		pure nothrow @safe unittest {
			auto m1 = Matrix2I(3);
			auto m2 = m1 * 4;
			assert (m2.v == [12, 12, /**/ 12, 12]);
		}
		///
		ColumnType opBinary(string op)(RowType x) pure nothrow const @safe if (op == "*") {
			ColumnType ret = void;
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
		auto opBinary(string op, U)(U x) pure nothrow const @safe if (isMatrixInstance!U && (U.rowCount == C) && (op == "*")) {
			Matrix!(T, R, U.columnCount) ret = void;
			T sum = 0;
			static foreach (i; 0..R) {
				static foreach (j; 0..U.columnCount) {
					static foreach (k; 0..C) {
						sum += c[i][k] * x.c[k][j];
					}
					ret.c[i][j] = sum;
					sum = 0;
				}
			}
			return ret;
		}
		///
		pure nothrow @safe unittest {
			auto m1 = Matrix2I(2, 5, /**/ -1, 2);
			auto m2 = Matrix2x3I(3, 3, -2, /**/ 3, 4, 3);
			auto m3 = m1 * m2;
			assert (m3.v == [21, 26, 11, /**/ 3, 5, 8]);
		}
		///
		Matrix opBinary(string op, U)(U rhs) pure nothrow const @safe if (op == "+" || op == "-") {
			Matrix ret = void;
			static if (is (U : Matrix)) {
				static foreach (i; 0..R) {
					static foreach (j; 0..C) {
						mixin("ret.c[i][j] = c[i][j] " ~ op ~ " rhs.c[i][j];");
					}
				}
			} else static if (is (U : T)) {
				mixin("ret.v[] = this.v[] " ~ op ~ " rhs;");
			} else {
				static assert (0, "Cannot assign a variable of type " ~ U.stringof ~ " within a variable of type " ~ Matrix.stringof);
			}
			return ret;
		}
		///
		pure nothrow @safe unittest {
			auto m1 = Matrix2I(1, 3, /**/ -1, 4);
			auto m2 = Matrix2I(5, 2, /**/ 1, 0);
			auto m3 = m1 + m2;
			assert (m3.v == [6, 5, /**/ 0, 4]);
			auto m4 = m1 - 7;
			assert (m4.v == [-6, -4, /**/ -8, -3]);
		}
		///
		ref Matrix opOpAssign(string op, U)(U rhs) pure nothrow @safe {
			static if (is(U : Matrix) || is(U : T)) {
				mixin("this = this " ~ op ~ " rhs;");
			} else {
				static assert (0, "Cannot assign a variable of type " ~ U.stringof ~ " within a variable of type " ~ Matrix.stringof);
			}
			return this;
		}
		///
		pure nothrow @safe unittest {
			auto m1 = Matrix2I(1, 3, /**/ -1, 4);
			auto m2 = Matrix2I(5, 2, /**/ 1, 0);
			m1 += m2;
			assert (m1.v == [6, 5, /**/ 0, 4]);
			m1 -= 2;
			assert (m1.v == [4, 3, /**/ -2, 2]);
		}
		///
		Matrix opUnary(string op)() pure nothrow const @safe if (op == "+" || op == "-" || op == "~" || op == "!") {
			Matrix ret = void;
			static foreach (i; 0..R * C) {
				mixin("ret.v[i] = " ~ op ~ "v[i];");
			}
			return ret;
		}
		///
		pure nothrow @safe unittest {
			auto m1 = Matrix2I(1, 3, /**/ -1, 0);
			assert ((+m1).v == [1, 3, /**/ -1, 0]);
			assert ((-m1).v == [-1, -3, /**/ 1, 0]);
			assert ((~m1).v == [-2, -4, /**/ 0, -1]);
			// *** BUG ***
			//auto m2 = Matrix!(bool, 2)(true, true, /**/ false, false);
			//assert ((!m2).v == [false, false, /**/ true, true]);
		}
		///
		U opCast(U)() pure nothrow const @safe if (isMatrixInstance!U && U.rowCount == rowCount && U.columnCount == columnCount) {
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
		pure nothrow @safe unittest {
			auto m1 = Matrix2F(3.2f, 4.5f, /**/ 3.8f, -7.2f);
			Matrix2I m2 = cast(Matrix2I)m1;
			assert (m2.v == [3, 4, /**/ 3, -7]);
		}
		///
		bool opEquals(U)(U rhs) pure nothrow const @safe {
			static if (is(U : Matrix)) {
				static foreach (i; 0..R * C) {
					if (v[i] != rhs.v[i]) {
						return false;
					}
				}
			} else static if (is(U : T)) {
				static foreach (i; 0..R * C) {
					if (v[i] != rhs) {
						return false;
					}
				}
			} else {
				static assert (0, "Cannot compare a variable of type " ~ U.stringof ~ " with a variable of type " ~ Matrix.stringof);
			}
			return true;
		}
		///
		pure nothrow @safe unittest {
			auto m1 = Matrix2I(6, 3, /**/ -1, 0);
			auto m2 = Matrix2I(6, 3, /**/ -1, 0);
			auto m3 = Matrix2I(1, 4, /**/ -1, 7);
			assert (m1 == m2);
			assert (m1 != m3);
			auto m4 = Matrix2I(3, 3, /**/ 3, 3);
			assert (m4 == 3);
			assert (m4 != -3);
		}
		/// Returns a pointer to content.
		inout(T)* ptr() pure nothrow inout {
			return v.ptr;
		}
		static if (isFloatingPoint!T && R == 2 && C == 2) {
			/// Returns inverse of matrix 2x2.
			Matrix inverse() pure nothrow const @safe {
				T invDet = 1 / (c[0][0] * c[1][1] - c[0][1] * c[1][0]);
				return Matrix(c[1][1] * invDet, -c[0][1] * invDet, -c[1][0] * invDet, c[0][0] * invDet);
			}
			///
			pure nothrow @safe unittest {
				import std.math : approxEqual;
				auto m1 = Matrix2D(2.0, 3.0, /**/ -1.0, 5.0);
				auto m2 = m1.inverse();
				assert (m2.v[0].approxEqual(0.384615));
				assert (m2.v[1].approxEqual(-0.230769));
				assert (m2.v[2].approxEqual(0.0769231));
				assert (m2.v[3].approxEqual(0.153846));
			}
		}
		static if (isFloatingPoint!T && R == 3 && C == 3) {
			/// Returns inverse of matrix 3x3.
			Matrix inverse() pure nothrow const @safe {
				T det = c[0][0] * (c[1][1] * c[2][2] - c[2][1] * c[1][2]) - c[0][1] * (c[1][0] * c[2][2] - c[1][2] * c[2][0]) + c[0][2] * (c[1][0] * c[2][1] - c[1][1] * c[2][0]);
				T invDet = 1 / det;
				Matrix ret = void;
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
			///
			pure nothrow @safe unittest {
			}
		}
		static if (isFloatingPoint!T && R == 4 && C == 4) {
			/// Returns inverse of matrix 4x4.
			Matrix inverse() pure nothrow const @safe {
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
				Matrix ret = void;
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
			///
			pure nothrow @safe unittest {
			}
		}
		/// Returns transposed matrix.
		Matrix!(T, C, R) transposed() pure nothrow const @safe {
			Matrix!(T, C, R) ret = void;
			static foreach (i; 0..C) {
				static foreach (j; 0..R) {
					ret.c[i][j] = c[j][i];
				}
			}
			return ret;
		}
		///
		pure nothrow @safe unittest {
			auto m1 = Matrix2I(4, 5, /**/ -1, 0);
			assert (m1.transposed().v == [4, -1, /**/ 5, 0]);
		}
		static if (isSquare && R > 2) {
			/// Makes a diagonal matrix from a vector.
			static Matrix diag(Vector!(T, R) v) pure nothrow @safe {
				Matrix ret = void;
				static foreach (i; 0..R) {
					static foreach (j; 0..C) {
						ret.c[i][j] = (i == j) ? v.v[i] : 0;
					}
				}
				return ret;
			}
			///
			pure nothrow @safe unittest {
				auto v1 = Vector!(int, 3)(4, 5, -1);
				auto m1 = Matrix!(int, 3).diag(v1);
				assert (m1.v == [4, 0, 0, /**/ 0, 5, 0, /**/ 0, 0, -1]);
			}
			/// In-place translate by (v, 1).
			void translate(Vector!(T, R-1) v) pure nothrow @safe {
				T _dot = 0;
				static foreach (i; 0..R) {
					static foreach (j; 0..C - 1) {
						_dot += v.v[j] * c[i][j];
					}
					c[i][C - 1] += _dot;
					_dot = 0;
				}
			}
			///
			pure nothrow @safe unittest {
			}
			/// Make a translation matrix.
			static Matrix translation(Vector!(T, R-1) v) pure nothrow @safe {
				Matrix ret = identity();
				static foreach (i; 0..R - 1) {
					ret.c[i][C - 1] += v.v[i];
				}
				return ret;
			}
			///
			pure nothrow @safe unittest {
			}
			/// In-place matrix scaling.
			void scale(Vector!(T, R-1) v) pure nothrow @safe {
				static foreach (i; 0..R) {
					static foreach (j; 0..C - 1) {
						c[i][j] *= v.v[j];
					}
				}
			}
			///
			pure nothrow @safe unittest {
			}
			/// Make a scaling matrix.
			static Matrix scaling(Vector!(T, R-1) v) pure nothrow @safe {
				Matrix ret = identity();
				static foreach (i; 0..R - 1) {
					ret.c[i][i] = v.v[i];
				}
				return ret;
			}
			///
			pure nothrow @safe unittest {
			}
		}
		static if (isSquare && (R == 3 || R == 4) && isFloatingPoint!T) {
			///
			static Matrix rotateAxis(int i, int j)(T angle) pure nothrow @safe {
				import liberty.core.math.functions : sin, cos;
				Matrix ret = identity();
				const T cosa = cos(angle);
				const T sina = sin(angle);
				ret.c[i][i] = cosa;
				ret.c[i][j] = -sina;
				ret.c[j][i] = sina;
				ret.c[j][j] = cosa;
				return ret;
			}
			///
			pure nothrow @safe unittest {
			}
			/// Returns rotation matrix along axis X.
			alias rotateXAxix = rotateAxis!(1, 2);
			/// Returns rotation matrix along axis Y.
			alias rotateYAxis = rotateAxis!(2, 0);
			/// Returns rotation matrix along axis Z.
			alias rotateZAxis = rotateAxis!(0, 1);
			/// In-place rotation by (v, 1)
			void rotate(T angle, Vector!(T, 3) axis) pure nothrow @safe {
				this = rotation(angle, axis, this);
			}
			///
			pure nothrow @safe unittest {
			}
			///
			void rotateX(T angle) pure nothrow @safe {
				this = rotation(angle, Vector!(T, 3)(1, 0, 0), this);
			}
			///
			pure nothrow @safe unittest {
			}
			///
			void rotateY(T angle) pure nothrow @safe {
				this = rotation(angle, Vector!(T, 3)(0, 1, 0), this);
			}
			///
			pure nothrow @safe unittest {
			}
			///
			void rotateZ(T angle) pure nothrow @safe {
				this = rotation(angle, Vector!(T, 3)(0, 0, 1), this);
			}
			///
			pure nothrow @safe unittest {
			}
			///
			static Matrix rotation(T angle, Vector!(T, 3) axis, Matrix m = identity()) pure nothrow @safe {
				import liberty.core.math.functions : sin, cos;
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
			///
			pure nothrow @safe unittest {
			}
		}
		static if (isSquare && R == 4 && isFloatingPoint!T) {
      ///
      //static Matrix orthographic(T left, T right, T bottom, T top) pure nothrow @safe {
      //  return Matrix(
      //    (2) / (right - left), 0, 0, 0,
      //    0, (2) / (top - bottom), 0, 0,
      //    0, 0, -1, 0,
      //    -(right + left) / (right - left), -(top + bottom) / (top - bottom), 0, 0
      //  );
			//}
			/// Returns orthographic projection.
			static Matrix orthographic(T left, T right, T bottom, T top, T near, T far) pure nothrow @safe {
				T dx = right - left;
				T dy = top - bottom;
				T dz = far - near;
				T tx = -(right + left) / dx;
				T ty = -(top + bottom) / dy;
				T tz = -(far + near) / dz;
				return Matrix(
          2 / dx,      0,       0, tx, 
               0, 2 / dy,       0, ty, 
               0,      0, -2 / dz, tz, 
               0,      0,       0,  1
        );
			}
			///
			pure nothrow @safe unittest {
			}
			/// Returns perspective projection.
			static Matrix perspective(T FOVInRadians, T aspect, T zNear, T zFar) pure nothrow @safe {
				import liberty.core.math.functions : tan;
				T f = 1 / tan(FOVInRadians / 2);
				T d = 1 / (zNear - zFar);
				return Matrix(f / aspect, 0, 0, 0, 0, f, 0, 0, 0, 0, (zFar + zNear) * d, 2 * d * zFar * zNear, 0, 0, -1, 0);
			}
			///
			pure nothrow @safe unittest {
			}
			/// Returns lookAt projection.
			static Matrix lookAt(Vector!(T, 3) eye, Vector!(T, 3) target, Vector!(T, 3) up) pure nothrow @safe {
				import liberty.core.math.vector : dot, cross;
				Vector!(T, 3) Z = (eye - target).normalized();
				Vector!(T, 3) X = cross(-up, Z).normalized();
				Vector!(T, 3) Y = cross(Z, -X);
				return Matrix(-X.x, -X.y, -X.z, dot(X, eye), Y.x, Y.y, Y.z, -dot(Y, eye), Z.x, Z.y, Z.z, -dot(Z, eye), 0, 0, 0, 1);
			}
      /// Returns camera projection
      static Matrix camera(Vector!(T, 3) forward, Vector!(T, 3) up) {
        Vector!(T, 3) f = forward;
        f.normalize();

        Vector!(T, 3) r = up;
        r.normalize();
        r = r.cross(f);

        Vector!(T, 3) u = f.cross(r);
        
        return Matrix(
          r.x, r.y, r.z, 0.0f,
          u.x, u.y, u.z, 0.0f,
          f.x, f.y, f.z, 0.0f,
          0.0f, 0.0f, 0.0f, 1.0f
        );
      }
			///
			pure nothrow @safe unittest {
			}
		}
	} else {

	}
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
alias Matrix2I = Matrix2!int;
///
alias Matrix3I = Matrix3!int;
///
alias Matrix4I = Matrix4!int;
///
alias Matrix2F = Matrix2!float;
///
alias Matrix3F = Matrix3!float;
///
alias Matrix4F = Matrix4!float;
///
alias Matrix2D = Matrix2!double;
///
alias Matrix3D = Matrix3!double;
///
alias Matrix4D = Matrix4!double;
///
alias Matrix2x3I = Matrix2x3!int;
///
alias Matrix2x4I = Matrix2x4!int;
///
alias Matrix3x2I = Matrix3x2!int;
///
alias Matrix2x3F = Matrix2x3!float;
///
alias Matrix2x4F = Matrix2x4!float;
///
alias Matrix3x2F = Matrix3x2!float;
///
alias Matrix2x3D = Matrix2x3!double;
///
alias Matrix2x4D = Matrix2x4!double;
///
alias Matrix3x2D = Matrix3x2!double;
///
alias Matrix3x4I = Matrix3x4!int;
///
alias Matrix4x2I = Matrix4x2!int;
///
alias Matrix4x3I = Matrix4x3!int;
///
alias Matrix3x4F = Matrix3x4!float;
///
alias Matrix4x2F = Matrix4x2!float;
///
alias Matrix4x3F = Matrix4x3!float;
///
alias Matrix3x4D = Matrix3x4!double;
///
alias Matrix4x2D = Matrix4x2!double;
///
alias Matrix4x3D = Matrix4x3!double;
///
final class MatrixStack(int R, T) if (R == 3 || R == 4) {
	private {
		size_t _top;
		size_t _depth;
		MatrixType* _matrices;
		MatrixType* _invMatrices;
	}
	///
	alias MatrixType = Matrix!(T, R, R);
	/// Creates a matrix stack.
	this(size_t depth = 32) nothrow @trusted
	in {
		assert(depth > 0);
	} do {
		import core.stdc.stdlib : malloc;
		size_t memory_needed = MatrixType.sizeof * depth * 2;
		void* data = malloc(memory_needed * 2);
		_matrices = cast(MatrixType*)data;
		_invMatrices = cast(MatrixType*)(data + memory_needed);
		_top = 0;
		_depth = depth;
		loadIdentity();
	}
	/// Relases the matrix stack memory.
	~this() {
		if (_matrices !is null) {
			import core.stdc.stdlib : free;
			//import liberty.core.memory : ensureNotInGC;
			//ensureNotInGC("MatrixStack");
			free(_matrices);
			_matrices = null;
		}
	}
	///
	void loadIdentity() pure nothrow @trusted {
		_matrices[_top] = MatrixType.identity();
		_invMatrices[_top] = MatrixType.identity();
	}
	///
	void push() pure nothrow @trusted {
		if(_top + 1 >= _depth) {
			assert(false, "Matrix stack is full!");
		}
		_matrices[_top + 1] = _matrices[_top];
		_invMatrices[_top + 1] = _invMatrices[_top];
		_top++;
	}
	/// Replacement for $(D glPopMatrix).
	void pop() pure nothrow @safe {
		if (_top <= 0) {
			assert(false, "Matrix stack is empty!");
		}
		_top--;
	}
	///
	MatrixType top() pure const nothrow @trusted {
		return _matrices[_top];
	}
	///
	MatrixType invTop() pure const nothrow @trusted {
		return _invMatrices[_top];
	}
	///
	void top(MatrixType m) pure nothrow @trusted {
		_matrices[_top] = m;
		_invMatrices[_top] = m.inverse();
	}
	///
	void mult(MatrixType m) pure nothrow @trusted {
		mult(m, m.inverse());
	}
	///
	void mult(MatrixType m, MatrixType invM) pure nothrow @trusted {
		_matrices[_top] = _matrices[_top] * m;
		_invMatrices[_top] = invM *_invMatrices[_top];
	}
	///
	void translate(Vector!(T, R-1) v) pure nothrow @safe {
		mult(MatrixType.translation(v), MatrixType.translation(-v));
	}
	///
	void scale(Vector!(T, R-1) v) pure nothrow @safe {
		mult(MatrixType.scaling(v), MatrixType.scaling(1 / v));
	}
	static if (R == 4) {
		///
		void rotate(T angle, Vector!(T, 3) axis) pure nothrow @safe {
			MatrixType rot = MatrixType.rotation(angle, axis);
			mult(rot, rot.transposed());
		}
		///
		void perspective(T FOVInRadians, T aspect, T zNear, T zFar) pure nothrow @safe {
			mult(MatrixType.perspective(FOVInRadians, aspect, zNear, zFar));
		}
		///
		void orthographic(T left, T right, T bottom, T top, T near, T far) pure nothrow @safe {
			mult(MatrixType.orthographic(left, right, bottom, top, near, far));
		}
		///
		void lookAt(Vector!(T, 3) eye, Vector!(T, 3) target, Vector!(T, 3) up) pure nothrow @safe {
			mult(MatrixType.lookAt(eye, target, up));
		}
	}
}
///
unittest {
    auto m = new MatrixStack!(4, double)();
    scope(exit) destroy(m);
    m.loadIdentity();
    m.push();
    m.pop();
    m.translate(Vector!(double, 3)(2.4, 3.3, 7.5));
    m.scale(Vector!(double, 3)(0.7));
    auto t = new MatrixStack!(3, float)();
    scope(exit) destroy(t);
    t.loadIdentity();
    t.push();
    t.pop();
    t.translate(Vector!(float, 2)(1, -8));
    t.scale(Vector!(float, 2)(0.2));
}
