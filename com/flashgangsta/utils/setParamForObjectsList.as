package com.flashgangsta.utils {
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 1.00 08/08/2014
	 */
	
	public function setParamForObjectsList(list:Object, paramName:String, value:Object):void {
		for each(var object:Object in list) {
			object[paramName] = value;
		}
	}

}