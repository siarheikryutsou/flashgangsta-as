package com.flashgangsta.media.controls {
	import com.flashgangsta.events.MediaControllerEvent;
	import com.flashgangsta.managers.ButtonManager;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public dynamic class MuteButton extends MovieClip {
		
		static public const STATE_MUTE:String = "mute";
		static public const STATE_UNMUTE:String = "unmute";
		
		private var icon:MovieClip;
		
		/**
		 * 
		 */
		
		public function MuteButton() {
			icon = getChildByName( "icon_mc" ) as MovieClip;
			icon.gotoAndStop( STATE_UNMUTE );
			ButtonManager.addButton( this, null, onClick );
		}
		
		/**
		 * 
		 * @param	state
		 */
		
		public function setState( state:String = MuteButton.STATE_UNMUTE ):void {
			if ( state === STATE_MUTE || state === STATE_UNMUTE ) {
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
			if ( icon.currentFrameLabel === STATE_MUTE ) {
				icon.gotoAndStop( STATE_UNMUTE );
				eventType = MediaControllerEvent.UNMUTE_CLICKED;
			} else {
				icon.gotoAndStop( STATE_MUTE );
				eventType = MediaControllerEvent.MUTE_CLICKED;
			}
			
			dispatchEvent( new MediaControllerEvent( eventType, true ) );
		}
		
	}

}