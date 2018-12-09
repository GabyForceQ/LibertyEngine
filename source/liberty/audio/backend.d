/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/audio/backend.d)
 * Documentation:
 * Coverage:
**/
module liberty.audio.backend;

import bindbc.openal;

import liberty.logger.impl;

/**
 *
**/
final abstract class AudioBackend {
  /**
   * It loads the OpenAL 1.1 shared library.
  **/
  static void initialize() {
    Logger.info("Start creating audio backend", typeof(this).stringof);

    const res = loadOpenAL;
    if (res != ALSupport.al11) {
      if (res == ALSupport.noLibrary)
        Logger.error(
          "Failed to load OpenAL 1.1 shared library.",
          typeof(this).stringof
        );
      else if (res == ALSupport.badLibrary)
        Logger.error(
          "Failed to load one or more symbols from OpenAL 1.1 shared library.",
          typeof(this).stringof
        );
    } else
      Logger.info(
        "OpenAL 1.1 has been loaded successfully",
        typeof(this).stringof
      );

    ALCdevice* device;
    ALCcontext* context;

    device = alcOpenDevice(null);
    if (device is null)
      assert(0);

    context = alcCreateContext(device, null);
    alcMakeContextCurrent(context);
    if (!context)
      assert(0);
  }
}