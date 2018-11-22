/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/texture/cache.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.texture.cache;

import liberty.image.io;
import liberty.graphics.texture.impl;
import liberty.graphics.texture.io;
import liberty.logger.impl;
import liberty.cubemap.io;

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
      import std.array : split;

      Texture tex;

      // Check extension
      string[] splitArray = path.split(".");	
      immutable extension = splitArray[$ - 1];
      switch (extension) {
        case "bmp":
          tex = TextureIO.loadBMP(path);
          break;
        default:
          Logger.error(	
            "File format not supported for texture data: " ~ extension,	
            typeof(this).stringof	
          );
      }

      _textureMap[path] = tex;
      tex.setRealtivePath(path);
      return tex;
    }

    // Otherwise return the loaded texture
    return _textureMap[path];
  }

  /**
    *
  **/
  Texture getCubeMapTexture(string[6] paths) {
    // Check if texture is in the map
    // If it's not then load a new one and return it
    /*static foreach (i; 0..6)
      if (paths[i] in _textureMap)
        return _textureMap[paths[i]];*/
    
    import std.array : split;

    Texture tex;

    // Check extension
    //string[] splitArray = path.split(".");	
    //immutable extension = splitArray[$ - 1];
    //switch (extension) {
    //  case "bmp":
        tex = CubeMapIO.loadCubeMap(paths);
    //    break;
    //  default:
    //    Logger.error(	
    //      "File format not supported for texture data: " ~ extension,	
    //      typeof(this).stringof	
    //    );
    //}

    _textureMap[paths[0]] = tex;
    tex.setRealtivePath(paths[0]);
    return tex;
  }
}