module liberty.mvc.scene.model;

import liberty.core.math.vector : Vector3F;
import liberty.db.meta : PrimaryKey, Required;
import liberty.mvc.meta : Model, Serialize, Ignore;
import liberty.mvc.objects.node.controller : Node;

/**
 *
**/
@Model
struct SceneModel {
  mixin(Serialize);

  public {

    @PrimaryKey
    @Required
    string id;

    @Required
    bool isReady;

    @Ignore
    @Required
    Node tree;

    @Ignore
    @Required
    Camera activeCamera;

    @Ignore
    @Required
    Camera[string] camerasMap;

    @Ignore
    @Required
    Vector3F startPoint;

    @Ignore
    @Required
    bool[string] objectsId;

    @Ignore
    IStartable[string] startList;
    
    @Ignore
    IUpdatable[string] updateList;
    
    @Ignore
    IProcessable[string] processList;
    
    @Ignore
    IRenderable[string] renderList;
    
    @Ignore
    static IRenderable[string] shaderList;
  }
}