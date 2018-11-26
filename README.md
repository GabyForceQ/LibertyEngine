# LibertyEngine
##### Description:
A powerful 2D/3D engine written in the D programming language.
This is still work in progress. If you find a bug, please report via github.
There are so many features to come.

##### D compiler versions recommended:
* DMD 2.083.0

##### Operating systems supported (tested):
* Windows 10 x86 (32-bits)
* Windows 10 x64 (64-bits)

##### Graphics APIs supported (tested):
* OpenGL 4.5 (450 core) - Windows

##### Release notes (v0.0.16)
- [x] BMP Decoder feature. Freeimage is not needed any more.
- [x] Close OS window when press x top-right button.
- [x] Properties zNear and zFar were added to camera.
- [x] Transform improvements and fixes.
- [x] Support for joystick was added.
- [x] Incorrect texture uvs on bsp volumes was fixed.
- [ ] Font manager was added.
- [x] Spawn and spawnOnce can capture lambda expression.
- [x] CubeMap was added.
- [x] Basic scene serializer/deserializer was implemented.
- [x] No more opengl errors for now.
- [x] UI Signals are more general.
- [x] Mouse enter/leave events were added.
- [x] Input profiler was added.
- Other bug fixes, user interface + metadata + documentation improvements and more unittests.

##### Cool features:
* Tree-based scene (every node is created and registered to the engine with "spawn" 
or "spawnOnce" templates, "new" is never used in this case).
* Every native script is optimized at compile time. So if you don't define "start" and 
"update" functions, the code for its every frame call is never inserted 
in the final object file.
* All "start" methods are invoked after all scene objects are instantiated. 
If you want to do something at construction time, you should use NodeConstructor.
For destruction time, you should use NodeDestructor.
* Smart, flexible and safe hierarchy for scenes, objects and components.

##### Demo examples
https://github.com/GabyForceQ/LibertyDemos

> *Please, do not use this framework in production as long as it is not officially released!*

![](images/world.png?raw=true "Multiple textured terrain.")