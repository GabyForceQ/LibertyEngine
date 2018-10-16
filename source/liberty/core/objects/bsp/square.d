/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/bsp/square.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.bsp.square;

import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.core.components.renderer : Renderer;
import liberty.core.objects.meta : NodeBody;
import liberty.core.model : GenericModel, UIModel;
import liberty.core.objects.bsp.impl : BSPVolume;
import liberty.graphics.vertex : GenericVertex, UIVertex;

import liberty.core.material.impl : Material;

/**
 *
**/
final class BSPSquare : BSPVolume!GenericVertex {
	mixin(NodeBody);

  /**
   *
  **/
	BSPSquare build(Material material = Material.getDefault()) {
    renderer = Renderer!GenericVertex(this, (new GenericModel([material])
      .build(squareVertices, squareIndices)));

    return this;
	}
}

private GenericVertex[] squareVertices = [
  GenericVertex(Vector3F(-0.5f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 1.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 0.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 0.0f)),
  GenericVertex(Vector3F( 0.5f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 1.0f))
];

private uint[6] squareIndices = [
  0, 1, 2,
  0, 2, 3
];

/**
 *
**/
final class UISquare : BSPVolume!UIVertex {
  mixin(NodeBody);

  /**
   *
  **/
	UISquare build(Material material) {
    renderer = Renderer!UIVertex(this, (new UIModel([material])
      .build(uiSquareVertices, squareIndices)));

    return this;
	}
}

private UIVertex[] uiSquareVertices = [
  UIVertex(Vector3F(-0.02f,  0.02f, 0.0f), Vector2F(0.0f, 1.0f)),
  UIVertex(Vector3F(-0.02f, -0.02f, 0.0f), Vector2F(0.0f, 0.0f)),
  UIVertex(Vector3F( 0.02f, -0.02f, 0.0f), Vector2F(1.0f, 0.0f)),
  UIVertex(Vector3F( 0.02f,  0.02f, 0.0f), Vector2F(1.0f, 1.0f))
];