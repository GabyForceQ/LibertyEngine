module liberty.core.math.util;

import std.traits : isFloatingPoint;

import liberty.core.math.matrix : Matrix4;

/**
 *
**/
final class MathUtils {
  /**
   * Returns orthographic projection.
  **/
  static Matrix4!T getOrthographicMatrixFrom(T)
  (T left, T right, T bottom, T top, T near, T far) pure nothrow
  if (isFloatingPoint!T) 
  do {
    T dx = right - left;
    T dy = top - bottom;
    T dz = far - near;
    
    T tx = -(right + left) / dx;
    T ty = -(top + bottom) / dy;
    T tz = -(far + near) / dz;

    return Matrix4!T(
      2 / dx, 0, 0, tx, 
      0, -2 / dy, 0, ty, 
      0, 0, -2 / dz, tz, 
      0, 0, 0, 1
    );
  }
}