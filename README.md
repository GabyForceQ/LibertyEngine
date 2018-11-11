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
- [x] BMP Decoder feature. Freeimage is not needed any more. (#46)
- [x] Close OS window when press x top-right button. (#42)
- [x] Properties zNear and zFar were added to camera. (#41)
- [x] Transform improvements and fixes. (#38)
- [ ] Support for joystick was added. (#44)
- [ ] Experimental particle effects. (#45)
- [ ] Incorrect texture uvs on bsp volumes was fixed. (#43)
- [ ] Now, you can rotate object on multiple axis the same time. (#40)
- [ ] Font manager was added. (#39)
- [ ] Method spawnOnce can now capture a method to initialize node in use. (#37)
- [ ] Day/night cycle feature. (#33)
- [ ] Skybox was added. (#30)
- [ ] Scene serializer/deserializer was added. (#12)
- [ ] Now, you can switch between perspective and orthographic cameras. (#9)
- [ ] Math has a new implementation. (#10)
- [ ] Now, you can load .obj models without any crashes. (#16)
- [ ] Crash during spawn calls is gone. (#27)
- Other bug fixes, documentation improvements and more unittests.

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