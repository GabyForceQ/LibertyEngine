/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/objects/bsp/pyramid.d)
 * Documentation:
 * Coverage:
**/
module liberty.objects.bsp.pyramid;

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
final class BSPPyramid : BSPVolume!GenericVertex {
	mixin(NodeBody);

  /**
   *
  **/
	BSPPyramid build(Material material = Material.getDefault()) {
    renderer = new Renderer!GenericVertex(this, (new CoreModel([material])
      .build(pyramidVertices)));
    
    return this;
	}
}

private GenericVertex[36] pyramidVertices = [
  // back
  GenericVertex(Vector3F( 0.0f,  0.5f,  0.0f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.5f,  1.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  0.0f)),

  // front
  GenericVertex(Vector3F(-0.5f, -0.5f, 0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f, 0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F( 0.0f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.5f,  1.0f)),

  // left
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F( 0.0f,  0.5f,  0.0f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.5f,  1.0f)),

  // right
  GenericVertex(Vector3F(0.0f,  0.5f,  0.0f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.5f,  1.0f)),
  GenericVertex(Vector3F(0.5f, -0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F(0.5f, -0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),

  // bottom
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  GenericVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  0.0f))
];