/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/gui/impl.d)
 * Documentation:
 * Coverage:
 * TODO:
 *    - Change action delegate and objEvList dinamically.
**/
module liberty.framework.gui.impl;

import liberty.framework.gui.data;
import liberty.graphics.shader.impl;
import liberty.math.matrix;
import liberty.scene.constants;
import liberty.scene.entity;

import std.typecons : Tuple;

import liberty.logger;
import liberty.math.matrix;
import liberty.math.util;
import liberty.scene.entity;
import liberty.core.platform;
import liberty.scene.impl;
import liberty.framework.gui.event;
import liberty.framework.gui.constants;
import liberty.framework.gui.widget;
import liberty.scene.services;
import liberty.framework.gui.controls;
import liberty.scene.action;
import liberty.graphics.shader.program;


/**
 * A gui represents a 2-dimensional view containting graphical user interface elements.
 * Inheriths $(D Entity) class and implements $(D IUpdateable) service.
**/
abstract class Gui : Entity {
  private {
    Shader shader;
    // getProjection, setProjection
    GuiProjection projection;
    // isFixedProjectionEnabled, setFixedProjectionEnabled
    bool fixedProjectionEnabled;
    // getProjectionMatrix
    Matrix4F projectionMatrix = Matrix4F.identity;
    
    Canvas rootCanvas;
    Action!Widget[string] actionMap;
  }
  
  /**
   * Create a new gui using an id and a parent.
  **/
  this(string id, Entity parent) {
    super(id, parent);

    shader = Shader
      .getOrCreate("Gui", (shader) {
        shader
          .setViewMatrixEnabled(false)
          .addCustomRenderMethod((program, self) {
            program.bind;

            foreach (node; self.getMap)
              if (node.getVisibility == Visibility.Visible) {
                (cast(Gui)node).updateProjection(program);
                foreach (widget; (cast(Gui)node).getRootCanvas.getWidgets) {
                  if (widget.getZIndex == 0) {
                    if (widget.getVisibility == Visibility.Visible) {
                      if (widget.getModel !is null)
                        program
                          .loadUniform("uZIndex", 0)
                          .loadUniform("uModelMatrix", widget.getTransform.getModelMatrix)
                          .render(widget.getModel);
                    }
                  }
                }
                // FILTER Z INDEX FOR NOW WITH ONLY 0 AND 1 --> BUG
                foreach (widget; (cast(Gui)node).getRootCanvas.getWidgets) {
                  if (widget.getZIndex == 1) {
                    if (widget.getVisibility == Visibility.Visible) {
                      if (widget.getModel !is null)
                        program
                          .loadUniform("uZIndex", 1)
                          .loadUniform("uModelMatrix", widget.getTransform.getModelMatrix)
                          .render(widget.getModel);
                    }
                  }
                }
              }

            program.unbind;
          });
      });

    shader.registerEntity(this);
    scene.addShader(shader);

    rootCanvas = new Canvas("RootCanvas" ~ id, this);
    updateProjection(shader.getProgram);
  }

  private void updateProjection(ShaderProgram program) {
    if (!fixedProjectionEnabled) {
      const tempWidth = Platform.getWindow.getWidth;
      const tempHeight = Platform.getWindow.getHeight;
      
      if (projection.width != tempWidth || projection.height != tempHeight) {
        projection.width = tempWidth;
        projection.height = tempHeight;
      
        projectionMatrix = MathUtils.getOrthographicMatrixFrom(
          cast(float)projection.xStart, cast(float)projection.width,
          cast(float)projection.height, cast(float)projection.yStart,
          cast(float)projection.zNear, cast(float)projection.zFar
        );
        
        program
          .bind
          .loadUniform("uProjectionMatrix", projectionMatrix)
          .unbind;
      }
    }
  }

  /**
   * Returns the projection matrix.
  **/
  Matrix4F getProjectionMatrix() pure nothrow const {
    return projectionMatrix;
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
   * Add a new action for the current gui using an id, an event,
   * an array of tuple containing the wanted widget and its event and a priority.
   * The priority param is optional, its default value is 0.
   * Returns reference to this so it can be used in a stream.
  **/
  Gui addAction(T)(string id, void delegate(Widget, Event) action,
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
      ? actionMap[id] = new Action!Widget(id, action, priority)
      : Logger.error("Action with id: " ~ id ~ " can't be created.", typeof(this).stringof);
    
    return this;
  }

  /**
   * Simulate an action by starting it right now.
   * Returns reference to this so it can be used in a stream.
  **/
  final Gui simulateAction(string id, Widget sender, Event e) {
    actionMap[id].callEvent(sender, e);
    return this;
  }

  /**
   * Remove an user interface action from the memory.
   * Returns reference to this so it can be used in a stream.
  **/
  final Gui removeAction(string id) {
    actionMap[id].destroy();
    actionMap[id] = null;
    actionMap.remove(id);
    return this;
  }

  /**
   * Returns the action map for user interface elements.
  **/
  final Action!Widget[string] getActionMap() pure nothrow {
    return actionMap;
  }

  /**
   * Returns an action by given id for user interface elements.
  **/
  final Action!Widget getAction(string name) pure nothrow {
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