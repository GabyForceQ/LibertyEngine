/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/utils.d, _utils.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.utils;
///
class Singleton(T) {
	private {
		__gshared T _instance;
		static bool _isInstantiated;
	}
	///
	protected this() {}
	///
	static T get() @trusted {
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
	///
	static bool isInstantiated() nothrow @safe @nogc {
		return _isInstantiated;
	}
}
///
size_t arraySize(T)(T[] array) pure nothrow @safe @nogc {
	return array.sizeof * array.length;
}
///
pure nothrow @safe unittest {
	immutable int[] arr = [4, 5, -6];
	assert (arr.arraySize == 24, "Array size of arr must be 8 * 3 = 24!");
}
/// IService interface for engine manager classes.
interface IService {
	/// Strat service.
	void startService() @trusted;
	/// Strat service.
	void stopService() @trusted;
	/// Strat service.
	void restartService() @trusted;
	/// Strat service.
	bool isServiceRunning() pure nothrow const @safe @nogc;
}