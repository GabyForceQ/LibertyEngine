/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/texture/cache.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.texture.cache;

import liberty.image.loader : ImageLoader;
import liberty.graphics.texture.impl : Texture;

/**
 *
**/
class TextureCache {
  private {
    Texture[string] _textureMap;
  }

  /**
   *
  **/
  Texture getTexture(string path) {
    // Check if texture is in the map
    // If it's not then load a new one and return it
    if (path !in _textureMap) {
      Texture tex = ImageLoader.loadBMP(path);
      _textureMap[path] = tex;
      return tex;
    }

    // Otherwise return the loaded texture
    return _textureMap[path];
  }
}