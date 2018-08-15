module liberty.mvc.scene.model;

import liberty.core.math.vector : Vector3F;
import liberty.db.meta : PrimaryKey, Required;
import liberty.mvc.meta : Model, Serialize, Ignore;
import liberty.mvc.objects.node.controller : NodeController;
import liberty.mvc.objects.camera : CameraController;
import liberty.mvc.services : IStartable, IUpdatable, IProcessable;
import liberty.graphics.services : IRenderable;

/**
 *
**/
@Model
struct SceneModel {
  public {
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
}