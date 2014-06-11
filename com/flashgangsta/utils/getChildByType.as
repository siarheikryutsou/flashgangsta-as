package com.flashgangsta.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 1.01
	 */
	
	public function getChildByType( targetContainer:DisplayObjectContainer, type:Class ):DisplayObject {
		var child:DisplayObject;
		var result:DisplayObject;
		for ( var i:int = 0; i < targetContainer.numChildren; i++ ) {
			child = targetContainer.getChildAt( i );
			if ( child is type ) {
				result = child;
				break;
			}
		}
		return result;
	}

}