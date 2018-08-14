module liberty.mvc.objects.node.controller;

import liberty.mvc.meta : Controller, BindModel, JSON;
import liberty.mvc.objects.node.model : NodeModel;

/**
 * Represents object controller in the scene tree.
 */
@Controller
class NodeController {

  mixin(BindModel);

  /**
   *
  **/
  this(string id, NodeController parent) {
    this.model.update(JSON([
      "id": id
    ]));
  }

  /**
   *
  **/
  string id() {
    return this.model.get!string("id");
  }

}

/**
 *
 */
unittest {
  assert(
    (new NodeController("MyNode", null).id) == "MyNode", 
    "Id from serialized model is wrong!"
  );
}