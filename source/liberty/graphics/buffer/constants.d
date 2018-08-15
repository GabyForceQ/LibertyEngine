module liberty.graphics.buffer.constants;

/**
 * Represents the target to which the buffer object is bound.
**/
enum BufferTarget : byte {
  /**
	 * Vertex attributes.
	**/
  Array = 0x00,
	
  /**
   * Atomic counter storage.
	**/
  AtomicCounter = 0x01,
	
  /**
   * Buffer copy source.
	**/
  CopyRead = 0x02,
	
  /**
   * Buffer copy destination.
	**/
  CopyWrite = 0x03,

  /**
	 * Indirect compute dispatch commands.
	**/
  DispatchIndirect = 0x04,
	
  /**
   * Indirect command arguments.
	**/
  DrawIndirect = 0x05,

  /**
	 * Vertex array indices.
	**/
  ElementArray = 0x06,

  /**
	 * Pixel read target.
	**/
  PixelPack = 0x07,
	
  /**
   * Texture data source.
	**/
  PixelUnpack = 0x08,
	
  /**
   * Query result buffer.
	**/
  Query = 0x09,

  /**
	 * Read-write storage for shaders.
	**/
  ShaderStorage = 0x0A,
	
  /**
   * Texture data buffer.
	**/
  Texture = 0x0B,
	
  /**
   * Transform feedback buffer.
	**/
  TransformFeedback = 0x0C,
	
  /**
   * Uniform block storage.
	**/
  Uniform = 0x0D
}