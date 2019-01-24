/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/primitive/bsp.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.primitive.bsp;

import liberty.framework.primitive.vertex;
import liberty.framework.terrain.vertex;
import liberty.framework.primitive.impl;
import liberty.material.impl;
import liberty.math.vector;
import liberty.model.impl;
import liberty.model.io;
import liberty.scene.entity;
import liberty.scene.meta;

/**
 *
**/
abstract class BSPVolume : Primitive {
  /**
   *
  **/
  this(string id) {
    super(id);
  }
}

/**
 *
**/
final class BSPCube : BSPVolume {
  mixin NodeBody;

  /**
   *
  **/
  this(string id) {
    super(id);
    register;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(Material material = Material.getDefault()) {
    setModel(new Model(ModelIO.loadRawModel(cubeVertices), [material]));
    return this;
  }
}

/**
 *
**/
final class BSPPyramid : BSPVolume {
  mixin NodeBody;

  /**
   *
  **/
  this(string id) {
    super(id);
    register;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(Material material = Material.getDefault()) {
    setModel(new Model(ModelIO.loadRawModel(pyramidVertices), [material]));
    return this;
  }
}

/**
 *
**/
final class BSPSquare : BSPVolume {
  mixin NodeBody;

  /**
   *
  **/
  this(string id) {
    super(id);
    register;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(Material material = Material.getDefault()) {
    setModel(new Model(ModelIO.loadRawModel(squareVertices, squareIndices), [material]));
    return this;
  }
}

/**
 *
**/
final class BSPTriangle : BSPVolume {
  mixin NodeBody;

  /**
   *
  **/
  this(string id) {
    super(id);
    register;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) build(Material material = Material.getDefault()) {
    setModel(new Model(ModelIO.loadRawModel(triangleVertices, triangleIndices), [material]));
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
