/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.ui.view;
///
enum Orientation : byte {
	///
	Horizontal = 0x00,
	///
	Vertical = 0x01
}
version (__Lite__) {
} else {
	/// Number of elements of Orientation enumeration (!LiteVersion).
	enum OrientationCount = __traits(allMembers, Orientation).length;
}