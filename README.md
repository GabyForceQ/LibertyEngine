# LibertyEngine
##### Description:
A powerful 2D/3D engine written in the D programming language.
This is still work in progress. If you find a bug, please report via github.
There are so many features to come.

##### Release notes (v0.0.15) (29-Oct-2018)
- [x] Moved from SDL2 to GLFW
- [x] Project structure is simpler
- [x] More manager classes were added (no more singletons)
- [x] BSP volumes and different kinds of model
- [x] Texture caching using resource manager
- [x] Terrain entity with collision, height map and multiple material support
- [x] Core shader, terrain shader and UI shader were added
- [x] Camera improvements and dynamic custom camera settings
- [x] Dynamic material loader on BSP volumes
- [x] Experimental .obj model loader
- [x] Experimental flexible render pipline
- [x] Experimental lighting system
- [x] Experimental UI
- [x] Experimental mouse picker
- [x] Fixes and small features
- [ ] Demos

##### D compiler versions recommended:
* DMD 2.082.1

##### Operating systems supported (tested):
* Windows 10 x86 (32-bits)
* Windows 10 x64 (64-bits)

##### Graphics APIs supported (tested):
* OpenGL 4.5 (450 core) - Windows

##### Cool features:
* Tree-based scene (every node is created and registered to the engine with "spawn" 
or "spawnOnce" templates, "new" is never used in this case).
* Every native script is optimized at compile time. So if you don't define "start" and 
"update" functions, the code for its every frame call is never inserted 
in the final object file.
* All "start" methods are invoked after all scene objects are instantiated. 
If you want to do something at construction time, you should use 'void constructor() {}'
* Smart, flexible and safe hierarchy for scenes, objects and components.

##### Demo examples
https://github.com/GabyForceQ/LibertyDemos

> *Please, do not use this framework in production as long as it is not officially released!*

![](images/terrain.png?raw=true "Multiple textured terrain.")