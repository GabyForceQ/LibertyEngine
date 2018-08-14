module liberty.mvc.services;

/**
 *
 */
interface IStartable {
	
	/**
	 *
	 */
	void start();

}

/**
 *
 */
interface IUpdatable {
	
	/**
	 *
	 */
	void update(in float deltaTime);

}

/**
 *
 */
interface IProcessable {
	
	/**
	 *
	 */
	void process();

}