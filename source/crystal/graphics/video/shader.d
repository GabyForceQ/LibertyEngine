/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.graphics.video.shader;
import liberty.math.vector : Vector2F, Vector3F, Vector4F;
import liberty.math.matrix: Matrix4F;
import liberty.graphics.renderer : Renderable;
import liberty.core.engine;
///
enum ShaderType : byte {
    ///
    Vertex = 0x00,
    ///
    Fragment = 0x01,
    ///
    Geometry = 0x02,
    ///
    TesselationControl = 0x03,
    ///
    TesselationEval = 0x04,
    ///
    Compute = 0x05,
    ///
    Primitive = 0x06,
    ///
    Stencil = 0x07
}
///
enum ShaderLanguage : byte {
    ///
    GLSL = 0x00,
    ///
    SPV = 0x01
}
///
abstract class ShaderProgram : Renderable {
	protected {
        uint _programID;
        uint _vertexShaderID;
        uint _fragmentShaderID;
    }
    ///
    uint programID();
    ///
    void start();
    ///
    void stop();
    ///
    void cleanUp();
    ///
    void bindAttribute(int attribute, string var_name);
    /// Load bool uniform using location id and value.
    void loadUniform(int locationID, bool value);
    /// Load int uniform using location id and value.
    void loadUniform(int locationID, int value);
    /// Load uint uniform using location id and value.
    void loadUniform(int locationID, uint value);
    /// Load float uniform using location id and value.
    void loadUniform(int locationID, float value);
    /// Load vec2 uniform using location id and value.
    void loadUniform(int locationID, Vector2F vector);
    /// Load vec3 uniform using location id and value.
    void loadUniform(int locationID, Vector3F vector);
    /// Load vec4 uniform using location id and value.
    void loadUniform(int locationID, Vector4F vector);
    /// Load mat4 uniform using location id and value.
    void loadUniform(int locationID, Matrix4F matrix);
    /// Load bool uniform using uniform name and value.
    void loadUniform(string name, bool value);
    /// Load int uniform using uniform name and value.
    void loadUniform(string name, int value);
    /// Load uint uniform using uniform name and value.
    void loadUniform(string name, uint value);
    /// Load float uniform using uniform name and value.
    void loadUniform(string name, float value);
    /// Load vec2 uniform using uniform name and value.
    void loadUniform(string name, Vector2F vector);
    /// Load vec3 uniform using uniform name and value.
    void loadUniform(string name, Vector3F vector);
    /// Load vec4 uniform using uniform name and value.
    void loadUniform(string name, Vector4F vector);
    /// Load mat4 uniform using uniform name and value.
    void loadUniform(string name, Matrix4F matrix);
    ///
    override void render() {
        loadUniform("projection", CoreEngine.activeScene.activeCamera.projection); // TODO: NOT HERE? ONLY ONCE?
        loadUniform("view", CoreEngine.activeScene.activeCamera.view); // TODO: NOT HERE? ONLY ONCE?
    }
}