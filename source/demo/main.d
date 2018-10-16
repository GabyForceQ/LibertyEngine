/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/demo/main.d)
 * Documentation:
 * Coverage:
**/
module demo.main;

import liberty.engine;

import demo.config : setDemoCameraPreset;
import demo.player : Player;

mixin(EngineRun);

/**
 * Application main.
 * Create a new scene, then spawn a Player,
 * then register the scene to the engine.
**/
void libertyMain() {
  new Scene("Scene")
    .getTree()
    .spawn!Terrain("DemoTerrain")
    .build(40.0f, 0.0f, [
      new Material("res/textures/default.bmp"),
      new Material("res/textures/blendMap.bmp"),
      new Material("res/textures/default.bmp"),
      new Material("res/textures/default.bmp"),
      new Material("res/textures/default.bmp")
    ])
    .getScene()
    .getTree()
    .spawn!PointLight("DemoPointLight")
    .getScene()
    .getTree()
    .spawn!Player("Player", false)
    .getScene()
    .register();

  //setDemoCameraPreset();
}