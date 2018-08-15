/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/resource/manager.d, _manager.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.resource.manager;

import liberty.core.utils : Singleton;
import liberty.core.logger.meta : ExceptionConstructor;
import liberty.core.manager.meta : ManagerBody;
import liberty.graphics.texture.cache : TextureCache;
import liberty.graphics.texture.data : Texture;

/**
 * A failing ResourceManager function should <b>always</b> throw a $(D ResourceException).
**/
final class ResourceException : Exception {
    mixin(ExceptionConstructor);
}

/**
 *
**/
final class ResourceManager : Singleton!ResourceManager {
  mixin(ManagerBody);

  private {
      TextureCache _textureCache;
  }

  private static immutable startBody = q{
    _textureCache = new TextureCache();
  };

  //uint boundTexture;

  /**
   *
  **/
  Texture getTexture(string resourcePath) {
    // Check if service is running
    if (checkService()) {
      return _textureCache.getTexture(resourcePath);
    }
    
    return Texture();
  }
}