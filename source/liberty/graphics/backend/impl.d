/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/backend/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.backend.impl;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.logger;
import liberty.graphics.backend.data;
import liberty.graphics.backend.factory;
import liberty.math.vector;

/**
 * Backend class for graphics engine.
 * It implements $(D IGfxBackendFactory) service.
**/
final class GfxBackend : IGfxBackendFactory {
  private {
    // getInfo
    GfxBackendInfo info;
    // getOptions
    GfxBackendOptions options;
  }

  /**
   * Instantiate class using $(D GfxBackendInfo) and $(D GfxBackendOptions).
  **/
  this(GfxBackendInfo info, GfxBackendOptions options) {
    // Initialize backend info and options
    this.info = info;
    this.options = options;

    // Enable depth test by default
    setDepthTestEnabled(true);

    // TODO. Apply options to this, call graphics api functions
    setBackColor(45, 45, 45, 255);

    Logger.info("Graphics backend has been created successfully", typeof(this).stringof);
  }

  /**
   * Clear the depth, stencil and color of the screen.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) clearScreen() {
    version (__OPENGL__) {
      glClearDepth(1.0);
	    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
      glClearColor(
        options.backColor.r / 255.0f,
        options.backColor.g / 255.0f,
        options.backColor.b / 255.0f,
        options.backColor.a / 255.0f
      ); // TODO. Optimize
      glDepthFunc(GL_LEQUAL);
    }

    return this;
  }

  /**
   * Enable or disable wireframe.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setWireframeEnabled(bool enabled = true) {
    version (__OPENGL__)
      glPolygonMode(GL_FRONT_AND_BACK, enabled ? GL_LINE : GL_FILL);

    options.wireframeEnabled = enabled;
    return this;
  }

  /**
   * Swap between wireframe and non-wireframe mode.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) swapWireframe() {
    version (__OPENGL__)
      glPolygonMode(GL_FRONT_AND_BACK, options.wireframeEnabled ? GL_FILL : GL_LINE);

    options.wireframeEnabled = !options.wireframeEnabled;
    return this;
  }

  /**
   * Enable or disable depth test.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setDepthTestEnabled(bool enabled = true) {
    version (__OPENGL__)
      enabled
        ? glEnable(GL_DEPTH_TEST)
        : glDisable(GL_DEPTH_TEST);

    options.depthTestEnabled = enabled;
    return this;
  }

  /**
   * Enable or disable texture.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setTextureEnabled(bool enabled = true) {
    version (__OPENGL__)
      enabled
        ? glEnable(GL_TEXTURE_2D)
        : glDisable(GL_TEXTURE_2D);

    options.textureEnabled = enabled;
    return this;
  }

  /**
   * Enable or disable culling.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setCullingEnabled(bool enabled = true) {
    version (__OPENGL__)
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
  typeof(this) setBackColor(ubyte r, ubyte g, ubyte b, ubyte a) pure nothrow {
    return setBackColor(Color4(r, g, b, a));
  }

  /**
   * Set back color using $(Color4).
   * A channel value must be in range 0-255, so it can handle 256 possible values.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setBackColor(Color4 color) pure nothrow {
    options.backColor = color;
    return this;
  }

  /**
   * Enable the alpha blend.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) enableAlphaBlend() {
    version (__OPENGL__) {
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }

    options.alphaBlendEnabled = true;
    return this;
  }

  /**
   * Disable the blend.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) disableBlend() {
    version (__OPENGL__)
      glDisable(GL_BLEND);

    options.alphaBlendEnabled = false;
    return this;
  }

  /**
   * Returns true if the given extension is supported.
  **/
  bool supportsExtension(string extension) pure nothrow const {
    foreach (el; info.extensions)
      if (el == extension)
        return true;
        
    return false;
  }

  /**
   * Returns backend info.
  **/
  GfxBackendInfo getInfo() pure nothrow {
    return info;
  }

  /**
   * Returns backend options.
  **/
  GfxBackendOptions getOptions() pure nothrow {
    return options;
  }
}