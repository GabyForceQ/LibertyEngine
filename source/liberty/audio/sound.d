/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/audio/sound.d)
 * Documentation:
 * Coverage:
**/
module liberty.audio.sound;

import bindbc.openal;

import liberty.audio.buffer.impl;

/**
 *
**/
final class SoundTrack {
  private {
    uint sourceId;
    int size;
  }

  /**
   *
  **/
  this(int size = 1)  {
    alGenSources(size, &sourceId);
    this.size = size;

    alSourcef(sourceId, AL_GAIN, 1);
    alSourcef(sourceId, AL_PITCH, 1);
    alSource3f(sourceId, AL_POSITION, 0, 0, 0);
  }

  /**
   *
  **/
  void play(AudioBuffer buffer) {
    alSourcei(sourceId, AL_BUFFER, buffer.getHandle);
    alSourcePlay(sourceId);
  }

  /**
   *
  **/
  void release()  {
    alDeleteSources(size, &sourceId);
  }
}