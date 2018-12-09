/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/audio/buffer/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.audio.buffer.impl;

import bindbc.openal;

import liberty.audio.buffer.factory;

/**
 *
**/
final class AudioBuffer : IAudioBufferFactory {
  private {
    uint buffer;
    int size;
  }

  /**
   *
  **/
  this(int size = 1) nothrow {
    alGenBuffers(size, &buffer);
    this.size = size;
  }

  /**
   *
  **/
  void setListenerData() nothrow {
    alListener3f(AL_POSITION, 0, 0, 0);
    alListener3f(AL_VELOCITY, 0, 0, 0);
  }

  /**
   *
  **/
  uint getHandle() pure nothrow const {
    return buffer;
  }
}