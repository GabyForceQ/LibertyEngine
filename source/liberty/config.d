/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/config.d, _config.d)
 * Documentation:
 * Coverage:
 */
module liberty.config;

version (Windows) {

	/**
	 * Version: Windows
	 */
	enum __Mobile__ = false;

} else version (OSX) {

	/**
	 * Version: OSX
	 */
	enum __Mobile__ = false;

} else version (linux) {

	/**
	 * Version: linux
	 */
	enum __Mobile__ = false;

} else version (Andorid) {

	/**
	 * Version: Android
	 */
	enum __Mobile__ = true;

}

version (__OpenGL__) {
	
	/**
	 * Version: __OpenGL__
	 */
	enum __RowMajor__ = true;
	
	/**
	 * Version: __OpenGL__
	 */
	enum __ColumnMajor__ = false;

} else version (__Vulkan__) {
	
	/**
	 * Version: __Vulkan__
	 */
	enum __RowMajor__ = false;
	
	/**
	 * Version: __Vulkan__
	 */
	enum __ColumnMajor__ = true;

}