# LibertyEngine
##### Description:
A powerful 2D/3D engine written in the D programming language!

##### Release notes (v0.0.15) (29-Oct-2018)
* Moved from SDL2 to GLFW
* Project structure is simpler
* More manager classes were added (no more singletons)
* BSP volumes and different kinds of model
* Texture caching using resource manager
* Terrain entity with collision, height map and multiple material support
* Core shader, terrain shader and UI shader were added
* Camera improvements and dynamic custom camera settings
* Dynamic material loader on BSP volumes
* (x) Skybox.
* (x) Day/night cycle.
* (x) Mouse picker.
* (x) Cell shading.
* Experimental .obj model loader
* Experimental flexible render pipline
* Experimental lighting system
* Experimental UI
* Fixes and small features
* This is still work in progress. If you find a bug, please report it on github.

##### D compiler versions recommended:
* DMD 2.082.1

##### Operating systems supported (tested):
* Windows 10 x86 (32-bits)
* Windows 10 x64 (64-bits)

##### Graphics APIs supported (tested):
* OpenGL 3.0 (Windows) <Shader: 330 core>

##### Cool features:
* Tree-based scene (every node is created and registered to the engine with "spawn" 
or "spawnOnce" templates, "new" is never used in this case).
* Every native script is optimized at compile time. So if you don't define "start" and 
"update" functions, the code for its every frame call is never inserted 
in the final object file.
* All "start" methods are invoked after all scene objects are instantiated. 
If you want to do something at construction time, you should use 'void constructor() {}'
* Smart, flexible and safe hierarchy for scenes, objects and components.

### Instructions:
* Coming in beta/release version

### Example:
```D
// Only in beta/release version
```

> *Please, do not use this framework in production as long as it is not officially released!*

![](screenshot.png?raw=true "Just a demo image!")