/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module crystal.core.logger;
///
class Logger {
	static:
	package void startService() {
    
    }
    package void releaseService() {
    
    }
    void restartServic() {
        releaseService();
        startService();
    }
    ///
    void safeLog(T...)(T args) {
    	synchronized {
            writeln(args);
        }
    }
}