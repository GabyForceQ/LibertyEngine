/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/backend/factory.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.backend.factory;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.logger;
import liberty.graphics.backend.data;
import liberty.graphics.backend.impl;

/**
 * Graphics backend factory interface is implemented and used by $(D GfxBackend).
**/
interface IGfxBackendFactory {
  /**
   * Create graphics backend.
   * Only OpenGL version 3.0 and 4.5 are supported.
   * First time it checks for 4.5 availability and if it's not found, then it checks for version 3.0.
  **/
  static GfxBackend createBackend() {
    Logger.info("Start creating graphics backend", typeof(this).stringof);

    GfxBackendInfo info;
    GfxBackendOptions options; // TODO. Load options from file. Change constructor too.

    version (__OPENGL__) {
      // Load OpenGL library.
      const res = loadOpenGL();
      if (res == glSupport.gl45) {
        // Set minor and major version of the api
        info.majorVersion = 4;
        info.minorVersion = 5;

        Logger.info("OpenGL 4.5 has been loaded successfully", typeof(this).stringof);
      } else if (res == glSupport.gl30) {
        // Set minor and major version of the api
        info.majorVersion = 3;
        info.minorVersion = 0;

        Logger.info("OpenGL 3.0 has been loaded successfully", typeof(this).stringof);
      } else
        Logger.error("No OpenGL library found on your system", typeof(this).stringof);

      return new GfxBackend(info, options);
    } else
      static assert(0, "Only OpenGL is supported for rendering");
  }
}