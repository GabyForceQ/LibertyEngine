/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.math.matrix;
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
/// T = Type of elements.
/// R = Number of rows.
/// C = Number of columns.
/// O = Matrix order. It can be RowMajor or ColumnMajor.
struct Matrix(T, int R, int C, MatrixOrder O) if (R >= 2 && R <= 4 && C >= 2 && C <= 4) {
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
}
version (__RowMajor__) {
	///
	template Matrix2(T) {
		alias Matrix2 = Matrix!(T, 2, 2, MatrixOrder.RowMajor);
	}
	///
	template Matrix3(T) {
		alias Matrix3 = Matrix!(T, 3, 3, MatrixOrder.RowMajor);
	}
	///
	template Matrix4(T) {
		alias Matrix4 = Matrix!(T, 4, 4, MatrixOrder.RowMajor);
	}
	///
	template Matrix2x3(T) {
		alias Matrix2x3 = Matrix!(T, 2, 3, MatrixOrder.RowMajor);
	}
	///
	template Matrix2x4(T) {
		alias Matrix2x4 = Matrix!(T, 2, 4, MatrixOrder.RowMajor);
	}
	///
	template Matrix3x2(T) {
		alias Matrix3x2 = Matrix!(T, 3, 2, MatrixOrder.RowMajor);
	}
	///
	template Matrix3x4(T) {
		alias Matrix3x4 = Matrix!(T, 3, 4, MatrixOrder.RowMajor);
	}
	///
	template Matrix4x2(T) {
		alias Matrix4x2 = Matrix!(T, 4, 2, MatrixOrder.RowMajor);
	}
	///
	template Matrix4x3(T) {
		alias Matrix4x3 = Matrix!(T, 4, 3, MatrixOrder.RowMajor);
	}
} else {
	///
	template Matrix2(T) {
		alias Matrix2 = Matrix!(T, 2, 2, MatrixOrder.ColumnMajor);
	}
	///
	template Matrix3(T) {
		alias Matrix3 = Matrix!(T, 3, 3, MatrixOrder.ColumnMajor);
	}
	///
	template Matrix4(T) {
		alias Matrix4 = Matrix!(T, 4, 4, MatrixOrder.ColumnMajor);
	}
	///
	template Matrix2x3(T) {
		alias Matrix2x3 = Matrix!(T, 2, 3, MatrixOrder.ColumnMajor);
	}
	///
	template Matrix2x4(T) {
		alias Matrix2x4 = Matrix!(T, 2, 4, MatrixOrder.ColumnMajor);
	}
	///
	template Matrix3x2(T) {
		alias Matrix3x2 = Matrix!(T, 3, 2, MatrixOrder.ColumnMajor);
	}
	///
	template Matrix3x4(T) {
		alias Matrix3x4 = Matrix!(T, 3, 4, MatrixOrder.ColumnMajor);
	}
	///
	template Matrix4x2(T) {
		alias Matrix4x2 = Matrix!(T, 4, 2, MatrixOrder.ColumnMajor);
	}
	///
	template Matrix4x3(T) {
		alias Matrix4x3 = Matrix!(T, 4, 3, MatrixOrder.ColumnMajor);
	}
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