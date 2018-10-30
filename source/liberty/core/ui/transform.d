module liberty.core.ui.transform;

import liberty.core.math.matrix : Matrix4F;
import liberty.core.math.util : MathUtils;
import liberty.core.ui.widget : Widget;

/**
 *
**/
final class Transform2 {
  private {
    Widget parent;
  }

  /**
   *
  **/
  this(Widget parent) {
    this.parent = parent;
  }
}