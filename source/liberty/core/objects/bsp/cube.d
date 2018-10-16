/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/bsp/cube.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.bsp.cube;

import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.core.components.renderer : Renderer;
import liberty.core.objects.meta : NodeBody;
import liberty.core.model.generic : GenericModel;
import liberty.core.objects.node : WorldObject;
import liberty.core.objects.bsp.impl : BSPVolume;
import liberty.graphics.vertex : GenericVertex;

import liberty.core.material.impl : Material;

/**
 *
**/
final class BSPCube : BSPVolume!GenericVertex {
	mixin(NodeBody);

  /**
   *
  **/
	BSPCube build(Material material = Material.getDefault()) {
    renderer = Renderer!GenericVertex(this, (new GenericModel([material])
      .build(cubeVertices)));

    return this;
	}
}

private GenericVertex[36] cubeVertices = [
  // back
  GenericVertex(Vector3F( 0.5f,  0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f,  0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f,  0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  1.0f)),

  // front
  GenericVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  1.0f)),
  GenericVertex(Vector3F(-0.5f,  0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  0.0f)),

  // left
  GenericVertex(Vector3F(-0.5f,  0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F(-0.5f,  0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f,  0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),

  // right
  GenericVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F( 0.5f,  0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),

  // bottom
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  0.0f)),

  // top
  GenericVertex(Vector3F( 0.5f, 0.5f,  0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f, 0.5f, -0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, 0.5f, -0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, 0.5f, -0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, 0.5f,  0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f, 0.5f,  0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(1.0f,  1.0f))
];