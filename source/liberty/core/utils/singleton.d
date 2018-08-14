/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/utils/singleton.d, _singleton.d)
 * Documentation:
 * Coverage:
**/
 module liberty.core.utils.singleton;

/**
 *
**/
class Singleton(T) {
	private {
		__gshared T _instance;
		static bool _isInstantiated;
	}
	
  /**
   *
  **/
	protected this() pure nothrow @safe @nogc {}

  /**
   *
  **/
	static T self() @trusted {
		if (!_isInstantiated) {
			synchronized (Singleton.classinfo) {
				if (!_instance) {
					_instance = new T;
				}
				_isInstantiated = true;
			}
		}
		return _instance;
	}

  /**
   *
  **/
	static bool isInstantiated() nothrow @safe @nogc {
		return _isInstantiated;
	}
}