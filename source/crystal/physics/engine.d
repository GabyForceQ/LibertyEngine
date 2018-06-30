/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.physics.engine;
///
class PhysicsEngine {
	static:
    private bool serviceRunning;
	/// Start PhysicsEngine service.
    void startService() nothrow @safe @nogc {
        serviceRunning = true;
    }
    /// Stop PhysicsEngine service.
    void stopService() nothrow @safe @nogc {
        serviceRunning = false;
    }
    /// Restart PhysicsEngine service.
    void restartService() nothrow @safe @nogc {
        stopService();
        startService();
    }
}