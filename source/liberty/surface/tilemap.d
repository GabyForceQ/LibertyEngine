/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/tilemap.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.tilemap;

import std.container.array : Array;
import std.conv : to;

import liberty.math.vector;
import liberty.surface.actor;
import liberty.surface.impl;
import liberty.surface.transform;
import liberty.surface.ui.widget;

import liberty.surface.ui.button;

/**
 *
**/
final class TileMap : Actor {
  private {
    Vector2I dimension = Vector2I.zero;
    Widget[] tiles;
  }

  /**
   *
  **/
  this(string id, Surface surface) {
    super(id, surface);
  }

  /**
   *
  **/
  TileMap build(int xDim, int yDim) {
    return build(Vector2I(xDim, yDim));
  }

  /**
   *
  **/
  TileMap build(Vector2I dimension) {
    this.dimension = dimension;

    //getTransform().setExtent(dimension.x * 100, dimension.y * 100);

    foreach (i; 0..dimension.y)
      foreach (j; 0..dimension.x) {
        tiles ~= new Button(getId() ~ "Tile_" ~ i.to!string ~ "_" ~ j.to!string, getSurface());
        tiles[$ - 1].getTransform().setPosition(
          j * 100 + getTransform.getPosition.x,
          i * 100 + getTransform.getPosition.y
        );
      }

    return this;
  }

  /**
   *
  **/
  Widget getBlock(int x, int y) {
    return tiles[6]; /////////////
  }
}