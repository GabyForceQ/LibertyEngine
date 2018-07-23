/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/content/manager.d, _manager.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.content.manager;
import liberty.core.utils : Singleton;
import liberty.core.logger : Logger;
import derelict.assimp3.assimp;
import derelict.util.exception;
import liberty.core.utils.meta : ExceptionConstructor;

/// A failing AssetManager function should <b>always</b> throw a $(D AssetManagerException).
final class AssetManagerException : Exception {

    mixin(ExceptionConstructor);

}
///
final class AssetManager : Singleton!AssetManager {
    private bool _serviceRunning;
	/// Start AssetManager service.
    void startService() @trusted {
        try {
            DerelictASSIMP3.load();
        } catch(DerelictException e) {
            throw new AssetManagerException(e.msg);
        }
        _serviceRunning = true;
        Logger.get.info("AssetManager service started.", this);
    }
    /// Stop AssetManager service.
    void stopService() @safe {
        _serviceRunning = false;
        Logger.get.info("AssetManager service stopped.", this);
    }
    /// Restart AssetManager service.
    void restartService() @safe {
        stopService();
        startService();
    }
	/// Returns true if AssetManager service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
}