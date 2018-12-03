/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/gui/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.gui.impl;

import liberty.scene.entity;

/**
 * A gui represents a 2-dimensional view containting graphical user interface elements.
 * Inheriths $(D Entity) class and implements $(D IUpdateable) service.
**/
abstract class Gui : Entity {
  /**
   * Create a new gui using an id and a parent.
  **/
  this(string id, Entity parent) {
    super(id, parent);
  }
}