/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/objects/bsp/triangle.d)
 * Documentation:
 * Coverage:
**/
module liberty.objects.bsp.triangle;

import liberty.math.vector : Vector2F, Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.components.renderer : Renderer;
import liberty.objects.meta : NodeBody;
import liberty.model.core : CoreModel;
import liberty.objects.node : SceneNode;
import liberty.objects.bsp.impl : BSPVolume;
import liberty.graphics.vertex : GenericVertex;

import liberty.graphics.material.impl : Material;

/**
 *
**/
final class BSPTriangle : BSPVolume!GenericVertex {
	mixin(NodeBody);

  /**
   *
  **/
	BSPTriangle build(Material material = Material.getDefault()) {
    renderer = new Renderer!GenericVertex(this, (new CoreModel([material])
      .build(triangleVertices, triangleIndices)));

    return this;
	}
}

private GenericVertex[3] triangleVertices = [
  GenericVertex(Vector3F( 0.0f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.5f, 1.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 0.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 0.0f))
];

private uint[3] triangleIndices = [
  0, 1, 2
];
