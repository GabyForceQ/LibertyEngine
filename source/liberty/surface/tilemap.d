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
import std.typecons : tuple, Tuple;

import liberty.surface.meta;

import liberty.math.vector;
import liberty.surface.event;
import liberty.surface.impl;
import liberty.surface.transform;
import liberty.surface.widget;

import liberty.surface.controls;

/**
 *
**/
final class TileMap : Widget {
  mixin WidgetEventProps!([
    Event.MouseLeftClick,
    Event.MouseMiddleClick,
    Event.MouseRightClick,
    Event.MouseOver,
    Event.MouseMove,
    Event.MouseEnter,
    Event.MouseLeave,
    Event.Update,
  ], "custom");

  mixin WidgetConstructor!("renderer: disabled");

  private {
    Vector2I dimension = Vector2I.zero;
    Button[] tiles;

    static foreach (member; getEventArrayString())
      mixin("Tuple!(Button, Event)[] eventMap" ~ member ~ ";");
  }

  /**
   *
  **/
  TileMap build(int xStartLoc, int yStartLoc, int xDim, int yDim) {
    return build(Vector2I(xStartLoc, yStartLoc), Vector2I(xDim, yDim));
  }

  /**
   *
  **/
  TileMap build(Vector2I startLocation, Vector2I dimension) {
    this.dimension = dimension;
    getTransform.setPosition(startLocation);

    foreach (i; 0..dimension.x)
      foreach (j; 0..dimension.y) {
        tiles ~= new Button(
          getId() ~ "_Tile_" ~ i.to!string ~ "_" ~ j.to!string,
          getSurface()
        );
        
        tiles[$ - 1]
          .setIndex(i, j)
          .getTransform()
          .setPosition(
            i * 100 + getTransform.getPosition.x,
            j * 100 + getTransform.getPosition.y
          );
      }
    
    return this;
  }

  /**
   *
  **/
  Button[] getTiles() pure nothrow {
    return tiles;
  }

  /**
   *
  **/
  Button getTile(int x, int y) {
    return getTile(Vector2I(x, y));
  }

  /**
   *
  **/
  Button getTile(Vector2I index) {
    return tiles[dimension.y * index.x + index.y];
  }

  /**
   *
  **/
  Vector2I getDimension() pure nothrow {
    return dimension;
  }

  static foreach (member; getEventArrayString())
    /**
     *
    **/
    mixin("TileMap create" ~ member ~ "Event() pure nothrow {"
      ~ "foreach (i; 0..dimension.x * dimension.y)"
      ~ "eventMap" ~ member ~ "~= tuple(tiles[i], Event." ~ member ~ ");"
      ~ "return this; }");

  static foreach (member; getEventArrayString())
    /**
     *
    **/
    mixin("Tuple!(Button, Event)[] get" ~ member ~ "Event() pure nothrow"
      ~ "{ return eventMap" ~ member ~ "; }");
}