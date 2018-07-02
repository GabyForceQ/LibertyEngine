/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/ai/engine.d, _engine.d)
 * Documentation:
 * Coverage:
 */
module liberty.ai.engine;
import liberty.core.utils : Singleton;
/// A failing AI function should <b>always</b> throw a $(D AIEngineException).
final class AIEngineException : Exception {
	/// Default constructor.
	this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) pure nothrow @safe {
		super(msg, file, line, next);
	}
}
///
class AIEngine : Singleton!AIEngine {
	private bool _serviceRunning;
	/// Start AIEngine service.
    void startService() nothrow @safe @nogc {
        _serviceRunning = true;
    }
    /// Stop AIEngine service.
    void stopService() nothrow @safe @nogc {
        _serviceRunning = false;
    }
    /// Restart AIEngine service.
    void restartService() nothrow @safe @nogc {
        stopService();
        startService();
    }
	/// Returns true if AIEngine service is running.
	bool isServiceRunning() nothrow @safe @nogc {
		return _serviceRunning;
	}
}