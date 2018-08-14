module liberty.core.image.loader;

//
import derelict.opengl;

import liberty.core.logger.manager : Logger;
import liberty.core.manager.meta : ManagerBody;
import liberty.core.utils : Singleton;
import liberty.core.image.bitmap : Bitmap;
import liberty.graphics.texture.data : Texture;

/**
 * Singleton class used for loading image files.
 * It's a manager class so it implements $(D ManagerBody).
**/
final class ImageLoader : Singleton!ImageLoader {

    mixin(ManagerBody);

    Texture loadBMP(string resourcePath) {
        
        // Check if service is running
        if (checkService()) {
            Texture texture;

            // Load texture form file
            auto bitmap = new Bitmap(resourcePath);

            // Generate OpenGL texture
            glGenTextures(1, &texture.id);

            // Bind the texture
            glBindTexture(GL_TEXTURE_2D, texture.id);
            glTexImage2D(
                GL_TEXTURE_2D, 
                0, 
                GL_RGBA8, //GL_RGBA,
                bitmap.width,
                bitmap.height,
                0,
                GL_RGBA,
                GL_UNSIGNED_INT_8_8_8_8, //GL_UNSIGNED_BYTE,
                bitmap.data
            );

            // Set texture parameters
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

            // Generate mipmap
            glGenerateMipmap(GL_TEXTURE_2D);

            // Unbind the current texture
            glBindTexture(GL_TEXTURE_2D, 0);

            // Set Texture width and height
            texture.width = bitmap.width;
            texture.height = bitmap.height;

            return texture;
        }

        return Texture();
    }

}

/*
this(string resourcePath) {
		_shader = RenderUtil.self.createShaderProgram(vertexCode, fragmentCode);
		Scene.shaderList[_shader.programID.to!string] = _shader;
		glGenTextures(1, &_textureID);
        _texture = new Bitmap(CoreEngine.self.imageAPI, resourcePath);
        glBindTexture(GL_TEXTURE_2D, _textureID);
        if (_texture.data()) {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, _texture.width(), _texture.height(), 0, 
				GL_RGBA, GL_UNSIGNED_INT_8_8_8_8, _texture.data());
            glGenerateMipmap(GL_TEXTURE_2D);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_LOD_BIAS, -0.7f);
        } else {
            assert(0);
        }
        _shader.start();
        _shader.loadUniform("fragTexture", 0);
	}
*/