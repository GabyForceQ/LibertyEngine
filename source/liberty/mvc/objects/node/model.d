module liberty.mvc.objects.node.model;

import liberty.mvc.meta : Model, Serialize, Ignore;
import liberty.mvc.objects.node.controller : Node;
import liberty.db.meta : PrimaryKey, Required;

/**
 * Represents object model in the scene tree.
**/
@Model
struct NodeModel {
  mixin(Serialize);
  
  public {
    @PrimaryKey
    @Required
    string id;

    @Ignore 
    Node parent;
    
    @Ignore 
    Node[string] children;

    @Ignore
    Scene scene;
  }
}