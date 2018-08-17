/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/mvc/scene/model.d, _model.d)
 * Documentation:
 * Coverage:
**/
module liberty.mvc.scene.model;

import liberty.core.math.vector : Vector3F;
import liberty.db.meta : PrimaryKey, Required;
import liberty.mvc.meta : Model, Serialize, Ignore;
import liberty.mvc.objects.node.controller : NodeController;
import liberty.mvc.objects.camera : CameraController;
import liberty.mvc.services : IStartable, IUpdatable, IProcessable, IRenderable;

/**
 *
**/
@Model
struct SceneModel {
  /**
   *
  **/
  string id;

  /**
   *
  **/
  bool isReady;

  /**
   *
  **/
  NodeController tree;

  /**
   *
  **/
  CameraController activeCamera;

  /**
   *
  **/
  CameraController[string] camerasMap;

  /**
   *
  **/
  Vector3F startPoint;

  /**
   *
  **/
  bool[string] objectsId;

  /**
   *
  **/
  IStartable[string] startList;

  /**
   *
  **/
  IUpdatable[string] updateList;
  
  /**
   *
  **/
  IProcessable[string] processList;

  /**
   *
  **/
  IRenderable[string] renderList;

  /**
   *
  **/
  static IRenderable[string] shaderList;
}