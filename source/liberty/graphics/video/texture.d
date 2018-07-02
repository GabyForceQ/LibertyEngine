/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/video/texture.d, _texture.d)
 * Documentation:
 * Coverage:
 */
module liberty.graphics.video.texture;
///
enum TextureWrapping : byte {
	/// Repeats the texture image.
	Repeat = 0x00,
	///
	MirroredRepeat = 0x01,
	///
	ClampToEdge = 0x02,
	///
	ClampToBorder = 0x03
}
///
enum TextureFiltering : byte {
	///
	Nearest = 0x00,
	///
	Linear = 0x01
}
///
enum MipmapFiltering : byte {
	///
	NearestNearest = 0x00,
	///
	LinearNearest = 0x01,
	///
	NearestLinear = 0x02,
	///
	LinearLinear = 0x03
}