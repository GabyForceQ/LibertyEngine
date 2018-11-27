# LibertyEngine
##### Description:
A powerful 2D/3D engine fully written in D programming language.
This is still work in progress. If you find a bug, please report on github.
There are so many features to come.

##### D compiler versions recommended:
* DMD 2.083.0

##### Operating systems supported (tested):
* Windows 10 x86 (32-bits)
* Windows 10 x64 (64-bits)

##### Graphics APIs supported (tested):
* OpenGL 4.5 (450 core) - Windows (Nvidia/AMD)
* OpenGL 3.0 (330 core) - Linux (Intel)

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
* Action mapping, input profiler, ligthing, cubemaps, physics, gui and more.

##### Demo examples
https://github.com/GabyForceQ/LibertyDemos

> *Please, do not use this framework in production as long as it is not officially released!*

![](images/world1.png?raw=true "World 1.")
![](images/world2.png?raw=true "World 2.")