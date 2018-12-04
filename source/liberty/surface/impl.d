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

version (none) :

import std.typecons : Tuple;

import liberty.logger;
import liberty.math.matrix;
import liberty.math.util;
import liberty.scene.entity;
import liberty.core.platform;
import liberty.scene.impl;
import liberty.surface.event;
import liberty.surface.constants;
import liberty.surface.widget;
import liberty.scene.services;
import liberty.surface.controls;
import liberty.scene.action;

/**
 * A surface represents a 2-dimensional view containting user interface elements.
 * Inheriths $(D Entity) class and implements $(D IUpdateable) service.
**/
abstract class Surface : Entity, IUpdateable {
  private {
    
    Canvas rootCanvas;
    UIAction[string] actionMap;
  }

  /**
   * Create a new surface using an id and a parent.
  **/
  this(string id, Entity parent) {
    super(id, parent);
    rootCanvas = new Canvas("RootCanvas" ~ id, this);
    updateProjection;
  }
  
  /**
   * Update the surface projection matrix.
  **/
  final typeof(this) updateProjection() {
    if (!fixedProjectionEnabled) {
      const tempWidth = Platform.getWindow.getWidth;
      const tempHeight = Platform.getWindow.getHeight;
      
      if (width != tempWidth || height != tempHeight) {
        width = tempWidth;
        height = tempHeight;
      
        projectionMatrix = MathUtils.getOrthographicMatrixFrom(
          cast(float)xStart, cast(float)width,
          cast(float)height, cast(float)yStart,
          cast(float)zNear, cast(float)zFar
        );
        
        getScene
          .getSurfaceSystem
          .getShader
          .bind
          .loadProjectionMatrix(projectionMatrix)
          .unbind;
      }
    }

    return this;
  }

  /**
   *
  **/
  override void update() {
    rootCanvas.update();
  }

  /**
   *
  **/
  final Canvas getRootCanvas() pure nothrow {
    return rootCanvas;
  }

  /**
   * Add a new action for the current surface using an id, an event,
   * an array of tuple containing the wanted widget and its event and a priority.
   * The priority param is optional, its default value is 0.
   * Returns reference to this so it can be used in a stream.
  **/
  Surface addAction(T)(string id, void delegate(Widget, Event) action,
    Tuple!(T, Event)[] objEvList = null, ubyte priority = 0)
  do {
    import std.array : split;
    import std.traits : EnumMembers;

    bool possible = false;
    
    if (objEvList !is null)
      static foreach (s; EnumMembers!WidgetType)
        static if (s == T.stringof.split("!")[0]) {
          foreach (e; objEvList) {
            switch (e[1]) with (Event) {
              static foreach (member; mixin(T.stringof ~ ".getEventArrayString"))
                mixin("case " ~ member ~ ": (cast(" ~ s ~ ")e[0]).setOn" ~ member ~
                  "(action); possible = true; goto END_SWITCH;");
              default: break;
            }
            END_SWITCH:
          }
        }

    possible
      ? actionMap[id] = new UIAction(id, action, priority)
      : Logger.error("Action with id: " ~ id ~ " can't be created.", typeof(this).stringof);
    
    return this;
  }

  /**
   * Simulate an action by starting it right now.
   * Returns reference to this so it can be used in a stream.
  **/
  final Surface simulateAction(string id, Widget sender, Event e) {
    actionMap[id].callEvent(sender, e);
    return this;
  }

  /**
   * Remove an user interface action from the memory.
   * Returns reference to this so it can be used in a stream.
  **/
  final Surface removeAction(string id) {
    actionMap[id].destroy();
    actionMap[id] = null;
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

  /**
   * Keep window aspect ratio the same.
   * Returns reference to this so it can be used in a stream.
  **/
  final typeof(this) setFixedProjectionEnabled(bool enabled = true) pure nothrow {
    fixedProjectionEnabled = enabled;
    return this;
  }

  /**
   * Returns true if fixed projection is enabled.
  **/
  final bool isFixedProjectionEnabled() pure nothrow const {
    return fixedProjectionEnabled;
  }
}