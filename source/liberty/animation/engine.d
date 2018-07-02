/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/animation/engine.d, _engine.d)
 * Documentation:
 * Coverage:
 */
module liberty.animation.engine;
import liberty.core.utils : Singleton;
/// A failing Animation function should <b>always</b> throw a $(D AnimationEngineException).
final class AnimationEngineException : Exception {
	/// Default constructor.
	this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) pure nothrow @safe {
		super(msg, file, line, next);
	}
}
///
class AnimationEngine : Singleton!AnimationEngine {
	private bool _serviceRunning;
	/// Start AnimationEngine service.
    void startService() nothrow @safe @nogc {
        _serviceRunning = true;
    }
    /// Stop AnimationEngine service.
    void stopService() nothrow @safe @nogc {
        _serviceRunning = false;
    }
    /// Restart AnimationEngine service.
    void restartService() nothrow @safe @nogc {
        stopService();
        startService();
    }
	/// Returns true if AnimationEngine service is running.
	bool isServiceRunning() nothrow @safe @nogc {
		return _serviceRunning;
	}
}