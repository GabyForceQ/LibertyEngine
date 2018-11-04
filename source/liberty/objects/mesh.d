/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/objects/mesh.d)
 * Documentation:
 * Coverage:
**/
module liberty.objects.mesh;

import liberty.components.renderer : Renderer;
import liberty.model.core : CoreModel;
import liberty.objects.entity : Entity;
import liberty.objects.meta : NodeBody;
import liberty.graphics.vertex : GenericVertex;

import liberty.graphics.material.impl : Material;

/**
 *
**/
final class StaticMesh : Entity!GenericVertex {
  mixin(NodeBody);

  /**
   *
  **/
  void constructor() {
    renderer = new Renderer!GenericVertex(this, new CoreModel([Material.getDefault()]));
  }

  /**
   *
  **/
  override void render() {
    getScene()
      .getcoreShader()
      .loadUseFakeLighting(renderer.getModel().getUseFakeLighting());

    super.render();
  }
}