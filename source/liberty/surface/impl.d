/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/impl.d)
 * Documentation:
 * Coverage:
 */
module liberty.surface.impl;

import std.traits : EnumMembers;
import std.typecons : Tuple;

import liberty.math.matrix;
import liberty.math.util;
import liberty.scene.node;
import liberty.core.platform;
import liberty.scene.impl;
import liberty.surface.ui.widget;
import liberty.services;
import liberty.surface.ui.button;

/**
 *
**/
abstract class Surface : SceneNode, IRenderable, IUpdatable {
  private {
    int xStart;
    int yStart;
    int width;
    int height;
    int zNear = -1;
    int zFar = 1;

    Matrix4F projectionMatrix = Matrix4F.identity();
    Widget[string] widgets;

    void delegate(Widget, Event)[string] actionMap;
  }

  /**
   *
  **/
  this(string id, SceneNode parent) {
    super(id, parent);
    updateProjection();
  }

  /**
   *
  **/
  package final Surface addWidget(Widget widget) {
    widgets[widget.getId()] = widget;
    return this;
  }
  
  /**
   *
  **/
  final Surface updateProjection(bool autoScale = true) {
    if (autoScale) {
      width = Platform.getWindow().getWidth();
      height = Platform.getWindow().getHeight();
    }
    
    projectionMatrix = MathUtils.getOrthographicMatrixFrom(
      cast(float)xStart, cast(float)width,
      cast(float)height, cast(float)yStart,
      cast(float)zNear, cast(float)zFar
    );
    
    getScene()
      .getSurfaceShader()
      .bind()
      .loadProjectionMatrix(projectionMatrix)
      .unbind();

    return this;
  }

  /**
   *
  **/
  final Matrix4F getProjectionMatrix() pure nothrow const {
    return projectionMatrix;
  }

  /**
   *
  **/
  final override void render() {
    foreach (w; widgets)
      w.render();
  }

  /**
   *
  **/
  override void update() {
    foreach (w; widgets)
      w.update();
  }

  /**
   *
  **/
  final Widget[string] getWidgets() pure nothrow {
    return widgets;
  }

  /**
   *
  **/
  final Widget getWidget(string id) pure nothrow {
    return widgets[id];
  }

  import std.stdio;

  /**
   *
  **/
  Surface addAction(string id, void delegate(Widget, Event) action, Tuple!(Widget, Event)[] objEvList)  {
    actionMap[id] = action;
    
    static foreach (s; ["Button"])
      foreach(e; objEvList) {
        if (mixin ("__traits(compiles, e[0].as" ~ s ~ ")"))
          SW: final switch (e[1]) with (Event) {
            static foreach (member; mixin ("EnumMembers!" ~ s ~ "Event"))
              mixin ("case " ~ member ~ ": (cast(" ~ s ~ ")e[0]).setOn" ~ member ~ "(action); break SW;");
          }
      }
    
    return this;
  }

  

  /**
   *
  **/
  final Surface launchAction(string id, Widget sender, Event event) {
    actionMap[id](sender, event);
    return this;
  }

  /**
   *
  **/
  final Surface removeAction(string id) pure nothrow {
    actionMap.remove(id);
    return this;
  }

  /**
   *
  **/
  final void delegate(Widget, Event)[string] getActionMap() pure nothrow {
    return actionMap;
  }

  /**
   *
  **/
  final void delegate(Widget, Event) getAction(string name) pure nothrow {
    return actionMap[name];
  }
}

/**
else static if (is(OEL == Tuple!(Widget[], Event)[]))
      foreach(e; objEvList)
        SW: final switch (e[1]) with (Event) {
          static foreach (member; EnumMembers!ButtonEvent)
            mixin ("case " ~ member ~ ": (cast(Button)e[0]).setOn" ~ member ~ "(action); break SW;");
        }
    else static if (is(OEL == Tuple!(Widget[][], Event)[]))
      foreach(e; objEvList)
        SW: final switch (e[1]) with (Event) {
          static foreach (member; EnumMembers!ButtonEvent)
            mixin ("case " ~ member ~ ": foreach (i; e[0]) (cast(Button)i).setOn" ~ member ~ "(action); break SW;");
        }
    else
      static assert (0, "Invalid tuple.");
**/