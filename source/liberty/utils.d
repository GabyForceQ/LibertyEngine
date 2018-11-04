/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/utils.d)
 * Documentation:
 * Coverage:
**/
module liberty.utils;

/**
 * Returns the exact length of a buffer.
**/
size_t bufferSize(T)(T[] buffer) pure nothrow {
	return buffer.length * T.sizeof;
}

/**
 * Example of $(D bufferSize) usage.
**/
unittest {
	immutable int[] arr = [4, 5, -6];
	assert (arr.bufferSize == 12, "Array size of arr must be 4 * 3 = 12!");
}