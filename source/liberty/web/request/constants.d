/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/web/request/constants.d, _constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.web.request.constants;

/**
 *
**/
enum RequestType : string {
  /**
   *
  **/
  Get = "GET",

  /**
   *
  **/
  Post = "POST",

  /**
   *
  **/
  Put = "PUT",

  /**
   *
  **/
  Patch = "PATCH",

  /**
   *
  **/
  Delete = "DELETE"
}