/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.core.memory;
/// Use this macro at the begining of the function body to disable GC during the function execution.
/// It will be automatically enabled at the end of the function scope.
/// Do not use this macro if GC is globally disabled.
immutable scopeDisableGC = "import core.memory : GC; GC.disable; scope (exit) GC.enable;";
///
@safe unittest {
	void noGCFunction() {
		mixin(scopeDisableGC); // GC is disabled
		// Your code here...
		// GC is enabled
	}
}
/// It's recommended to use this call before releasing a resource in destructor.
/// Usually, it's used in debug configuration.
void ensureNotInGC(string resourceName) nothrow {
	import core.exception: InvalidMemoryOperationError;
	try {
		import core.memory: GC;
		cast(void)GC.malloc(1);
		return;
	} catch (InvalidMemoryOperationError e) {
		import core.stdc.stdio: fprintf, stderr;
		fprintf(stderr, "Error: clean-up of %s incorrectly depends on destructors called by the GC.\n", resourceName.ptr);
		assert(false);
	}
}