/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/gui/tilemap.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.gui.tilemap;

import std.container.array : Array;
import std.conv : to;
import std.typecons : tuple, Tuple;

import liberty.framework.gui.meta;

import liberty.math.vector;
import liberty.framework.gui.event;
import liberty.framework.gui.impl;
import liberty.math.transform;
import liberty.framework.gui.widget;

import liberty.framework.gui.controls;

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

  mixin WidgetConstructor;

  private {
    Vector2I dimension = Vector2I.zero;
    Button[] tiles;

    static foreach (member; getEventArrayString())
      mixin("Tuple!(Button, Event)[] eventMap" ~ member ~ ";");
  }

  /**
   *
  **/
  TileMap setZIndex(int index) pure nothrow {
    foreach (tile; tiles)
      tile.setZIndex(index);
    
    return this;
  }

  /**
   *
  **/
  TileMap build(int xStartLocation, int yStartLocation, int xDimension, int yDimension,
    int xScale = 64, int yScale = 64, int xSpaceBetween = 0, int ySpaceBetween = 0)
  do {
    return build(
      Vector2I(xStartLocation, yStartLocation),
      Vector2I(xDimension, yDimension),
      Vector2I(xScale, yScale),
      Vector2I(xSpaceBetween, ySpaceBetween)
    );
  }

  /**
   *
  **/
  TileMap build(Vector2I startLocation, Vector2I dimension,
    Vector2I scale = Vector2I(64, 64), Vector2I spaceBetween = Vector2I.zero)
  do {
    this.dimension = dimension;
    getComponent!Transform
      .setLocation(Vector3F(startLocation.x, startLocation.y, 0.0f));

    foreach (i; 0..dimension.x)
      foreach (j; 0..dimension.y) {
        tiles ~= new Button(getId ~ "_Tile_" ~ i.to!string ~ "_" ~ j.to!string, getGui);
        
        tiles[$ - 1]
          .setIndex(i, j)
          .getComponent!Transform
          .setLocation(
            i * (scale.x + spaceBetween.x) + getComponent!Transform.getLocation.x,
            -j * (scale.y + spaceBetween.y) - getComponent!Transform.getLocation.y,
            0.0f)
          .setScale(Vector3F(scale.x / 2.0f, scale.y / 2.0f, 1.0f));
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