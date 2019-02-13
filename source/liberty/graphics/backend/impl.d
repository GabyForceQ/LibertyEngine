/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/backend/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.backend.impl;

import bindbc.opengl;
import liberty.logger;
import liberty.graphics.backend.data;
import liberty.graphics.backend.factory;
import liberty.math.vector;

/// Backend class for graphics engine.
/// It implements $(D IGfxBackendFactory) service.
final class GfxBackend : IGfxBackendFactory {
  private {
    // getInfo
    GfxBackendInfo info;
    // getOptions
    GfxBackendOptions options;
  }

  /// Instantiate class using $(D GfxBackendInfo) and $(D GfxBackendOptions).
  this(GfxBackendInfo info, GfxBackendOptions options) {
    // Initialize backend info and options
    this.info = info;
    this.options = options;
    // Enable depth and stencil test by default
    setDepthTestEnabled(true);
    setStencilTestEnabled(true);
    // TODO. Apply options to this, call graphics api functions
    setBackColor(45, 45, 45, 255);
    enableAnisotropicFiltering(0.0f);
    Logger.info("Graphics backend has been created successfully", typeof(this).stringof);
  }

  /// Clear the depth, stencil and color of the screen.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) clearScreen() {
    glClearDepth(1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    glClearColor(
      options.backColor.r / 255.0f,
      options.backColor.g / 255.0f,
      options.backColor.b / 255.0f,
      options.backColor.a / 255.0f
    ); // TODO. Optimize
    glDepthFunc(GL_LEQUAL);
    return this;
  }

  /// Enable or disable wireframe.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) setWireframeEnabled(bool enabled = true) {
      glPolygonMode(GL_FRONT_AND_BACK, enabled ? GL_LINE : GL_FILL);
  options.wireframeEnabled = enabled;
    return this;
  }

  /// Swap between wireframe and non-wireframe mode.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) swapWireframe() {
    glPolygonMode(GL_FRONT_AND_BACK, options.wireframeEnabled ? GL_FILL : GL_LINE);
    options.wireframeEnabled = !options.wireframeEnabled;
    return this;
  }

  /// Enable or disable depth test.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) setDepthTestEnabled(bool enabled = true) {
    enabled
      ? glEnable(GL_DEPTH_TEST)
      : glDisable(GL_DEPTH_TEST);
    options.depthTestEnabled = enabled;
    return this;
  }

  /// Set false depth mask to disable writing to depth buffer, render stuff that
  /// shouldn't influence the depth buffer then set true to enable it again.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) setDepthMask(bool value = true) {
    glDepthMask(value);
    return this;
  }
  
  /// Enable or disable stencil test.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) setStencilTestEnabled(bool enabled = true) {
    enabled
      ? glEnable(GL_STENCIL_TEST)
      : glDisable(GL_STENCIL_TEST);
    options.stencilTestEnabled = enabled;
    return this;
  }
  
  /// Set true stencil mask and each bit is written to the stencil buffer as is.
  /// Set false stencil mask and each bit ends up as 0 in the stencil buffer, disabling writes.
  /// TODO: Enable custom stencil mask.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) setStencilMask(bool value = true) {
    glStencilMask(value ? 0xFF : 0x00);
    return this;
  }

  /// Enable or disable texture.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) setTextureEnabled(bool enabled = true) {
    enabled
      ? glEnable(GL_TEXTURE_2D)
      : glDisable(GL_TEXTURE_2D);
    options.textureEnabled = enabled;
    return this;
  }

  /// Enable or disable culling.
  /// Returns reference to this so it can be used in a stream.
  typeof(this) setCullingEnabled(bool enabled = true) {
    enabled
      ? (glEnable(GL_CULL_FACE), glCullFace(GL_BACK))
      : glDisable(GL_CULL_FACE);
    options.cullingEnabled = enabled;
    return this;
  }

  /**
   * Set back color r-red, g-green, b-blue, a-alpha scalars.
   * A channel value must be in range 0-255, so it can handle 256 possible values.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setBackColor(ubyte r, ubyte g, ubyte b, ubyte a)   {
    return setBackColor(Color4(r, g, b, a));
  }

  /**
   * Set back color using $(Color4).
   * A channel value must be in range 0-255, so it can handle 256 possible values.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setBackColor(Color4 color)   {
    options.backColor = color;
    return this;
  }

  /**
   * Enable the alpha blend.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) enableAlphaBlend() {
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    options.alphaBlendEnabled = true;
    return this;
  }

  /**
   * Disable the blend.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) disableBlend() {
    glDisable(GL_BLEND);
    options.alphaBlendEnabled = false;
    return this;
  }

  /**
   * Enable and set anisotropic filtering if possible.
   * Use 0.0f to disable it.
   * Only values 4.0f, 8.0f and 16.0f are supported for enabling it.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) enableAnisotropicFiltering(float value)  
  in (value == 0.0f || value == 4.0f || value == 8.0f || value == 16.0f,
    "Only values 0.0f, 4.0f, 8.0f and 16.0f are supported.")
  do {
    options.anisotropicFiltering = value;
    return this;
  }

  /**
   * Returns true if the given extension is supported.
  **/
  bool supportsExtension(string extension)   const {
    foreach (el; info.extensions)
      if (el == extension)
        return true;
        
    return false;
  }

  /// Returns backend info.
  GfxBackendInfo getInfo()   {
    return info;
  }

  /// Returns backend options.
  GfxBackendOptions getOptions()   {
    return options;
  }
}