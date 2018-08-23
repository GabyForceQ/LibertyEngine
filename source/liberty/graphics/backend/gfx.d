/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/backend/gfx.d, _gfx.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.backend.gfx;

import liberty.graphics.constants : Vendor;

package(liberty.graphics) abstract class GfxBackend {
  protected {
    string[] _extensions;
    int _majorVersion;
    int _minorVersion;
    int _maxColorAttachments;
  }

	/**
   *
  **/
  void reloadContext() @trusted;

	/**
   *
  **/
	void clearColor(float r, float g, float b, float a) @trusted;

  /**
   *
  **/
  void enable3DCapabilities() @trusted;

	/**
   *
  **/
  void clearScreen() @trusted;

	/**
   * Returns true if the graphics API extension is supported.
  **/
  bool supportsExtension(string extension) pure nothrow @safe;
    
	/**
   *
  **/
	debug void debugCheck() nothrow @trusted;
    
	/**
   *
  **/
	void runtimeCheck() @trusted;
    
	/**
   *
  **/
	bool runtimeCheckNothrow() nothrow;
    
	/**
   *
  **/
	int getMajorVersion() pure nothrow const @safe;
    
	/**
   *
  **/
	int getMinorVersion() pure nothrow const @safe;
    
	/**
   *
  **/
	const(char)[] getVersionString() @safe;
    
	/**
   *
  **/
	const(char)[] getVendorString() @safe;
    
	/**
   *
  **/
	Vendor getVendor() @safe;
    
	/**
   *
  **/
	const(char)[] getGraphicsEngineString() @safe;
    
	/**
   *
  **/
	const(char)[] getShadingVersionString() @safe;
    
	/**
   *
  **/
	string[] getExtensions() pure nothrow @safe;
    
	/**
   *
  **/
	int getMaxColorAttachments() pure nothrow const @safe;
    
	/**
   *
  **/
	void getActiveTexture(int texture_id) @trusted;
}