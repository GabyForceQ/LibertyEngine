module liberty.mvc.components.material.controller;

@Component
class Material {

    this() {

    }

    Material addNode(string uniformName) {
        return this;
    }

    Material removeNode(string uniformName) {
        return this;
    }

    Material addGate(string codeBlock) {
        return this;
    }

    Material moveGate(uint fromLocation, uint toDestination) {
        return this;
    }

    /**
     * If there are multiple empty gates, first will be chosen.
     * The remaining ones will be deleted.
    **/
    Material fillEmptyGate(string codeBlock) {
        return this;
    }

    Material removeAllEmptyGates() {
        return this;
    }

    bool hasEmptyGates() {
        return false;
    }

    bool compile() {
        return true;
    }

    bool build() {
        return true;
    }

    bool fixGateOrder() {

        return compile();
    }

}