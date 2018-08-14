module liberty.core.system.resource.manager;

import liberty.core.utils : Singleton;
import liberty.core.logger.meta : ExceptionConstructor;
import liberty.core.manager.meta : ManagerBody;
import liberty.graphics.texture.cache : TextureCache;
import liberty.graphics.texture.data : Texture;

/**
 * A failing ResourceManager function should <b>always</b> throw a $(D ResourceException).
**/
final class ResourceException : Exception {

    mixin(ExceptionConstructor);

}

/**
 *
**/
final class ResourceManager : Singleton!ResourceManager {

    mixin(ManagerBody);

    private {
        TextureCache _textureCache;
    }

    private static immutable startBody = q{
        _textureCache = new TextureCache();
    };

    //uint boundTexture;

    Texture texture(string resourcePath) {

        // Check if service is running
        if (checkService()) {
            return _textureCache.getTexture(resourcePath);
        }
        
        return Texture();
    }

}