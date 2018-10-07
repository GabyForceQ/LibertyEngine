# LibertyEngine
##### Description:
A powerful 2D/3D engine written in the D programming language!

##### Release notes (v0.0.15) (To be released)
* Simpler project structure
* Added more manager classes: IOManager, ResourceManager..
* Cached textures
* Moved to GLFW
* More comments and bug fixes

##### D compiler versions recommended:
* DMD 2.082.0

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

> *Do not use this framework in production until version 0.1 is released!*
