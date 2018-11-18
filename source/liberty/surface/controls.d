/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/controls.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.controls;

import liberty.surface.event;
import liberty.surface.meta;
import liberty.surface.widget;

/**
 *
**/
final class Button : Widget {
  mixin WidgetEventProps!([
    Event.MouseLeftClick,
    Event.MouseMiddleClick,
    Event.MouseRightClick,
    Event.MouseOver,
    Event.MouseMove,
    Event.MouseEnter,
    Event.MouseLeave,
    Event.Update
  ]);

  mixin WidgetConstructor;
  mixin WidgetUpdate;
}

/**
 *
**/
final class CheckBox : Widget {
  mixin WidgetEventProps!([
    Event.MouseLeftClick,
    Event.MouseMiddleClick,
    Event.MouseRightClick,
    Event.MouseOver,
    Event.MouseMove,
    Event.MouseEnter,
    Event.MouseLeave,
    Event.Check,
    Event.Checked,
    Event.Uncheck,
    Event.Unchecked,
    Event.StateChange,
    Event.Update
  ]);

  mixin WidgetConstructor;
  mixin WidgetUpdate;
}

/**
 *
**/
final class TextBlock : Widget {
  mixin WidgetConstructor;
}