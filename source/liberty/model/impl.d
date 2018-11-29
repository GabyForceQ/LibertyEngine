/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/model/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.model.impl;

import liberty.graphics.constants;
import liberty.graphics.engine;
import liberty.graphics.factory;
import liberty.material.impl;
import liberty.model.raw;
import liberty.services;

/**
 *
**/
abstract class Model : IGfxRendererFactory, IRenderable {
  private {
    // Used to Store wireframe global state
    bool tempWireframeEnabled;
  }

  protected {
    // getRawModel
    RawModel rawModel;
    // getMaterials, setMaterials, swapMaterials
    Material[] materials;
    // isCullingEnabled, setCullingEnabled, swapCulling
    bool cullingEnabled = true;
    // isWireframeEnabled, setWireframeEnabled, swapWireframe
    bool wireframeEnabled;
    // hasIndices
    bool usesIndices;
  }

  /**
   *
  **/
  this(Material[] materials) {
    this.materials = materials;
  }

  /**
   * Returns the raw model.
  **/
  RawModel getRawModel() pure nothrow {
    return rawModel;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) swapMaterials(Material[] materialsLhs, Material[] materialsRhs) {
    materials = (materials == materialsLhs) ? materialsRhs : materialsLhs;
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) swapMaterials(Material[2][] arr) {
    foreach (i, ref material; materials)
      material = (material == arr[i][0]) ? arr[i][1] : arr[i][0];

    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setMaterials(Material[] materials) pure nothrow {
    this.materials = materials;
    return this;
  }

  /**
   * Returns an array with materials.
  **/
  Material[] getMaterials() pure nothrow {
    return materials;
  }

  /**
   * Enable or disable culling on the model.
   * It is disabled by default when create a new model.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setCullingEnabled(bool enabled = true) pure nothrow {
    cullingEnabled = enabled;
    return this;
  }

  /**
   * Swap culling values between true and false on the model.
  **/
  typeof(this) swapCulling() pure nothrow {
    cullingEnabled = !cullingEnabled;
    return this;
  }

  /**
   * Returns true if model's culling is enabled.
  **/
  bool isCullingEnabled() pure nothrow const {
    return cullingEnabled;
  }

  /**
   * Enable or disable wireframe on the model.
   * It is disabled by default when create a new model.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setWireframeEnabled(bool enabled = true) pure nothrow {
    wireframeEnabled = enabled;
    return this;
  }

  /**
   * Swap wireframe values between true and false on the model.
  **/
  typeof(this) swapWireframe() pure nothrow {
    wireframeEnabled = !wireframeEnabled;
    return this;
  }

  /**
   * Returns true if model's wireframe is enabled.
  **/
  bool isWireframeEnabled() pure nothrow const {
    return wireframeEnabled;
  }

  /**
   * Returns true if the model is built up on both vertices and indices.
  **/
  bool hasIndices() pure nothrow const {
    return usesIndices;
  }

  /**
   * Render the model to the screen by calling specific draw method from $(D IGfxRendererFactory)
  **/
  void render() {
    // Send culling type to graphics engine
    GfxEngine
      .getBackend()
      .setCullingEnabled(cullingEnabled);

    // Store wireframe global state
    tempWireframeEnabled = GfxEngine.getBackend.getOptions.wireframeEnabled;

    // Send wireframe type to graphics engine
    GfxEngine
      .getBackend()
      .setWireframeEnabled(tempWireframeEnabled ? !wireframeEnabled : wireframeEnabled);

    // Render
    hasIndices
      ? drawElements(GfxDrawMode.TRIANGLES, GfxVectorType.UINT, rawModel.getVertexCount())
      : drawArrays(GfxDrawMode.TRIANGLES, rawModel.getVertexCount());

    // Restore wireframe global state using the stored boolean.
    GfxEngine
      .getBackend()
      .setWireframeEnabled(tempWireframeEnabled);
  }
}