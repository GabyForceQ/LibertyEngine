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
import std.traits : EnumMembers;
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

    static foreach (member; EnumMembers!TileMapEvent)
      mixin("Tuple!(Widget, Event)[] eventMap" ~ member ~ ";");
  }

  /**
   *
  **/
  this(string id, Surface surface) {
    super(id, surface, false);
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

    foreach (i; 0..dimension.y)
      foreach (j; 0..dimension.x) {
        tiles ~= new Button(
          getId() ~ "_Tile_" ~ i.to!string ~ "_" ~ j.to!string,
          getSurface()
        );
        
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
  Widget[] getTiles() pure nothrow {
    return tiles;
  }

  /**
   *
  **/
  Widget getTile(int x, int y) {
    return getTile(Vector2I(x, y));
  }

  /**
   *
  **/
  Widget getTile(Vector2I index) {
    return tiles[dimension.x * index.x + index.y];
  }

  static foreach (member; EnumMembers!TileMapEvent)
    /**
     *
    **/
    mixin("TileMap create" ~ member ~ "Event() pure nothrow {"
      ~ "foreach (i; 0..dimension.x * dimension.y)"
      ~ "eventMap" ~ member ~ "~= tuple(tiles[i], Event." ~ member ~ ");"
      ~ "return this; }");

  static foreach (member; EnumMembers!TileMapEvent)
    /**
     *
    **/
    mixin("Tuple!(Widget, Event)[] get" ~ member ~ "Event() pure nothrow"
      ~ "{ return eventMap" ~ member ~ "; }");
}

/**
 *
**/
enum TileMapEvent : string {
  /**
   *
  **/
  MouseLeftClick = "MouseLeftClick",

  /**
   *
  **/
  MouseMiddleClick = "MouseMiddleClick",

  /**
   *
  **/
  MouseRightClick = "MouseRightClick",

  /**
   *
  **/
  MouseOver = "MouseOver",

  /**
   *
  **/
  MouseMove = "MouseMove",

  /**
   *
  **/
  MouseEnter = "MouseEnter",

  /**
   *
  **/
  MouseLeave = "MouseLeave",

  /**
   *
  **/
  Update = "Update"
}