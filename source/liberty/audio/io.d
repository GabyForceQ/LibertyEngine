/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/audio/io.d)
 * Documentation:
 * Coverage:
**/
module liberty.audio.io;

import liberty.audio.buffer.impl;
import liberty.audio.format.wav;
import liberty.io.manager;
import liberty.logger.impl;

/**
 *
**/
final abstract class AudioIO {
  /**
   *
  **/
  static AudioBuffer loadFile(string resourcePath) {
    import std.array : split;

    // Check extension
    string[] splitArray = resourcePath.split(".");	
    immutable extension = splitArray[$ - 1];
    switch (extension) {
      case "wav":
        return loadWAVFile(resourcePath);
      default:
        Logger.error(	
          "File format not supported for audio data: " ~ extension,	
          typeof(this).stringof	
        );
    }

    assert(0, "Unreachable");
  }

  //////////////
  import bindbc.openal;

  private static AudioBuffer loadWAVFile(string resourcePath) {
    char[] buf;

    // Read wav file and put its content into a buffer
    if (!IOManager.readFileToBuffer(resourcePath, buf, "rb"))
      Logger.error("Cannot read " ~ resourcePath ~ " file.", typeof(this).stringof);

    // Check if it is really a wav file
    if (!isWAVFormat(buf[0x00..0x10]))
      Logger.error("Not *.wav file: " ~ resourcePath, typeof(this).stringof);

    // Check if wav file has data
    if (!hasWAVData(buf[0x24..0x28]))
      Logger.error("No data found in " ~ resourcePath ~ " file.", typeof(this).stringof);

    WAVHeader header;
    ubyte[] audioData;

    // Fill wav header
    header.size = *cast(uint*)&buf[0x04];
    header.type[0] = *cast(char*)&buf[0x0C];
    header.type[1] = *cast(char*)&buf[0x0D];
    header.type[2] = *cast(char*)&buf[0x0E];
    header.type[3] = *cast(char*)&buf[0x0F];
    header.chunkSize = *cast(uint*)&buf[0x10];
    header.formatType = *cast(short*)&buf[0x14];
    header.channels = *cast(short*)&buf[0x16];
    header.sampleRate = *cast(uint*)&buf[0x18];
    header.avgBytesPerSec = *cast(uint*)&buf[0x1C];
    header.bytesPerSample = *cast(short*)&buf[0x20];
    header.bitsPerSample = *cast(short*)&buf[0x22];
    header.dataSize = *cast(uint*)&buf[0x28];

    // Fill audio data
    audioData = cast(ubyte[])buf[0x2C..buf.length];

    int format;
    if (header.bitsPerSample == 8) {
      if (header.channels == 1)
        format = AL_FORMAT_MONO8;
      else if (header.channels == 2)
        format = AL_FORMAT_STEREO8;
    } else if (header.bitsPerSample == 16) {
      if (header.channels == 1)
        format = AL_FORMAT_MONO16;
      else if (header.channels == 2)
        format = AL_FORMAT_STEREO16; 
    }

    auto buffer = AudioBuffer.createBuffer;
    alBufferData(
      buffer.getHandle,
      format,
      audioData.ptr,
      header.dataSize,
      header.sampleRate
    );

    return buffer;
  }

  private static bool isWAVFormat(in char[16] bytes)  {
    return
      bytes[0x00] == 'R' &&
      bytes[0x01] == 'I' &&
      bytes[0x02] == 'F' &&
      bytes[0x03] == 'F' &&
      bytes[0x08] == 'W' &&
      bytes[0x09] == 'A' &&
      bytes[0x0A] == 'V' &&
      bytes[0x0B] == 'E' &&
      bytes[0x0C] == 'f' &&
      bytes[0x0D] == 'm' &&
      bytes[0x0E] == 't' &&
      bytes[0x0F] == ' ';
  }

  private static bool hasWAVData(in char[4] bytes)  {
    return
      bytes[0x00] == 'd' &&
      bytes[0x01] == 'a' &&
      bytes[0x02] == 't' &&
      bytes[0x03] == 'a';
  }
}