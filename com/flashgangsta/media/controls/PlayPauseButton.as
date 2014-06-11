package com.flashgangsta.media.controls {
	import com.flashgangsta.events.MediaControllerEvent;
	import com.flashgangsta.managers.ButtonManager;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class PlayPauseButton extends MovieClip {
		
		static public const STATE_PLAY:String = "play";
		static public const STATE_PAUSE:String = "pause";
		
		private var icon:MovieClip;
		
		/**
		 * 
		 */
		
		public function PlayPauseButton() {
			icon = getChildByName( "icon_mc" ) as MovieClip;
			icon.gotoAndStop( STATE_PLAY );
			ButtonManager.addButton( this, null, onClick );
		}
		
		/**
		 * 
		 * @param	state
		 */
		
		public function setState( state:String = PlayPauseButton.STATE_PLAY ):void {
			if ( state === STATE_PLAY || state === STATE_PAUSE ) {
				icon.gotoAndStop( state );
			} else {
				throw new Error( "Incorrect state:", state );
			}
		}
		
		/**
		 * 
		 * @param	target
		 */
		
		private function onClick( target:MovieClip ):void {
			var eventType:String;
			if ( icon.currentFrameLabel === STATE_PLAY ) {
				icon.gotoAndStop( STATE_PAUSE );
				eventType = MediaControllerEvent.PLAY_CLICKED;
			} else {
				icon.gotoAndStop( STATE_PLAY );
				eventType = MediaControllerEvent.PAUSE_CLICKED;
			}
			
			dispatchEvent( new MediaControllerEvent( eventType, true ) );
			dispatchEvent( new MediaControllerEvent( MediaControllerEvent.PLAY_OR_PAUSE_CLICKED, true ) );
		}
		
	}

}