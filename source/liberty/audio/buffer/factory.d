/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/audio/buffer/factory.d)
 * Documentation:
 * Coverage:
**/
module liberty.audio.buffer.factory;

import bindbc.openal;

import liberty.audio.buffer.impl;

/**
 *
**/
interface IAudioBufferFactory {
  private {
    static uint[] buffers;
  }

  /**
   *
  **/
  static AudioBuffer createBuffer(int size = 1) {
    auto buff = new AudioBuffer(size);
    buffers ~= buff.getHandle;
    return buff;
  }

  /**
   *
  **/
  static void release()  {
    alDeleteBuffers(buffers.length, buffers.ptr);
  }
}                                              