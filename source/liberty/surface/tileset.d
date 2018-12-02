/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/tileset.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.tileset;

version (none) :

import core.stdc.stdlib;

import liberty.image.format.bmp;
import liberty.image.io;
import liberty.material.impl;
import liberty.math.vector;

/**
 *
**/
final class TileSet {
  private {
    Material** materials;
    Vector2I dimension;
  }

  /**
   *
  **/
  this(Material material, Vector2I tileSize) {
    dimension.x = material.getTexture().getWidth() / tileSize.x;
    dimension.y = material.getTexture().getHeight() / tileSize.y;

    auto image = cast(BMPImage)ImageIO.loadImage(material.getTexture().getRelativePath());

    BMPHeader header;
    header.width = tileSize.x;
    header.height = tileSize.y;

    materials = cast(Material**)malloc(dimension.y * (Material*).sizeof);
    foreach (i; 0..dimension.y) {
      materials[i] = cast(Material*)malloc(dimension.x * (Material).sizeof);
      foreach (j; 0..dimension.x) {
        ubyte[] data = new ubyte[header.width * header.height * 4];
        BMPImage im = ImageIO.createImage(header, data);

        int k;
        foreach (m; (dimension.y - i - 1) * 128..header.width + (dimension.y - i - 1) * 128)
          foreach (n; j * 128..header.height + j * 128) {
            data[k++] = image.getRGBAPixel(n, m).b;
            data[k++] = image.getRGBAPixel(n, m).g;
            data[k++] = image.getRGBAPixel(n, m).r;
            data[k++] = image.getRGBAPixel(n, m).a;
          }

        materials[i][j] = new Material(im);
      }
    }
  }

  /**
   *
  **/
  Material getTile(int x, int y) pure nothrow {
    return getTile(Vector2I(x, y));
  }

  /**
   *
  **/
  Material getTile(Vector2I index) pure nothrow {
    return materials[index.x][index.y];
  }
}