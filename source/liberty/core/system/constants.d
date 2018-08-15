/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/constants.d, _constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.constants;

/**
 *
**/
enum EngineState : string {
  /**
   *
  **/
  None = "None",

  /**
   *
  **/
  Starting = "Starting",

  /**
   *
  **/
  Started = "Started",

  /**
   *
  **/
  Stopping = "Stopping",

  /**
   *
  **/
  Stopped = "Stopped",

  /**
   *
  **/
  Running = "Running",

  /**
   *
  **/
  Paused = "Paused",

  /**
   *
  **/
  ShouldQuit = "ShouldQuit"
}

/**
 *
**/
enum EngineAction : string {
  /**
   *
  **/
  LoadingScene = "LoadingScene"
}

/**
 *
**/
enum Owned : ubyte {
  /**
   *
  **/
  No = 0x00,

  /**
   *
  **/
  Yes = 0x01
}