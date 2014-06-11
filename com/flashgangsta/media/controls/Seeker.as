package com.flashgangsta.media.controls {
	import com.flashgangsta.events.MediaControllerEvent;
	import com.flashgangsta.events.MediaSeekEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Seeker extends Sprite {
		
		private var preloader:Sprite;
		private var progressbar:Sprite;
		private var seeker:Sprite;
		private var isDragged:Boolean = false;
		private var seekerCenter:Number;
		private var fullWidthForSeeker:Number;
		
		/**
		 * 
		 */
		
		public function Seeker() {
			
			preloader = getChildByName( "preloader_mc" ) as Sprite;
			progressbar = getChildByName( "progressbar_mc" ) as Sprite;
			seeker = getChildByName( "seeker_mc" ) as Sprite;
			
			preloader.mouseChildren = preloader.mouseEnabled = false;
			progressbar.mouseChildren = progressbar.mouseEnabled = false;
			
			seekerCenter = seeker.width / 2;
			fullWidthForSeeker = width - seeker.width;
			
			reset();
			
			seeker.buttonMode = true;
			
			addEventListener( MouseEvent.MOUSE_DOWN, onLinePressed );
		}
		
		/**
		 * 
		 */
		
		public function reset():void {
			preloader.width = 0;
			seeker.x = 0;
			progressbar.width = seekerCenter;
		}
		
		/**
		 * 
		 * @param	loaded
		 * @param	total
		 */
		
		public function setProgress( loaded:Number, total:Number ):void {
			var progress:Number = loaded / total;
			preloader.width = width * progress;
		}
		
		/**
		 * 
		 * @param	currentTime
		 * @param	duration
		 */
		
		public function setPlayingProgress( currentTime:Number, duration:Number ):void {
			if ( isDragged ) return;
			var progress:Number = currentTime / duration;
			seeker.x = Math.round( ( width - seeker.width ) * progress );
			progressbar.width = seeker.x + seekerCenter;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLinePressed( event:MouseEvent ):void {
			if ( event.target !== seeker ) {
				seeker.x = mouseX - seekerCenter;
				progressbar.width = seeker.x + seekerCenter;
			}
			onSeekerPressed();
		}
		
		/**
		 * 
		 */
		
		private function onSeekerPressed():void {
			isDragged = true;
			seeker.startDrag( false, new Rectangle( 0, seeker.y, fullWidthForSeeker, 0 ) );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseMove( event:MouseEvent ):void {
			progressbar.width = seeker.x + seekerCenter;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMouseUp( event:MouseEvent ):void {
			var seekEvent:MediaSeekEvent = new MediaSeekEvent( MediaSeekEvent.SEEK, true );
			seekEvent.seekPrecent = seeker.x / fullWidthForSeeker;
			stopDrag();
			stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			dispatchEvent( seekEvent );
			isDragged = false;
		}
		
	}

}