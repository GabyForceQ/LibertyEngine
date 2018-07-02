/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/config.d, _config.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.config;
version (Windows) {
	///
	enum __Mobile__ = false;
}
version (OSX) {
	///
	enum __Mobile__ = false;
}
version (linux) {
	///
	enum __Mobile__ = false;
}
version (Andorid) {
	///
	enum __Mobile__ = true;
}
version (__OpenGL__) {
	///
	enum __RowMajor__ = true;
	///
	enum __ColumnMajor__ = false;
} else {
	///
	enum __RowMajor__ = false;
	///
	enum __ColumnMajor__ = true;
}