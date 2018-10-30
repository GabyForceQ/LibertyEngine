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
import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.core.model : GenericModel, UIModel;
import liberty.core.objects.bsp.impl : BSPVolume;
import liberty.core.objects.entity : Entity;
import liberty.core.objects.meta : NodeBody;
import liberty.core.objects.node : WorldObject;
import liberty.core.platform : Platform;
import liberty.graphics.vertex : GenericVertex, UIVertex;

import liberty.engine;

/**
 *
**/
abstract class Widget : Entity!UIVertex {
  private {
    Vector2F position = Vector2F(10.0f, 10.0f);
    Vector2F extent = Vector2F(500.0f, 500.0f);
  }

  /**
   *
  **/
  this(string id, WorldObject parent) {
    super(id, parent);
    getTransform().scale(Vector3F(
      extent.x / Platform.getWindow().getWidth(),
      extent.y / Platform.getWindow().getHeight(),
      1.0f
    ));
    getTransform().setWorldPosition(Vector3F(
      ((2.0f * position.x) / Platform.getWindow().getWidth() - 1.0f) * Platform.getWindow().getWidth() / extent.x + 1.0f,
      ((2.0f * position.y) / Platform.getWindow().getHeight() - 1.0f) * -Platform.getWindow().getHeight() / extent.y - 1.0f,
      0));
  }

  /**
   *
  **/
  override void render() {
    super.render();
  }

  /**
   *
  **/
	Widget build(Material material) {
    renderer = Renderer!UIVertex(this, (new UIModel([material])
      .build(uiSquareVertices, uiSquareIndices)));

    return this;
	}

  /**
   *
  **/
  Widget setPosition(string op = "=")(Vector2F position) {
    this.position = position;
    getTransform().setWorldPosition!op(Vector3F(
      ((2.0f * position.x) / Platform.getWindow().getWidth() - 1.0f) * Platform.getWindow().getWidth() / extent.x + 1.0f,
      ((2.0f * position.y) / Platform.getWindow().getHeight() - 1.0f) * -Platform.getWindow().getHeight() / extent.y - 1.0f,
      0
    ));
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
    getTransform().scale(Vector3F(
      extent.x / Platform.getWindow().getWidth(),
      extent.y / Platform.getWindow().getHeight(),
      1.0f
    ));
    return this;
  }

  /**
   *
  **/
  Vector2F getExtent() {
    return extent;
  }

  /**
   *
  **/
  override void update() {
    Vector2F normalizedCoords = Input.getNormalizedDeviceCoords();
    //if (normalizedCoords.x >= position.x && normalizedCoords.y >= position.y)
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