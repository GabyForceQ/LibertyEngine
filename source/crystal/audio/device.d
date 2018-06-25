/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.audio.device;
import crystal.audio.engine: AudioEngineException;
import derelict.sdl2.sdl: SDL_AudioDeviceID, SDL_AudioSpec, SDL_OpenAudioDevice, SDL_AudioStatus, SDL_GetAudioDeviceStatus,
    SDL_CloseAudioDevice, SDL_PauseAudioDevice, SDL_LockAudioDevice, SDL_UnlockAudioDevice, SDL_AUDIO_PLAYING;
import std.string: toStringz;
///
final class AudioDevice {
    private {
        SDL_AudioDeviceID _id;
    }
    ///
    this(const(char)[] name, int iscapture, const(SDL_AudioSpec*) desired, SDL_AudioSpec* obtained, int allowed_changes) {
        _id = SDL_OpenAudioDevice(toStringz(name), iscapture, desired, obtained, allowed_changes);
        if (_id == 0) {
            throw new AudioEngineException("SDL_OpenAudioDevice");
        }
    }
	///
	~this() {
        SDL_CloseAudioDevice(_id);
    }
    ///
    void play() nothrow {
        SDL_PauseAudioDevice(_id, 0);
    }
    ///
    void pause() nothrow {
        SDL_PauseAudioDevice(_id, 1);
    }
    ///
    void lock() nothrow {
        SDL_LockAudioDevice(_id);
    }
    ///
    void unlock() nothrow {
        SDL_UnlockAudioDevice(_id);
    }
    ///
    bool playing() nothrow {
        return status == SDL_AUDIO_PLAYING;
    }
    ///
    SDL_AudioStatus status() nothrow {
        return SDL_GetAudioDeviceStatus(_id);
    }
}