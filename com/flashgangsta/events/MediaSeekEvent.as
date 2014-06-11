package com.flashgangsta.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MediaSeekEvent extends Event {
		static public const SEEK:String = "seek";
		
		public var seekPrecent:Number;
		
		public function MediaSeekEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event { 
			return new MediaSeekEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "MediaSeekEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}