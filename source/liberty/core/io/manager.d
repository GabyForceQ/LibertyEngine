module liberty.core.io.manager;

import std.stdio : File;

import liberty.core.logger.manager : Logger;
//import liberty.core.manager.meta : ManagerBody;
import liberty.core.utils : Singleton;

/**
 * Singleton class used for managing files and console input/output.
 * It's a manager class so it implements $(D ManagerBody).
**/
final class IOManager : Singleton!IOManager {

    //mixin(ManagerBody);

    /**
     *
    **/
    bool readFileToBuffer(string filePath, ref char[] buffer) {
        // Try to open and read file
        auto file = File(filePath, "r");
        scope (success) file.close();

        // Check file loaded successfully
        if (file.error()) {
            Logger.self.error("File couldn't be opened", typeof(this).stringof);
            return false;
        }
        
        // Get the file size
        ulong fileSize = file.size();

        // Reduce the file size by any header bytes that might be present
        fileSize -= file.tell();

        // Fill buffer
        buffer = file.rawRead(new char[fileSize]);

        return true;
    }

    /**
     *
    **/
    unittest {
        char[] buf;
        
        if(!IOManager.self.readFileToBuffer("test_file.txt", buf)) {
            assert(0, "Operation failed!");
        }

        assert(
            buf == "Hello,\r\nDear engine!" ||
            buf == "Hello,\nDear engine!", 
            "Buffer does not containt the same data as file"
        );
    }

    /**
     *
    **/
    //bool writeBufferToFile(char[] buffer, string filePath) {
        // todo
    //}

}