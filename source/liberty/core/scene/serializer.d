/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/scene/serializer.d, _serializer.d)
 * Documentation:
 * Coverage:
 */

module liberty.core.scene.serializer;

import liberty.core.scene.wrapper : Scene;
import liberty.core.utils : Singleton;
import liberty.core.logger : Logger, ManagerBody, WarningMessage;

/**
 *
 */
final class SceneSerializer : Singleton!SceneSerializer {

    mixin(ManagerBody);

    private {
        immutable {
            string _ext = ".lyscn";
            string _arr = " >> ";
            string _inf = ": ";
            string _nxt = ", ";
            string _str = `"`;
            string _end = "\r\n"; // TODO. Check OS version
        }
        enum PropTkn : string {
            id = "id"
        }
    }
    
    /**
     *
     */
    void serialize(Scene scene) {
        if (_serviceRunning) {
            import std.stdio : File;
            import std.conv : to;
            auto file = new File(scene.id.to!string ~ _ext, "w");
            scope (exit) file.close();
            // TODO. Parse children too
            //foreach (node; scene.tree) {
            //    file.writeln(node.stringof ~ _arr ~ PropTkn.id ~ _inf ~ _str ~ node.id.to!string ~ _str);
                // TODO. foreach all node members searching for other props including construction default values
            //    file.write(_end);
            //}
        } else {
            Logger.get.warning(WarningMessage.ServiceNotRunning, this);
        }
    }

    /**
     *
     */
    Scene deserialize(string path) {
        if (_serviceRunning) {
            import std.stdio : File;
            import std.conv : to;
            import std.array : split;
            string id = path.split('/')[$ - 1]; // TODO. Check if it has at least one /
            auto file = new File(path ~ _ext, "r");
            scope (exit) file.close();
            // TODO. Read file
            auto scene = new Scene(id);
            return scene;
        } else {
            Logger.get.warning(WarningMessage.ServiceNotRunning, this);
            Logger.get.warning(WarningMessage.NullReturn, this);
            return null;
        }
    }

}