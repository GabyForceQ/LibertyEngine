/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/material.d, _material.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.material;
import liberty.core.engine;
import liberty.core.world.scene;
import liberty.core.imaging;
import liberty.graphics;
import liberty.core.utils : Singleton;
import derelict.opengl;
import std.conv : to;
///
final class Material {
	private {
		ShaderProgram _shader;
		uint _textureID;
		Bitmap _texture;
	}
	///
	this() {
		_shader = RenderUtil.get.createShaderProgram(vertexCode, fragmentCode);
		Scene.shaderList[_shader.programID.to!string] = _shader;
		glGenTextures(1, &_textureID);
        _texture = new Bitmap(CoreEngine.get.imageAPI, "res/brick.bmp");
        glBindTexture(GL_TEXTURE_2D, _textureID);
        if (_texture.data()) {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, _texture.width(), _texture.height(), 0, GL_RGBA, GL_UNSIGNED_INT_8_8_8_8, _texture.data());
            glGenerateMipmap(GL_TEXTURE_2D);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_LOD_BIAS, -0.7f);
        } else {
            assert(0);
        }
        _shader.start();
        _shader.loadUniform("fragTexture", 0);
	}
	~this() {
		_shader.destroy();
	}
	///
	ShaderProgram shader() pure nothrow @safe @nogc @property {
		return _shader;
	}
	///
	uint textureId() pure nothrow const @safe @nogc @property {
		return _textureID;
	}
	///
	void render() {
		_shader.loadUniform("projection", CoreEngine.get.activeScene.activeCamera.projection); // TODO: NOT HERE? ONLY ONCE?
        _shader.loadUniform("view", CoreEngine.get.activeScene.activeCamera.view); // TODO: NOT HERE? ONLY ONCE?
	}
}
///
final class Materials : Singleton!Materials {
	///
	Material defaultMaterial;
	///
	void load() {
		defaultMaterial = new Material();
	}
}
immutable vertexCode = q{
	#version 450 core
	layout (location = 0) in vec3 position;
	//layout (location = 1) in vec4 color;
	layout (location = 2) in vec2 texCoords;
	out vec2 pixelTexCoords;
	uniform mat4 model;
	uniform mat4 view;
	uniform mat4 projection;
	//uniform vec4 pixelColor;
	void main() {
		gl_Position = projection * view * model * vec4(position, 1.0f);
		pixelTexCoords = texCoords;
	}
};
immutable fragmentCode = q{
	#version 450 core
	out vec4 fragColor;
	in vec2 pixelTexCoords;
	uniform sampler2D fragTexture;
	//uniform vec4 fillColor;
	void main() {
		fragColor = texture(fragTexture, pixelTexCoords);// * fillColor * pixelColor;
	}
};