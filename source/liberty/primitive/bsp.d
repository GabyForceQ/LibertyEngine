/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/primitive/bsp.d)
 * Documentation:
 * Coverage:
**/
module liberty.primitive.bsp;

import liberty.scene.meta;
import liberty.graphics.material.impl;
import liberty.math.vector;
import liberty.scene.node;
import liberty.graphics.renderer;
import liberty.primitive.model;
import liberty.primitive.vertex;
import liberty.terrain.vertex;
import liberty.primitive.impl;

/**
 *
**/
abstract class BSPVolume : Primitive {
  /**
   *
  **/
  this(string id, SceneNode parent) {
    super(id, parent);
  }

  /**
   *
  **/
  override void render() {
    getScene()
      .getPrimitiveSystem()
      .getShader()
      .loadUseFakeLighting(
        renderer
          .getModel()
          .getUseFakeLighting()
      );

    super.render();
  }
}

/**
 *
**/
final class BSPCube : BSPVolume {
	mixin NodeConstructor;

  /**
   *
  **/
	BSPCube build(Material material = Material.getDefault()) {
    renderer = new Renderer!PrimitiveVertex(this, (new PrimitiveModel([material])
      .build(cubeVertices)));

    return this;
	}
}

/**
 *
**/
final class BSPPyramid : BSPVolume {
	mixin NodeConstructor;

  /**
   *
  **/
	BSPPyramid build(Material material = Material.getDefault()) {
    renderer = new Renderer!PrimitiveVertex(this, (new PrimitiveModel([material])
      .build(pyramidVertices)));
    
    return this;
	}
}

/**
 *
**/
final class BSPSquare : BSPVolume {
	mixin NodeConstructor;

  /**
   *
  **/
	BSPSquare build(Material material = Material.getDefault()) {
    renderer = new Renderer!PrimitiveVertex(this, (new PrimitiveModel([material])
      .build(squareVertices, squareIndices)));

    return this;
	}
}

/**
 *
**/
final class BSPTriangle : BSPVolume {
	mixin NodeConstructor;

  /**
   *
  **/
	BSPTriangle build(Material material = Material.getDefault()) {
    renderer = new Renderer!PrimitiveVertex(this, (new PrimitiveModel([material])
      .build(triangleVertices, triangleIndices)));

    return this;
	}
}

private PrimitiveVertex[36] cubeVertices = [
  // back
  PrimitiveVertex(Vector3F( 0.5f,  0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  1.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F(-0.5f,  0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  1.0f)),
  PrimitiveVertex(Vector3F( 0.5f,  0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  1.0f)),

  // front
  PrimitiveVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  1.0f)),
  PrimitiveVertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f,  0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  0.0f)),

  // left
  PrimitiveVertex(Vector3F(-0.5f,  0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  1.0f)), 
  PrimitiveVertex(Vector3F(-0.5f,  0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F(-0.5f,  0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  1.0f)),

  // right
  PrimitiveVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f,  0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  PrimitiveVertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  PrimitiveVertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),

  // bottom
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  0.0f)),

  // top
  PrimitiveVertex(Vector3F( 0.5f, 0.5f,  0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, 0.5f, -0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, 0.5f, -0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, 0.5f, -0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, 0.5f,  0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, 0.5f,  0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(1.0f,  0.0f))
];

private PrimitiveVertex[36] pyramidVertices = [
  // back
  PrimitiveVertex(Vector3F( 0.0f,  0.5f,  0.0f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.5f,  1.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  0.0f)),

  // front
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, 0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f, 0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.0f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.5f,  1.0f)),

  // left
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.0f,  0.5f,  0.0f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.5f,  1.0f)),

  // right
  PrimitiveVertex(Vector3F(0.0f,  0.5f,  0.0f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.5f,  1.0f)),
  PrimitiveVertex(Vector3F(0.5f, -0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F(0.5f, -0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),

  // bottom
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
];

private PrimitiveVertex[] squareVertices = [
  PrimitiveVertex(Vector3F(-0.5f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 0.0f)),
  PrimitiveVertex(Vector3F( 0.5f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 1.0f))
];

private uint[6] squareIndices = [
  0, 1, 2,
  0, 2, 3
];

private PrimitiveVertex[3] triangleVertices = [
  PrimitiveVertex(Vector3F( 0.0f,  0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.5f, 1.0f)),
  PrimitiveVertex(Vector3F(-0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f, 0.0f)),
  PrimitiveVertex(Vector3F( 0.5f, -0.5f, 0.0f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f, 0.0f))
];

private uint[3] triangleIndices = [
  0, 1, 2
];