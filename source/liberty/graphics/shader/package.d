/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/package.d, _package.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader;

public {
  import liberty.graphics.shader.builder;
  import liberty.graphics.shader.constants;
  import liberty.graphics.shader.opengl;
  import liberty.graphics.shader.root;
}

/*
Material material = new Material();

material.addNode("color");
material.addNode("time");

// Gate added (logic registered to the gate buffer on position 0)
// num is unknown
material.addGate(q{
    resultColor = color + vec4(
        1.0 * (cos(time + 0.0) + 1.0) * 0.5,
        1.0 * (cos(time + num) + 1.0) * 0.5,
        1.0 * (sin(time + 1.0) + 1.0) * 0.5,
        0.0
    );
});

// Now if we try to add another gate, it's on position 1
// We need to add the num declaration on position 0
material.moveGate(0, 1).fillEmptyGate(q{
    int num = 2.0;
});

addNode(string) -> material
removeNode(string) -> material
addGate(string) -> material
moveGate(uint, uint) -> material
fillEmptyGate(string) -> material
removeAllEmptyGates -> material
hasEmptyGates -> bool
compile -> bool
build -> bool
fixGateOrder -> bool
*/