/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/mesh.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.mesh;

import liberty.core.components.renderer : Renderer;
import liberty.core.model.generic : GenericModel;
import liberty.core.objects.entity : Entity;
import liberty.core.objects.meta : NodeBody;
import liberty.graphics.vertex : GenericVertex;

import liberty.core.material.impl : Material;

/**
 *
**/
final class StaticMesh : Entity!GenericVertex {
  mixin(NodeBody);

  /**
   *
  **/
  void constructor() {
    renderer = Renderer!GenericVertex(this, new GenericModel([Material.getDefault()]));
  }

  /**
   *
  **/
  override void render() {
    getScene()
      .getGenericShader()
      .loadUseFakeLighting(renderer.getModel().getUseFakeLighting());

    super.render();
  }
}