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
import liberty.model.data;
import liberty.scene.services;

///
class Model : IGfxRendererFactory, IDrawable {
  // Used to Store wireframe global state
  private bool tempWireframeEnabled;
  ///
  bool cullingEnabled = true;
  ///
  bool wireframeEnabled;
  ///
  bool transparencyEnabled = true;
  ///
  bool fakeLightingEnabled;
  ///
  RawModel rawModel;
  ///
  Material[] materials;

  ///
  this(RawModel rawModel, Material[] materials) {
    this.rawModel = rawModel;
    this.materials = materials;
  }

  /// Returns reference to this so it can be used in a stream.
  typeof(this) swapMaterials(Material[] materialsLhs, Material[] materialsRhs) {
    materials = (materials == materialsLhs) ? materialsRhs : materialsLhs;
    return this;
  }

  /// Returns reference to this so it can be used in a stream.
  typeof(this) swapMaterials(Material[2][] arr) {
    foreach (i, ref material; materials)
      material = (material == arr[i][0]) ? arr[i][1] : arr[i][0];

    return this;
  }

  /// Render the model to the screen by calling specific draw method from $(D IGfxRendererFactory)
  void draw() {
    // Send culling type to graphics engine
    GfxEngine.backend.setCullingEnabled(cullingEnabled);

    // Send alpha blend to graphics engine
    transparencyEnabled
      ? GfxEngine.backend.enableAlphaBlend
      : GfxEngine.backend.disableBlend;

    // Store wireframe global state
    tempWireframeEnabled = GfxEngine.backend.getOptions.wireframeEnabled;

    // Send wireframe type to graphics engine
    GfxEngine.backend.setWireframeEnabled(tempWireframeEnabled ? !wireframeEnabled : wireframeEnabled);

    // Render
    rawModel.useIndices
      ? drawElements(GfxDrawMode.TRIANGLES, GfxVectorType.UINT, rawModel.vertexCount)
      : drawArrays(GfxDrawMode.TRIANGLES, rawModel.vertexCount);

    // Restore wireframe global state using the stored boolean
    GfxEngine.backend.setWireframeEnabled(tempWireframeEnabled);
  }
}