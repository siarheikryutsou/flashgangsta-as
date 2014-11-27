package com.flashgangsta.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 1.01 15/09/2014
	 */
	
	public function removeInteractive(targets:Array, removeTabEnabled:Boolean = true, excludeItems:Array = null):void {
		var i:int = 0;
		var j:int = 0;
		var totalTargets:int = targets.length;
		var target:DisplayObjectContainer;
		var currentTarget:DisplayObject;
		var textField:TextField;
		var displayObjectContainer:DisplayObjectContainer;
		var interactiveObject:InteractiveObject;
		var numChildren:int;
		
		for (i; i < totalTargets; i++) {
			target = targets[i];
			numChildren = target.numChildren;
			
			for (j; j < numChildren; j++) {
				currentTarget = target.getChildAt(j);
				
				if (excludeItems.indexOf(currentTarget) !== -1) {
					continue;
				}
				
				
				if (currentTarget is TextField) {
					textField = currentTarget as TextField;
					textField.mouseWheelEnabled = false;
					textField.mouseEnabled = false;
					textField.tabEnabled = !removeTabEnabled;
				} else if (currentTarget is DisplayObjectContainer) {
					displayObjectContainer = currentTarget as DisplayObjectContainer;
					displayObjectContainer.mouseEnabled = false;
					displayObjectContainer.mouseChildren = false;
					displayObjectContainer.tabChildren = displayObjectContainer.tabEnabled = !removeTabEnabled;
					removeInteractive([displayObjectContainer], removeTabEnabled, excludeItems);
				} else if (currentTarget is InteractiveObject) {
					interactiveObject = currentTarget as InteractiveObject;
					interactiveObject.mouseEnabled = false;
					interactiveObject.tabEnabled = !removeTabEnabled;
				}
			}
		}
		
		targets = null;
		excludeItems = null;
		target = null;
		currentTarget = null;
		textField = null;
		displayObjectContainer = null;
		interactiveObject = null;
	}

}