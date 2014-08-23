package com.flashgangsta.utils {
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 1.00 08/08/2014
	 */
	
	public function callMethodsInObjectsList(list:Object, methodName:String, ...args):void {
		var objcet:Object;
		for each(objcet in list) {
			(objcet[methodName] as Function).call(null, args);
		}
	}

}