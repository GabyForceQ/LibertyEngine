/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/manager/meta.d, _meta.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.manager.meta;

/**
 * Mixin this only in a Singleton class.
 * You can declare two 'private static' raw strings named 'startBody' and 'stopBody'.
 * In 'startBody' you code what will be run when startService() function is called.
 * In 'stopBody' you code what will be run when stopService() function is called.
**/
immutable ManagerBody = q{
  private bool _serviceRunning;
	
  /**
   * Start this service.
  **/
  void startService() @trusted {
    import liberty.core.logger : Logger, WarningMessage, InfoMessage;
    if (_serviceRunning) {
      Logger.self.warning(WarningMessage.ServiceAlreadyRunning, typeof(this).stringof);
    } else {
      _serviceRunning = true;
      static if (__traits(compiles, startBody)) {
        import std.traits : isMutable;
        static if (__traits(getProtection, startBody) != "private") {
          static assert (0, "startBody must be private");
        }
        static if (isMutable!(typeof(startBody))) {
          static assert (0, "startBody must be immutable or const");
        }
        mixin(startBody);
      }
      Logger.self.info(InfoMessage.ServiceStarted, typeof(this).stringof);
    }
  }

  /**
   * Stop this service.
  **/
  void stopService() @trusted {
      import liberty.core.logger : Logger, WarningMessage, InfoMessage;
      if (_serviceRunning) {
        static if (__traits(compiles, stopBody)) {
          import std.traits : isMutable;
          static if (__traits(getProtection, stopBody) != "private") {
            static assert (0, "stopBody must be private");
          }
          static if (isMutable!(typeof(stopBody))) {
            static assert (0, "stopBody must be immutable or const");
          }
          mixin(stopBody);
        }
        Logger.self.info(InfoMessage.ServiceStopped, typeof(this).stringof);
        _serviceRunning = false;
      } else {
        Logger.self.warning(WarningMessage.ServiceNotRunning, typeof(this).stringof);
      }
  }

  /**
   * Restart this service by calling stopService() function first, then startService().
   * This is the safest way to restart a service.
  **/
  void restartService() @safe {
    stopService();
    startService();
  }

  /**
   * Returns true if this service is running.
  **/
  bool isServiceRunning() pure nothrow const @safe @nogc @property {
    return _serviceRunning;
  }

  /**
   * If the service is not running the logger will warn you.
  **/
  private bool checkService() {
    import liberty.core.logger : Logger, WarningMessage;

    if (!_serviceRunning) {
      Logger.self.error(WarningMessage.ServiceNotRunning, typeof(this).stringof);
    }

    return _serviceRunning;
  }
};