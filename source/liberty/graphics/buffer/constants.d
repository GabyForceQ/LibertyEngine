/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/buffer/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.buffer.constants;

/**
 * Represents the target to which the buffer object is bound.
**/
enum GfxBufferTarget : byte {
  /**
	 * Vertex attributes.
  **/
	ARRAY = 0x00,
  
  /**
	 * Atomic counter storage.
  **/
	ATOMIC_COUNTER = 0x01,
  
  /**
	 * Buffer copy source.
  **/
	COPY_READ = 0x02,
  
  /**
	 * Buffer copy destination.
  **/
	COPY_WRITE = 0x03,
  
  /**
	 * Indirect compute dispatch commands.
  **/
	DISPATCH_INDIRECT = 0x04,
  
  /**
	 * Indirect command arguments.
  **/
	DRAW_INDIRECT = 0x05,
  
  /**
	 * Vertex array indices.
  **/
	ELEMENT_ARRAY = 0x06,
  
  /**
	 * Pixel read target.
  **/
	PIXEL_PACK = 0x07,
  
  /**
	 * Texture data source.
  **/
	PIXEL_UNPACK = 0x08,
  
  /**
	 * Query result buffer.
  **/
	QUERY = 0x09,
  
  /**
	 * Read-write storage for shaders.
  **/
	SHADER_STORAGE = 0x0A,
  
  /**
	 * Texture data buffer.
  **/
	TEXTURE = 0x0B,
  
  /**
	 * Transform feedback buffer.
  **/
	TRANSFORM_FEEDBACK = 0x0C,
  
  /**
	 * Uniform block storage.
  **/
	UNIFORM = 0x0D
}

/**
 *
**/
enum GfxDataUsage : byte {
  /**
   *
  **/
	STREAM_DRAW = 0x00,
  
  /**
   *
  **/
	STREAM_READ = 0x01,
  
  /**
   *
  **/
	STREAM_COPY = 0x02,
  
  /**
   *
  **/
	STATIC_DRAW = 0x03,
  
  /**
   *
  **/
	STATIC_READ = 0x04,
  
  /**
   *
  **/
	STATIC_COPY = 0x05,
  
  /**
   *
  **/
	DYNAMIC_DRAW = 0x06,
  
  /**
   *
  **/
	DYNAMIC_READ = 0x07,
  
  /**
   *
  **/
	DYNAMIC_COPY = 0x08
}