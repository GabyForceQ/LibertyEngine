module liberty.core.system.constants;

/**
 *
 */
enum EngineState : string {

    /**
     *
     */
    None = "None",

    /**
     *
     */
    Starting = "Starting",

    /**
     *
     */
    Started = "Started",

    /**
     *
     */
    Stopping = "Stopping",

    /**
     *
     */
    Stopped = "Stopped",

    /**
     *
     */
    Running = "Running",

    /**
     *
     */
    Paused = "Paused",

    /**
     *
     */
    ShouldQuit = "ShouldQuit"
}

/**
 *
 */
enum EngineAction : string {

    /**
     *
     */
    LoadingScene = "LoadingScene"

}

/**
*
*/
enum Owned : ubyte {

    /**
    *
    */
    No = 0x00,

    /**
    *
    */
    Yes = 0x01

}