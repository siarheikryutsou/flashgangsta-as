package com.flashgangsta.utils {
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
		
	public function executeAfrerFrame(stage:Stage, method:Function, ...args):void {
		stage.addEventListener(Event.ENTER_FRAME, function(event:Event):void {
			stage.removeEventListener(Event.ENTER_FRAME, arguments.callee);
			method.apply(null, args);
		});
	}

}