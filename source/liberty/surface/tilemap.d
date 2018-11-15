/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/tilemap.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.tilemap;

import std.algorithm : filter;
import std.container.array : Array;
import std.conv : to;
import std.typecons : tuple, Tuple;

import liberty.math.vector;
import liberty.surface.impl;
import liberty.surface.transform;
import liberty.surface.ui.widget;

import liberty.surface.ui.button;

/**
 *
**/
final class TileMap : Widget {
  private {
    Vector2I dimension = Vector2I.zero;
    Widget[] tiles;
    Tuple!(Widget, Event)[] mouseOverEvents;
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
        tiles[$ - 1]
          .setIndex(i, j)
          .getTransform()
          .setPosition(
            j * 100 + getTransform.getPosition.x,
            i * 100 + getTransform.getPosition.y
          );
      }

    return this;
  }

  /**
   *
  **/
  TileMap createMouseOverEvent() pure nothrow {
    foreach (i; 0..dimension.x * dimension.y)
      mouseOverEvents ~= tuple(tiles[$ - 1].asWidget(), Event.MouseOver);
    
    return this;
  }

  /**
   *
  **/
  Widget[] getTiles() pure nothrow {
    return tiles;
  }

  /**
   *
  **/
  Widget getTile(int x, int y) pure nothrow {
    return filter!(tile => tile.getIndex() == Vector2I(x, y))(tiles)._input[0];
  }

  /**
   *
  **/
  Tuple!(Widget, Event)[] getMouseOverEvents() pure nothrow {
    return mouseOverEvents;
  }
}