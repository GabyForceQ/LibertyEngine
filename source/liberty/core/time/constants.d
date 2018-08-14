/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/time/constants.d, _constants.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - TimeZone (https://www.zeitverschiebung.net/en/all-time-zones.html)
**/
module liberty.core.time.constants;

/**
 *
**/
enum DayTime : ubyte {
  /**
   *
  **/
  AM = 0x00,

  /**
   *
  **/
  PM = 0x01
}

/**
 *
**/
enum DayCycle : ubyte {
  /**
   *
  **/
  Sunrise = 0x00,

  /**
   *
  **/
  Day = 0x01,

  /**
   *
  **/
  Sunset = 0x02,

  /**
   *
  **/
  Night = 0x03
}

/**
 *
**/
enum Day : ubyte {
  /**
   *
  **/
  Sunday = 0x00,

  /**
   *
  **/
  Monday = 0x01,

  /**
   *
  **/
  Tuesday = 0x02,

  /**
   *
  **/
  Wednesday = 0x03,

  /**
   *
  **/
  Thursday = 0x04,

  /**
   *
  **/
  Friday = 0x05,

  /**
   *
  **/
  Saturday = 0x06
}

/**
 *
**/
enum Month : ubyte {
  /**
   *
  **/
  January = 0x00,

  /**
   *
  **/
  February = 0x01,

  /**
   *
  **/
  March = 0x02,

  /**
   *
  **/
  April = 0x03,

  /**
   *
  **/
  May = 0x04,

  /**
   *
  **/
  June = 0x05,

  /**
   *
  **/
  July = 0x06,

  /**
   *
  **/
  August = 0x07,

  /**
   *
  **/
  September = 0x08,

  /**
   *
  **/
  October = 0x09,

  /**
   *
  **/
  November = 0x0A,

  /**
   *
  **/
  December = 0x0B
}

/**
 *
**/
enum Season : ubyte {
  /**
   *
  **/
  Winter = 0x00,
  
  /**
   *
  **/
  Spring = 0x01,

  /**
   *
  **/
  Summer = 0x02,

  /**
   *
  **/
  Autum = 0x03
}

/**
 *
**/
enum TimeZone : string {
  /**
   *
  **/
  UTC_M_11_Pacific_Mildway = "UTC-11 Pacific/Mildway",

  /**
   *
  **/
  UTC_M_11_Pacific_Niue = "UTC-11 Pacific/Niue",

  /**
   *
  **/
  UTC_M_11_Pacific_PagoPago = "UTC-11 Pacific/Pago_Pago"
}