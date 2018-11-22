/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/model/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.model.impl;

import liberty.graphics.material.impl;

/**
 *
**/
class RawModel {
  private {
    uint vaoID;
    size_t vertexCount;
  }

  /**
   *
  **/
  this(uint vaoID, size_t vertexCount) {
    this.vaoID = vaoID;
    this.vertexCount = vertexCount;
  }

  /**
   *
  **/
  uint getVaoID() {
    return vaoID;
  }

  /**
   *
  **/
  size_t getVertexCount() {
    return vertexCount;
  }
}

/**
 *
**/
abstract class Model {
  protected {
    RawModel rawModel;
    Material[] materials;
    bool shouldCull = true;
  }

  /**
   *
  **/
  this(Material[] materials) {
    this.materials = materials;
  }

  /**
   *
  **/
  RawModel getRawModel() pure nothrow {
    return rawModel;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  Model toggleMaterials(Material[] materialsLhs, Material[] materialsRhs) {
    materials = (materials == materialsLhs) ? materialsRhs : materialsLhs;
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  Model toggleMaterials(Material[2][] arr) {
    foreach (i, ref material; materials)
      material = (material == arr[i][0]) ? arr[i][1] : arr[i][0];

    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  Model setMaterials(Material[] materials) pure nothrow {
    this.materials = materials;
    return this;
  }

  /**
   *
  **/
  Material[] getMaterials() pure nothrow {
    return materials;
  }

  /**
   * Enable or disable culling on this model.
   * It is enabled by default.
   * Returns reference to this so it can be used in a stream.
  **/
  Model setShouldCull(bool shouldCull) pure nothrow {
    this.shouldCull = shouldCull;
    return this;
  }

  /**
   * Returns model culling state.
  **/
  bool getShouldCull() pure nothrow const {
    return shouldCull;
  }
}