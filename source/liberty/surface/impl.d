/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/impl.d)
 * Documentation:
 * Coverage:
 * TODO:
 *    - Change action delegate and objEvList dinamically.
**/
module liberty.surface.impl;

import std.typecons : Tuple;

import liberty.math.matrix;
import liberty.math.util;
import liberty.scene.node;
import liberty.core.platform;
import liberty.scene.impl;
import liberty.surface.event;
import liberty.surface.widget;
import liberty.services;
import liberty.surface.controls;
import liberty.action;

/**
 * A surface represents a 2-dimensional view containting user interface elements.
 * Inheriths $(D SceneNode) class and implements $(D IRenderable) and $(D IUpdatable) interfaces.
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

    UIAction[string] actionMap;
  }

  /**
   * Create a new surface using an id and a parent.
  **/
  this(string id, SceneNode parent) {
    super(id, parent);
    updateProjection();
  }

  package final Surface addWidget(Widget widget) {
    // Add a new widget to the surface widgets.
    widgets[widget.getId()] = widget;

    // Returns reference to this and can be used in a stream.
    return this;
  }
  
  /**
   * Update the surface projection matrix.
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
   * Returns the surface projection matrix.
  **/
  final Matrix4F getProjectionMatrix() pure nothrow const {
    return projectionMatrix;
  }

  /**
   * Call render for all widgets.
  **/
  final override void render() {
    foreach (w; widgets)
      w.render();
  }

  /**
   * Call update for all widgets.
  **/
  override void update() {
    foreach (w; widgets)
      w.update();
  }

  /**
   * Returns the widgets map.
  **/
  final Widget[string] getWidgets() pure nothrow {
    return widgets;
  }

  /**
   * Returns a widget by given id
  **/
  final Widget getWidget(string id) pure nothrow {
    return widgets[id];
  }

  /**
   * Add a new action for the current surface using an id, an event,
   * an array of tuple containing the wanted widget and its event and a priority.
   * The priority param is optional, its default value is 0.
   * Returns reference to this and can be used in a stream.
  **/
  Surface addAction(T)(string id, void delegate(Widget, Event) action,
    Tuple!(T, Event)[] objEvList = null, ubyte priority = 0)
  do {
    import std.uni : toLower;
    import std.traits : EnumMembers;

    actionMap[id] = new UIAction(id, action, priority);
    
    if (objEvList !is null) {
      static foreach (s; EnumMembers!WidgetType)
        foreach(e; objEvList) {
          if (mixin("__traits(compiles, cast(" ~ s ~ ")e[0])"))
            SW: final switch (e[1]) with (Event) {
              static foreach (member; mixin(s ~ ".getEventArrayString()"))
                mixin("case " ~ member ~ ": (cast(" ~ s ~ ")e[0]).setOn" ~ member ~ "(action); break SW;");
            }
        }
    }
    
    return this;
  }

  /**
   * Simulate an action by starting it right now.
   * Returns reference to this and can be used in a stream.
  **/
  final Surface simulateAction(string id, Widget sender, Event e) {
    actionMap[id].callEvent(sender, e);
    return this;
  }

  /**
   * Remove an user interface action from the memory.
   * Returns reference to this and can be used in a stream.
  **/
  final Surface removeAction(string id) pure nothrow {
    actionMap.remove(id);
    return this;
  }

  /**
   * Returns the action map for user interface elements.
  **/
  final UIAction[string] getActionMap() pure nothrow {
    return actionMap;
  }

  /**
   * Returns an action by given id for user interface elements.
  **/
  final UIAction getAction(string name) pure nothrow {
    return actionMap[name];
  }
}