module liberty.core.ui.frame;

import liberty.core.math.matrix : Matrix4F;
import liberty.core.math.util : MathUtils;
import liberty.core.objects.node : SceneNode;
import liberty.core.platform : Platform;
import liberty.core.scene.impl : Scene;
import liberty.core.ui.widget : Widget;
import liberty.core.services : IRenderable;

/**
 *
**/
abstract class Frame : SceneNode, IRenderable {
  private {
    int xStart;
    int yStart;
    int width;
    int height;
    int zNear = -1;
    int zFar = 1;

    Matrix4F projectionMatrix = Matrix4F.identity();
    Widget[string] widgets;
  }

  /**
   *
  **/
  this(string id, SceneNode parent) {
    super(id, parent);
    updateProjection();
  }

  /**
   *
  **/
  package final Frame addWidget(Widget widget) {
    widgets[widget.getId()] = widget;
    return this;
  }
  
  /**
   *
  **/
  final Frame updateProjection(bool autoScale = true) {
    if (autoScale) {
      width = Platform.getWindow().getWidth();
      height = Platform.getWindow().getHeight();
    }
    
    projectionMatrix = MathUtils.getOrthographicMatrixFrom(
      cast(float)xStart, cast(float)width,
      cast(float)height, cast(float)yStart,
      cast(float)zNear, cast(float)zFar
    );
    
    getScene().getUIShader().loadProjectionMatrix(projectionMatrix);
    return this;
  }

  /**
   *
  **/
  final Matrix4F getProjectionMatrix() pure nothrow const {
    return projectionMatrix;
  }

  /**
   *
  **/
  final override void render() {
    foreach (w; widgets)
      w.render();
  }
}