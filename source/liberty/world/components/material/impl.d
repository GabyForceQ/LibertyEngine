/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/world/components/material/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.world.components.material.impl;

import liberty.core.system.engine : CoreEngine;
import liberty.core.utils.singleton : Singleton;
import liberty.core.logger.manager : Logger;
import liberty.core.system.resource.manager : ResourceManager;
import liberty.core.math.vector : Vector3F;
import liberty.graphics.texture : Texture;
import liberty.graphics.shader.gfx : GfxShaderProgram;
import liberty.graphics.shader.constants : VertexCode, FragmentCode;
import liberty.graphics.util : RenderUtil;
import liberty.world.components.meta : Component;

/**
 *
**/
@Component
class Material {
  private {
    GfxShaderProgram shaderProgram;
    Texture texture;
  }

  this(string path) {
    import std.conv : to;

    // Create a new shader for this material
    this.shaderProgram = RenderUtil.self.
      createGfxShaderProgram(VertexCode, FragmentCode);

    // Add created shader to scene shader list.
    CoreEngine.self
      .getViewport()
      .getScene()
      .shaderList[this.shaderProgram.getId().to!string] = this.shaderProgram;

    // Load texture from file
    this.texture = ResourceManager.self.loadTexture(path);

    // Bind shader and add/load uniforms
    this.shaderProgram.bind();
    this.shaderProgram.addUniform("uModel");
    this.shaderProgram.addUniform("uView");
    this.shaderProgram.addUniform("uProjection");
    this.shaderProgram.addUniform("uTextureSampler");
    this.shaderProgram.addUniform("uColor");
    this.shaderProgram.loadUniform("uTextureSampler", 0);
  }

  ~this() {
    this.shaderProgram.unbind();
	  this.shaderProgram.destroy();
	}

  Texture getTexture() pure nothrow @safe {
    return this.texture;
  }

  GfxShaderProgram getShaderProgram() pure nothrow @safe {
    return this.shaderProgram;
  }

	void render() {
    // Bind shader every frame
    this.shaderProgram.bind();

    // Load implicit uniforms
    this.shaderProgram.render();
	}

  //private {
  //Vector3F color;
  //}
  /**
   *
  **/
  //this(Texture texture, Vector3F color) {
  //  this.texture = texture;
  //  this.color = color;
  //}

  /**
   *
  **/
  Material addNode(T)(string uniformName, T value) {
    this.shaderProgram.loadUniform(uniformName, value);
    return this;
  }

  /**
   *
  **/
  Material removeNode(string uniformName) {
    return this;
  }

  /**
   *
  **/
  Material addGate(string codeBlock) {
    return this;
  }

  /**
   *
  **/
  Material moveGate(uint fromLocation, uint toDestination) {
    return this;
  }

  /**
   * If there are multiple empty gates, first will be chosen.
   * The remaining ones will be deleted.
  **/
  Material fillEmptyGate(string codeBlock) {
    return this;
  }

  /**
   *
  **/
  Material removeAllEmptyGates() {
    return this;
  }

  /**
   *
  **/
  bool hasEmptyGates() {
    return false;
  }

  /**
   *
  **/
  bool compile() {
    return true;
  }

  /**
   *
  **/
  bool build() {
    return true;
  }

  /**
   *
  **/
  bool fixGateOrder() {
    return compile();
  }
}

/**
 *
**/
final class Materials : Singleton!Materials {
  /**
   *
  **/
	Material defaultMaterial;

  /**
   *
  **/
	void load() {
		defaultMaterial = new Material("res/textures/default.bmp");
    Logger.self.info(
      "All materials have been loaded",
      typeof(this).stringof
    );
	}
}

/*
Material material = new Material();

material.addNode("color");
material.addNode("time");

// Gate added (logic registered to the gate buffer on position 0)
// num is unknown
material.addGate(q{
    resultColor = color + vec4(
        1.0 * (cos(time + 0.0) + 1.0) * 0.5,
        1.0 * (cos(time + num) + 1.0) * 0.5,
        1.0 * (sin(time + 1.0) + 1.0) * 0.5,
        0.0
    );
});

// Now if we try to add another gate, it's on position 1
// We need to add the num declaration on position 0
material.moveGate(0, 1).fillEmptyGate(q{
    int num = 2.0;
});

addNode(string) -> material
removeNode(string) -> material
addGate(string) -> material
moveGate(uint, uint) -> material
fillEmptyGate(string) -> material
removeAllEmptyGates -> material
hasEmptyGates -> bool
compile -> bool
build -> bool
fixGateOrder -> bool
*/