package com.flashgangsta.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class YoutubePlayerEvent extends Event {
		
		/// Вызывается при загрузке и инициализации проигрывателя, что означает его готовность к приему вызовов API.
		static public const ON_READY:String = "onReady";
		/// Это событие вызывается, если в проигрывателе произошла ошибка.
		static public const ON_ERROR:String = "onError";
		/// Это событие возникает при изменении состояния проигрывателя.
		static public const ON_STATE_CHANGE:String = "onStateChange";
		/// Это событие возникает при изменении качества воспроизведения видео.
		static public const ON_PLAYBACK_QUALITY_CHANGE:String = "onPlaybackQualityChange";
		
		public function YoutubePlayerEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super( type, bubbles, cancelable );
		} 
		
		public override function clone():Event { 
			return new YoutubePlayerEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String { 
			return formatToString( "YoutubePlayerEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}