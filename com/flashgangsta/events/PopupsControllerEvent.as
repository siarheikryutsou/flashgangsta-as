package com.flashgangsta.events {
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PopupsControllerEvent extends Event {
		
		static public const CLOSING:String = "popupClosing";
		static public const CLOSED:String = "popupClosed";
		
		public var popup:DisplayObject;
		
		public function PopupsControllerEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );	
		} 
		
		public override function clone():Event { 
			return new PopupsControllerEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "PopupsControllerEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}