/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/objects/bsp/square.d)
 * Documentation:
 * Coverage:
**/
module liberty.objects.bsp.square;

import liberty.math.vector;
import liberty.core.engine;
import liberty.components.renderer;
import liberty.objects.meta;
import liberty.model;
import liberty.surface.model;
import liberty.objects.bsp.impl;
import liberty.graphics.vertex;

import liberty.graphics.material.impl;

/**
 *
**/
final class BSPSquare : BSPVolume!GenericVertex {
	mixin(NodeBody);

  /**
   *
  **/
	BSPSquare build(Material material = Material.getDefault()) {
    renderer = new Renderer!GenericVertex(this, (new CoreModel([material])
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