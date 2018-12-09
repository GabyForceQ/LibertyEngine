/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/audio/format/wav.d)
 * Documentation:
 * Coverage:
**/
module liberty.audio.format.wav;

/**
 *
**/
struct WAVHeader {
  /**
   *
  **/
  char[4] type;

  /**
   *
  **/
  uint size;

  /**
   *
  **/
  uint chunkSize;

  /**
   *
  **/
  short formatType;

  /**
   *
  **/
  short channels;

  /**
   *
  **/
  uint sampleRate;

  /**
   *
  **/
  uint avgBytesPerSec;

  /**
   *
  **/
  short bytesPerSample;

  /**
   *
  **/
  short bitsPerSample;

  /**
   *
  **/
  uint dataSize;
}