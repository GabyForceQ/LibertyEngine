/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/db/engine.d, _engine.d)
 * Documentation:
 * Coverage:
**/
module liberty.db.engine;

import liberty.core.utils : Singleton;
import liberty.core.manager.meta : ManagerBody;
import liberty.db.database : Database;

/**
 *
**/
final class DBEngine : Singleton!DBEngine {	
  mixin(ManagerBody);

  private {
    Database[string] databases;
  }

  /**
   *
  **/
  void connectTo(string databaseId, string connectionUrl) {
    databases[databaseId] = new Database(connectionUrl);
  }

  /**
   *
  **/
  void disconnectFrom(string databaseId) {
    databases.remove(databaseId);
  }
}