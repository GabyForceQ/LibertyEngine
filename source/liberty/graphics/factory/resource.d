/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/factory/resource.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.factory.resource;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.graphics.buffer.factory;

/**
 * Graphics resource factory interface.
**/
//interface IGfxResourceFactory : IGfxBufferFactory {
//}