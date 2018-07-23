/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/utils/array.d, _array.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.utils.array;

/**
 *
 */
size_t arraySize(T)(T[] array) pure nothrow @safe @nogc {
	return array.sizeof * array.length;
}

/**
 * Example of $(D arraySize) usage:
 */
pure nothrow @safe unittest {
	immutable int[] arr = [4, 5, -6];
	assert (arr.arraySize == 24, "Array size of arr must be 8 * 3 = 24!");
}