module liberty.mvc.objects.node.model;

import liberty.mvc.meta : Model;
import liberty.mvc.objects.node.controller : NodeController;
import liberty.mvc.scene.controller : SceneController;

/**
 * Represents object model in the scene tree.
**/
@Model
struct NodeModel {
  public {
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
}