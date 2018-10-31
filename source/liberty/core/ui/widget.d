/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/ui/widget.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.ui.widget;

import liberty.core.engine : CoreEngine;
import liberty.core.components.renderer : Renderer;
import liberty.core.material.impl : Material;
import liberty.core.math.matrix : Matrix4F;
import liberty.core.math.vector : Vector2I, Vector3F;
import liberty.core.model : GenericModel, UIModel;
import liberty.core.objects.bsp.impl : BSPVolume;
import liberty.core.objects.entity : Entity;
import liberty.core.objects.meta : NodeBody;
import liberty.core.objects.node : SceneNode;
import liberty.core.platform : Platform;
import liberty.core.ui.frame : Frame;
import liberty.graphics.vertex : GenericVertex, UIVertex;

import liberty.engine;

/**
 *
**/
abstract class Widget : IRenderable {
  /**
   * Renderer component used for rendering.
  **/
  Renderer!(UIVertex, Frame) renderer;

  private {
    string id;
    Frame frame;
    Transform2 transform;
  }

  /**
   *
  **/
  this(string id, Frame frame) {
    renderer = new Renderer!(UIVertex, Frame)(this, (new UIModel([Material.getDefault()])
      .build(uiSquareVertices, uiSquareIndices)));

    this.id = id;
    this.frame = frame;

    transform = new Transform2(this);
    frame.addWidget(this);
  }

  /**
   *
  **/
  final string getId() pure nothrow const {
    return id;
  }

  /**
   *
  **/
  final override void render() {
    renderer.draw();
  }

  /**
   *
  **/
  final Frame getFrame() pure nothrow {
    return frame;
  }

  /**
   *
  **/
  Transform2 getTransform() pure nothrow {
    return transform;
  }

  /**
   *
  **/
  bool isMouseInside() {
    Vector2F mousePos = Input.getMousePostion();
    return mousePos.x >= transform.getPosition.x - transform.getExtent.x / 2 && 
      mousePos.x <= transform.getPosition.x + transform.getExtent.x / 2 && 
      mousePos.y >= transform.getPosition.y - transform.getExtent.y / 2 && 
      mousePos.y <= transform.getPosition.y + transform.getExtent.y / 2;
  }

  /**
   * Returns reference to the current renderer component.
  **/
  Renderer!(UIVertex, Frame) getRenderer() {
    return renderer;
  }
}

private uint[6] uiSquareIndices = [
  0, 1, 2,
  0, 2, 3
];

private UIVertex[] uiSquareVertices = [
  UIVertex(Vector3F(-1.0f,  1.0f, 0.0f), Vector2F(0.0f, 1.0f)),
  UIVertex(Vector3F(-1.0f, -1.0f, 0.0f), Vector2F(0.0f, 0.0f)),
  UIVertex(Vector3F( 1.0f, -1.0f, 0.0f), Vector2F(1.0f, 0.0f)),
  UIVertex(Vector3F( 1.0f,  1.0f, 0.0f), Vector2F(1.0f, 1.0f))
];