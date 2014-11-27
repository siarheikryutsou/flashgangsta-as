package com.flashgangsta.utils {
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 1.01 15/09/2014
	 */
	
	public function callMethodsInObjectsList(list:Object, methodName:String, ...args):void {
		var objcet:Object;
		for each(objcet in list) {
			(objcet[methodName] as Function).call(null, args);
		}
	}

}