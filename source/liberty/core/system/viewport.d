/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/viewport.d, _viewport.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.viewport;

import liberty.core.logger.manager : Logger;
import liberty.core.time.clock : Time;
import liberty.world.scene.impl : Scene;

/**
 * A viewport represents a render target or a particular world.
 * It stores references to its own scene.
 * It cannot have more than one scene.
**/
final class Viewport {
  private {
    string id;
    Scene scene;
  }

  /**
   * Construct an empty viewport with an id.
  **/
  this(string id) pure nothrow @safe {
    this.id = id;
  }

  /**
   * Returns the viewport id.
  **/
  string getId() pure nothrow const @safe {
    return this.id;
  }

  /**
   * Load a scene to be displayed in the viewport.
  **/
  void loadScene(Scene scene) pure nothrow @safe {
    this.scene = scene;
  }

  /**
   * Returns the current viewport scene.
  **/
  Scene getScene() pure nothrow @safe {
    return this.scene;
  }

  package void processTime() {
    // Process time
    Time.self.processTime();
  }

  package void update() {
    // Update the entire scene with its children if the scene exists.
    if (this.scene !is null) {
      this.scene.update(Time.self.getDelta());
    } else {
      Logger.self.warning(
        "You are updating an empty viewport.",
        typeof(this).stringof
      );
    }
  }
}