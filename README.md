# LibertyEngine
##### Description:
A powerful 2D/3D engine written in the D programming language!

##### D compiler versions recommended:
* DMD 2.081.2

##### Operating systems supported (tested):
* Windows 10 x86 (32-bits)
* Windows 10 x64 (64-bits)

##### Graphics APIs supported (tested):
* OpenGL 4.5 (Windows)

##### Cool features:
* Tree-based scene (every node is created and registered to the engine with "spawn" 
or "spawnOnce" templates, "new" is never used in this case).
* Every native script is optimized at compile time. So if you don't define "start", 
"update", "process" functions, the code for its every frame call is never inserted 
in the final object file.
* All "start" methods are invoked after all scene objects are instantiated. 
If you want to do something at construction time, you should use 'private static 
immutable constructor = q{ Your logic goes here! };'.
* Scenes, objects and components use Model-View-Controller (MVC) approach.

### Instructions:
* To build an example go to LibertyEngine\examples\Jumper and run the bat files.
* To run it, go to the bin/platform/executable.
* You need Visual C++ SDK for Windows 10 to build the x64 version.

### Example:
```D
module player;

import liberty.engine;

@Model
struct PlayerModel {
    mixin(Serialize);
    
    @Required
    int lives = 5;
}

@Controller
final class PlayerController : ActorController {
    enum thisName = typeof(this).stringof;

    mixin(BindModel);
    mixin(NodeBody);

    private static immutable constructor = q{
        Logger.self.info("Construction time!", thisName);
    };
    
    override void start() {
        spawn!Camera("Camera").setPosition(0.0f, 0.0f, 3.0f);
        scene.setActiveCamera(getChild!Camera("Camera"));
    }
    
    override void update(in float deltaTime) {
        Logger.self.info("Lives: " ~ model.lives.to!string, thisName);
    }
}
```

### Future plans:
* LibertyStudio with project templates
* Dynamic scripts
* VR/AR capabilities
* Multithreading systems
* Other platforms support including LDC Support
* Vulkan API Wrapper
* Real-Time Ray Tracing
* MySQL integration
* Web support

> *Do not use this framework in production until version 0.1 
(scheduled for Q2 2019) is released!*
