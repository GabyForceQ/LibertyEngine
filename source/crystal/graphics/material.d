module crystal.graphics.material;
import crystal.core.engine;
import crystal.core.scenegraph.scene;
import crystal.core.imaging;
import crystal.graphics;
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
		_shader = RenderUtil.createShaderProgram(vertexCode, fragmentCode);
		Scene.shaderList[_shader.getProgramID().to!string] = _shader;
		glGenTextures(1, &_textureID);
        _texture = new Bitmap(CoreEngine.getImageAPI(), "res/brick.bmp");
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
	ShaderProgram getShader() {
		return _shader;
	}
	///
	uint getTextureId() pure nothrow const {
		return _textureID;
	}
	///
	void render() {
		_shader.loadUniform("projection", CoreEngine.getActiveScene().activeCamera.getProjection()); // TODO: NOT HERE? ONLY ONCE?
        _shader.loadUniform("view", CoreEngine.getActiveScene().activeCamera.getView()); // TODO: NOT HERE? ONLY ONCE?
	}
}
///
final class Materials {
	static:
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