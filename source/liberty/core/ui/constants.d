/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/ui/constants.d, _constants.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.ui.constants;

/**
 * Screen orientation.
 */
enum Orientation : byte {
	
	/**
	 * Horizontal orientation.
	 */
	Horizontal = 0x00,
	
	/**
	 * Vertical orientation.
	 */
	Vertical = 0x01

}

/**
 *
 */
enum WidgetBolt : string {

	/**
     *
     */
    Update = "Update",

    /**
     *
     */
    Render = "Render"

}

/**
 *
 */
enum ButtonBolt : string {

	/**
	 *
	 */
	MouseLeftClick = "MouseLeftClick",

    /**
     *
     */
	MouseMiddleClick = "MouseMiddleClick",

    /**
     *
     */
	MouseRightClick = "MouseRightClick",

    /**
     *
     */
	MouseMove = "MouseMove",

    /**
     *
     */
	MouseInside = "MouseInside"

}