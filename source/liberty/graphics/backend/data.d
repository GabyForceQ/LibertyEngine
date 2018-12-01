/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/backend/data.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.backend.data;

import liberty.math.vector;

/**
 *
**/
struct GfxBackendInfo {
  /**
   *
  **/
  string[] extensions;

  /**
   *
  **/
  int majorVersion;

  /**
   *
  **/
  int minorVersion;

  /**
   *
  **/
  int maxColorAttachments;
}

/**
 *
**/
struct GfxBackendOptions {
  /**
   *
  **/
  Color4 backColor;

  /**
   *
  **/
  bool wireframeEnabled;

  /**
   *
  **/
  bool depthTestEnabled;

  /**
   *
  **/
  bool textureEnabled;

  /**
   *
  **/
  bool cullingEnabled;

  /**
   *
  **/
  bool alphaBlendEnabled;

  /**
   * 0.0f - disabled or not supported by the machine.
   * 4.0f - x4.
   * 8.0f - x8.
   * 16.0f - x16.
  **/
  float anisotropicFiltering;
}