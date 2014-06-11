package com.flashgangsta.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MediaPlayingProgressEvent extends Event {
		
		static public const PROGRESS:String = "mediaPlayingProgress";
		
		public var duration:Number;
		public var currentTime:Number;
		
		public function MediaPlayingProgressEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
		} 
		
		public override function clone():Event { 
			return new MediaPlayingProgressEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "MediaPlayingProgressEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}