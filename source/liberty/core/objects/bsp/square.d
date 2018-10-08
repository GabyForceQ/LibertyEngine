/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/bsp/square.d, _square.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.bsp.square;

import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.core.components.renderer : Renderer;
import liberty.core.objects.meta : NodeBody;
import liberty.core.model.impl : Model;
import liberty.core.objects.bsp.impl : BSPVolume;
import liberty.graphics.vertex : Vertex;

/**
 *
**/
final class BSPSquare : BSPVolume {
	mixin(NodeBody);

  /**
   *
  **/
	void constructor() {
    renderer = Renderer(this, (new Model()
      .build(squareVertices, squareIndices, "res/textures/default.bmp")));
	}

  /**
   *
  **/
  override void render() {
    renderer.draw();
  }
}

private Vertex[] squareVertices = [
  Vertex(Vector3F(-0.5f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 1.0f)),
  Vertex(Vector3F(-0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 0.0f)),
  Vertex(Vector3F( 0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 0.0f)),
  Vertex(Vector3F( 0.5f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 1.0f))
];

private uint[6] squareIndices = [
  0, 1, 2,
  0, 2, 3
];