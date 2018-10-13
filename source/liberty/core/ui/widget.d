/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/ui/widget.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.ui.widget;

import liberty.core.math.vector : Vector2F;
import liberty.core.objects.bsp.square : UISquare;
import liberty.core.objects.entity : Entity;
import liberty.core.objects.meta : NodeBody;
import liberty.graphics.vertex : UIVertex;

/**
 *
**/
final class Widget : Entity!UIVertex {
  mixin(NodeBody);

  private {
    Vector2F position;
    Vector2F extent;
    UISquare shape;
  }

  /**
   *
  **/
  void constructor() {
    shape = spawn!UISquare("WidgetSqare");
  }

  /**
   *
  **/
  Widget setPosition(Vector2F position) {
    this.position = position;
    return this;
  }

  /**
   *
  **/
  Vector2F getPosition() {
    return position;
  }

  /**
   *
  **/
  Widget setExtent(Vector2F extent) {
    this.extent = extent;
    return this;
  }

  /**
   *
  **/
  Vector2F getExtent() {
    return extent;
  }
}