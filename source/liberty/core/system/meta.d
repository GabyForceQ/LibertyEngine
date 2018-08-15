/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/meta.d, _meta.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.meta;

version (unittest) {
  /**
   *
  **/
  immutable EngineRun = q{};
} else {
  /**
   *
  **/
  immutable EngineRun = q{
    int main() {
      CoreEngine.self.startService();
      libertyMain();
      CoreEngine.self.run();
      return 0;
    }
  };
}