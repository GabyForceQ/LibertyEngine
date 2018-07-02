/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/audio/engine.d, _engine.d)
 * Documentation:
 * Coverage:
 */
module liberty.audio.engine;
import liberty.core.utils : Singleton, IService;
/// A failing Audio function should <b>always</b> throw a $(D AudioEngineException).
final class AudioEngineException : Exception {
	/// Default constructor.
	this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) pure nothrow @safe {
		super(msg, file, line, next);
	}
}
///
final class AudioEngine : Singleton!AudioEngine, IService {
	private bool _serviceRunning;
	/// Start AudioEngine service.
    void startService() pure nothrow @safe @nogc {
        _serviceRunning = true;
    }
    /// Stop AudioEngine service.
    void stopService() pure nothrow @safe @nogc {
        _serviceRunning = false;
    }
    /// Restart AudioEngine service.
    void restartService() pure nothrow @safe @nogc {
        stopService();
        startService();
    }
	/// Returns true if AudioEngine service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
}