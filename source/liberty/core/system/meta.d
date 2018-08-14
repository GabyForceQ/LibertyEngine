module liberty.core.system.meta;

version (unittest) {

    /**
     *
    **/
    immutable EngineRun = q{};

} else {

    /**
     *
    **/
    immutable EngineRun = q{
        int main() {
            CoreEngine.self.startService();
            CoreEngine.self.run();
            
            return 0;
        }
    };

}