/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/mvc/objects/node/model.d, _model.d)
 * Documentation:
 * Coverage:
**/
module liberty.mvc.objects.node.model;

import liberty.mvc.meta : Model;
import liberty.mvc.objects.node.controller : NodeController;
import liberty.mvc.scene.controller : SceneController;

/**
 * Represents object model in the scene tree.
**/
@Model
struct NodeModel {
  /**
   *
  **/
  string id;

  /**
   *
  **/
  NodeController parent;

  /**
   *
  **/
  NodeController[string] children;

  /**
   *
  **/
  SceneController scene;
}