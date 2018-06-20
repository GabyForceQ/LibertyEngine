/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.graphics.renderer;
import crystal.math.vector : Vector2F, Vector3F;
///
static struct Vertex {
	Vector3F position;
	Vector2F texCoords;
}
///
enum Vendor : byte {
	///
	Amd = 0x00,
	///
	Intel = 0x01,
	///
	Nvidia = 0x02,
	///
	Mesa = 0x03,
	/// For Software rendering, no driver
	Apple = 0x04,
	/// For GDI Generic, no driver
	Microsoft = 0x05,
	///
	Other = -0x01
}
version (__Lite__) {
} else {
	/// Number of elements of Vendor enumeration (!LiteVersion)
	enum VendorCount = __traits(allMembers, Vendor).length;
}
///
enum Blending : byte {
	///
	Opaque = 0x00,
	///
	AlphaBlend = 0x01,
	///
	NonPremultiplied = 0x02,
	///
	Additive = 0x03
}
///
enum Sampling : byte {
	///
	AnisotropicClamp = 0x00,
	///
	AnisotropicWrap = 0x01,
	///
	LinearClamp = 0x02,
	///
	LinearWrap = 0x03,
	///
	PointClamp = 0x04,
	///
	PointWrap = 0x05
}
///
enum VSyncState : byte {
	///
	Immediate = 0x00,
	///
	Default = 0x01,
	///
	LateTearing = -0x01
	// TODO: GSync / FreeSync ?
}
///
enum DataUsage : byte {
	///
	StreamDraw = 0x00,
	///
	StreamRead = 0x01,
	///
	StreamCopy = 0x02,
	///
	StaticDraw = 0x03,
	///
	StaticRead = 0x04,
	///
	StaticCopy = 0x05,
	///
	DynamicDraw = 0x06,
	///
	DynamicRead = 0x07,
	///
	DynamicCopy = 0x08
}
///
enum DrawMode : byte {
	///
	Triangles = 0x00
}
///
enum VectorType : byte {
	///
	UnsignedInt = 0x00
}
///
interface Renderable {
	///
	void render();
}
