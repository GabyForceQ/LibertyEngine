/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
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
	static T get() {
		if(!_isInstantiated) {
			synchronized(Singleton.classinfo) {
				if (!_instance) {
					_instance = new T;
				}
				_isInstantiated = true;
			}
		}
		return _instance;
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