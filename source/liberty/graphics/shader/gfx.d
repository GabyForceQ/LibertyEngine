/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/gfx.d, _gfx.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.gfx;

import liberty.core.system.engine : CoreEngine;
import liberty.core.math.vector : Vector2F, Vector3F, Vector4F;
import liberty.core.math.matrix : Matrix4F;
import liberty.world.services : IRenderable;

/**
 *
**/
abstract class GfxShaderProgram : IRenderable {
  protected {
    uint programID;
    uint vertexShaderID;
    uint fragmentShaderID;
    int attributeCount;
    int[string] uniforms;
  }

  /**
   *
  **/
  uint getId() pure nothrow const @safe {
    return programID;
  }

  /**
   *
  **/
  void bind();

  /**
   *
  **/
  void unbind();

  /**
   *
  **/
  void bindAttribute(string name);

  /**
   *
  **/
  void compileShaders(string vertexShader, string fragmentShader);

  /**
   *
  **/
  void linkShaders();

  /**
   *
  **/
  void addUniform(string name);

  /**
   * Load bool uniform using location id and value.
  **/
  void loadUniform(int locationID, bool value) nothrow @trusted;
  
  /**
   * Load int uniform using location id and value.
  **/
  void loadUniform(int locationID, int value) nothrow @trusted;
  
  /**
   * Load uint uniform using location id and value.
  **/
  void loadUniform(int locationID, uint value) nothrow @trusted;
  
  /**
   * Load float uniform using location id and value.
  **/
  void loadUniform(int locationID, float value) nothrow @trusted;
  
  /**
   * Load vec2 uniform using location id and value.
  **/
  void loadUniform(int locationID, Vector2F vector) nothrow @trusted;
  
  /**
   * Load vec3 uniform using location id and value.
  **/
  void loadUniform(int locationID, Vector3F vector) nothrow @trusted;
  
  /**
   * Load vec4 uniform using location id and value.
  **/
  void loadUniform(int locationID, Vector4F vector) nothrow @trusted;
  
  /**
   * Load mat4 uniform using location id and value.
  **/
  void loadUniform(int locationID, Matrix4F matrix) nothrow @trusted;
  
  /**
   * Load bool uniform using uniform name and value.
  **/
  void loadUniform(string name, bool value) nothrow @trusted;
  
  /**
   * Load int uniform using uniform name and value.
  **/
  void loadUniform(string name, int value) nothrow @trusted;
  
  /**
   * Load uint uniform using uniform name and value.
  **/
  void loadUniform(string name, uint value) nothrow @trusted;
  
  /**
   * Load float uniform using uniform name and value.
  **/
  void loadUniform(string name, float value) nothrow @trusted;
  
  /**
   * Load vec2 uniform using uniform name and value.
  **/
  void loadUniform(string name, Vector2F vector) nothrow @trusted;
  
  /**
   * Load vec3 uniform using uniform name and value.
  **/
  void loadUniform(string name, Vector3F vector) nothrow @trusted;
  
  /**
   * Load vec4 uniform using uniform name and value.
  **/
  void loadUniform(string name, Vector4F vector) nothrow @trusted;
  
  /**
   * Load mat4 uniform using uniform name and value.
  **/
  void loadUniform(string name, Matrix4F matrix) nothrow @trusted;

  /**
   *
  **/
  override void render() {
    // Load projection matrix uniform
		loadUniform(
      "uProjection", 
      CoreEngine.self
        .getViewport()
        .getScene()
        .getActiveCamera()
        .getProjection()
    );

    // Load view matrix uniform
    loadUniform(
      "uView",
      CoreEngine.self
        .getViewport()
        .getScene()
        .getActiveCamera()
        .getView()
    );
  }
}