/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/logger/meta.d, _meta.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.logger.meta;

/**
 * Mixin this only in a Singleton class.
 * You must declare two 'private static' raw strings named 'startBody' and 'stopBody'.
 * In 'startBody' you code what will be run when startService() function is called.
 * In 'stopBody' you code what will be run when stopService() function is called.
 */
immutable ManagerBody = q{

    private bool _serviceRunning;
	
    /**
     * Start this service.
     */
    void startService() @trusted {
        import liberty.core.logger : WarningMessage, InfoMessage;
        if (_serviceRunning) {
            Logger.get.warning(WarningMessage.ServiceAlreadyRunning, this);
        } else {
            _serviceRunning = true;
            mixin(startBody);
            Logger.get.info(InfoMessage.ServiceStarted, this);
        }
    }

    /**
     * Stop this service.
     */
    void stopService() @trusted {
        import liberty.core.logger : WarningMessage, InfoMessage;
        if (_serviceRunning) {
            mixin(stopBody);
            Logger.get.info(InfoMessage.ServiceStopped, this);
            _serviceRunning = false;
        } else {
            Logger.get.warning(WarningMessage.ServiceNotRunning, this);
        }
    }

    /**
     * Restart this service by calling stopService() function first, then startService().
     * This is the safest way to restart a service.
     */
    void restartService() @safe {
        stopService();
        startService();
    }

    /**
     * Returns true if this service is running.
     */
    bool isServiceRunning() pure nothrow const @safe @nogc @property {
        return _serviceRunning;
    }

};