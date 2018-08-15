/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/mvc/components/meta.d, _meta.d)
 * Documentation:
 * Coverage:
 */
module liberty.mvc.components.meta;

/**
 *
 */
struct Component;

/**
 *
 */
struct ComponentField(string access) {
	static if (access == "ReadWrite") {
		///
		string getMethod = "Unspecified";
		///
		string setMethod = "Unspecified";
	} else static if (access == "ReadOnly") {
		///
		string getMethod = "Unspecified";
	} else static if (access == "WriteOnly") {
		///
		string setMethod = "Unspecified";
	} else {
		static assert (0, "Unknown access type!");
	}
}

/**
 *
 */
immutable ComponentBody = q{};