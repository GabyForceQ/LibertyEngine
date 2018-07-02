/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.physics.engine;
import liberty.core.utils : Singleton;
/// A failing Physics function should <b>always</b> throw a $(D PhysicsEngineException).
final class PhysicsEngineException : Exception {
	/// Default constructor.
	this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) pure nothrow @safe {
		super(msg, file, line, next);
	}
}
///
class PhysicsEngine : Singleton!PhysicsEngine {
    private bool _serviceRunning;
	/// Start PhysicsEngine service.
    void startService() nothrow @safe @nogc {
        _serviceRunning = true;
    }
    /// Stop PhysicsEngine service.
    void stopService() nothrow @safe @nogc {
        _serviceRunning = false;
    }
    /// Restart PhysicsEngine service.
    void restartService() nothrow @safe @nogc {
        stopService();
        startService();
    }
    /// Returns true if PhysicsEngine service is running.
	bool isServiceRunning() nothrow @safe @nogc {
		return _serviceRunning;
	}
}