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
    Vector2I position = Vector2I(10, 10);
    Vector2I extent = Vector2I(200, 200);
  }

  /**
   *
  **/
  this(string id, Frame frame) {
    renderer = Renderer!(UIVertex, Frame)(this, (new UIModel([Material.getDefault()])
      .build(uiSquareVertices, uiSquareIndices)));

    this.id = id;
    this.frame = frame;
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


  Matrix4F getModelMatrix() {
    return Matrix4F();
  }

/*
  this(string id, SceneNode parent) {

    getTransform().scale(Vector3F(
      cast(float)extent.x / 2.0f,
      cast(float)extent.y / 2.0f,
      1.0f
    ));
    
    getTransform().setWorldPosition(Vector3F(
      cast(float)position.x / extent.x * 2.0f + 1.0f,
      cast(float)-position.y / extent.y * 2.0f - 1.0f,
      0.0f
    ));
  }


	Widget build(Material material) {
    renderer = Renderer!UIVertex(this, (new UIModel([material])
      .build(uiSquareVertices, uiSquareIndices)));

    return this;
	}

  Widget setPosition(string op = "=")(Vector2I position) {
    mixin("this.position " ~ op ~ " position;");
    
    static if (op == "=") {
      float xPos = cast(float)position.x / extent.x * 2.0f + 1.0f;
      float yPos = cast(float)-position.y / extent.y * 2.0f - 1.0f;
    } else static if (op == "+=" || op == "-=") {
      float xPos = cast(float)position.x / extent.x * 2.0f;
      float yPos = cast(float)-position.y / extent.y * 2.0f;
    } else
      static assert(0, "Only =, +=, -= acceped.");

    getTransform().setWorldPosition!op(Vector3F(xPos, yPos, 0.0f));

    return this;
  }


  Vector2I getPosition() {
    return position;
  }


  Widget setExtent(Vector2I extent) { // todo set scale
    this.extent = extent;

    getTransform().scale(Vector3F(
      cast(float)extent.x,
      cast(float)extent.y,
      1.0f
    ));
    
    return this;
  }

  Vector2I getExtent() {
    return extent;
  }

  bool isMouseInside() {
    Vector2F mousePos = Input.getMousePostion();
    return mousePos.x >= position.x && mousePos.x <= position.x + extent.x && mousePos.y >= position.y && mousePos.y <= position.y + extent.y;
  }*/
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