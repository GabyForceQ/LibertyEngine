/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/content/manager.d, _manager.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.content.manager;
import liberty.core.utils : Singleton, IService;
import derelict.assimp3.assimp;
import derelict.util.exception;
/// A failing AssetManager function should <b>always</b> throw a $(D AssetManagerException).
final class AssetManagerException : Exception {
	/// Default constructor.
	this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) @safe {
		super(msg, file, line, next);
        import liberty.core.logger : Logger;
        import std.conv : to;
        Logger.get.exception("Message: '" ~ msg ~ "'; File: '" ~ file ~ "'; Line:'" ~ line.to!string ~ "'.");
	}
}
///
final class AssetManager : Singleton!AssetManager, IService {
    private bool _serviceRunning;
	/// Start AssetManager service.
    void startService() @trusted {
        try {
            DerelictASSIMP3.load();
        } catch(DerelictException e) {
            throw new AssetManagerException(e.msg);
        }
        _serviceRunning = true;
    }
    /// Stop AssetManager service.
    void stopService() pure nothrow @safe @nogc {
        _serviceRunning = false;
    }
    /// Restart AssetManager service.
    void restartService() @trusted {
        stopService();
        startService();
    }
	/// Returns true if AssetManager service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
}