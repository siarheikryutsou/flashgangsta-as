package com.flashgangsta.media.video {
	import com.flashgangsta.events.MediaControllerEvent;
	import com.flashgangsta.events.MediaPlayingProgressEvent;
	import com.flashgangsta.events.MediaSeekEvent;
	import com.flashgangsta.events.YoutubePlayerEvent;
	import com.flashgangsta.managers.MappingManager;
	import com.flashgangsta.utils.Queue;
	import com.svyaznoy.PlayerControllBar;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @link https://developers.google.com/youtube/flash_api_reference?hl=ru
	 * @version 0.01
	 */
	
	public class YoutubePlayer extends Sprite {
		
		static private const PLAYER_URL:String = "http://www.youtube.com/apiplayer?version=3";
		static private const LOGO_RT_MARGIN:int = 8;
		static private const LOGO_WIDTH_MIN:int = 250;
		static private const LOGO_WIDTH_MAX:int = 480;
		static private const LOGO_HEIGHT_MIN:int = 180;
		static private const LOGO_HEIGHT_MAX:int = 360;
		static private const LOGO_WIDTH_DIFFERENCE:int = LOGO_WIDTH_MAX - LOGO_WIDTH_MIN;
		static private const LOGO_HEIGHT_DIFFERENCE:int = LOGO_HEIGHT_MAX - LOGO_HEIGHT_MIN;
		
		private var showTraces:Boolean = false;
		
		private var player:YoutubePlayerInstance;
		private var loader:Loader = new Loader();
		private var background:Shape;
		private var mouseListenerRect:Sprite = new Sprite();
		private var logo:Shape = new Shape();
		private var controllBar:PlayerControllBar;
		private var preloaderTimer:Timer = new Timer( 300 );
		private var playingTimer:Timer = new Timer( 500 );
		private var seekToAfterDetectionDuration:Number = 0;
		private var videoID:String;
		private var isReady:Boolean = false;
		private var queue:Queue = new Queue();
		private var maskObject:Shape = new Shape();
		
		/**
		 * 
		 */
		
		public function YoutubePlayer() {
			background = getChildAt( 0 ) as Shape;
			loader.contentLoaderInfo.addEventListener( Event.INIT, onPlayerInit );
			loader.load( new URLRequest( PLAYER_URL ), new LoaderContext( true ) );
			
			mouseListenerRect.visible = false;
			mouseListenerRect.addEventListener( MouseEvent.CLICK, onVideoClicked );
			
			logo.graphics.beginFill( 0 );
			logo.graphics.drawRect( 0, 0, 80, 31 );
			logo.graphics.endFill();
			logo.visible = false;
			
			setLogoRectSize();
			
			addChild( logo );
			
			controllBar = getChildByName( "controllBar_mc" ) as PlayerControllBar;
			controllBar.addEventListener( MediaControllerEvent.PLAY_OR_PAUSE_CLICKED, onPlayOrPauseClicked );
			controllBar.addEventListener( MediaSeekEvent.SEEK, onSeekerChanged );
			controllBar.addEventListener( MediaControllerEvent.MUTE_CLICKED, onMuteButtonClicked );
			controllBar.addEventListener( MediaControllerEvent.UNMUTE_CLICKED, onMuteButtonClicked );
			
			controllBar.disable();
			
			preloaderTimer.addEventListener( TimerEvent.TIMER, onPreloaderTimer );
			playingTimer.addEventListener( TimerEvent.TIMER, onPlayingTimer );
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			drawMask();
		}
		
		/**
		 * 
		 * @param	id
		 */
		
		public function setVideo( id:String, autoplay:Boolean = false ):void {
			videoID = id;
			if ( player ) {
				player.stopVideo();
				
				if( isReady ) {
					if( autoplay ) {
						player.loadVideoById( id );
					} else {
						player.cueVideoById( videoID );
					}
					player.setSize( width, height );
				} else {
					if ( !queue ) queue = new Queue();
					queue.add( setVideo, id, autoplay );
				}
			}
		}
		
		/**
		 * 
		 */
		
		public function stop():void {
			if ( player ) {
				player.stopVideo();
			}
			controllBar.disable();
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return background.width;
		}
		
		override public function set width( value:Number ):void {
			background.width = value;
			
			if ( width < LOGO_WIDTH_MAX && width > LOGO_WIDTH_MIN ) {
				var multipler:Number =  width / LOGO_WIDTH_DIFFERENCE;
				logo.width = Math.floor( 40 * multipler );
				
			}
			
			setLogoRectSize();
			
			if ( player ) player.setSize( width, height );
			
			drawMask();
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return background.height;
		}
		
		override public function set height(value:Number):void {
			background.height = value;
			
			if ( height < LOGO_HEIGHT_MAX && height > LOGO_HEIGHT_MIN ) {
				var multipler:Number = height / LOGO_HEIGHT_DIFFERENCE;
				logo.height = Math.floor( 15 * multipler );
			}
			
			setLogoRectSize();
			
			if ( player ) player.setSize( width, height );
			
			drawMask();
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			if ( player ) {
				if( player.hasEventListener( YoutubePlayerEvent.ON_READY ) ) {
					player.removeEventListener( YoutubePlayerEvent.ON_READY, onPlayerReady );
				}
				
				if( player.hasEventListener( YoutubePlayerEvent.ON_ERROR ) ) {
					player.removeEventListener( YoutubePlayerEvent.ON_ERROR, onPlayerError );
				}
				
				if( player.hasEventListener( YoutubePlayerEvent.ON_STATE_CHANGE ) ) {
					player.removeEventListener( YoutubePlayerEvent.ON_STATE_CHANGE, onPlayerStateChange );
				}
				
				if( player.hasEventListener( YoutubePlayerEvent.ON_PLAYBACK_QUALITY_CHANGE ) ) {
					player.removeEventListener( YoutubePlayerEvent.ON_PLAYBACK_QUALITY_CHANGE, onVideoPlaybackQualityChange );
				}
				player.stopVideo();
				player.destroy();
				player = null;
			}
			
			if ( loader ) {
				loader.contentLoaderInfo.removeEventListener( Event.INIT, onPlayerInit );
				loader.unloadAndStop();
			}
			
			if ( preloaderTimer && preloaderTimer.running ) {
				preloaderTimer.stop();
			}
			
			if ( playingTimer && playingTimer.running ) {
				playingTimer.stop();
			}
			
			if( controllBar.hasEventListener( MediaControllerEvent.PLAY_OR_PAUSE_CLICKED ) ) {
				controllBar.removeEventListener( MediaControllerEvent.PLAY_OR_PAUSE_CLICKED, onPlayOrPauseClicked );
			}
			
			if( controllBar.hasEventListener( MediaSeekEvent.SEEK ) ) {
				controllBar.removeEventListener( MediaSeekEvent.SEEK, onSeekerChanged );
			}
			
			if( controllBar.hasEventListener( MediaControllerEvent.MUTE_CLICKED ) ) {
				controllBar.removeEventListener( MediaControllerEvent.MUTE_CLICKED, onMuteButtonClicked );
			}
			
			if( controllBar.hasEventListener( MediaControllerEvent.UNMUTE_CLICKED ) ) {
				controllBar.removeEventListener( MediaControllerEvent.UNMUTE_CLICKED, onMuteButtonClicked );
			}
			
			if ( hasEventListener( Event.ADDED_TO_STAGE ) ) {
				removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			}
			
			if ( hasEventListener( Event.REMOVED_FROM_STAGE ) ) {
				removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			}
			
			loader = null;
			playingTimer = null;
			preloaderTimer = null;
		}
		
		/**
		 * 
		 */
		
		private function setLogoRectSize():void {
			logo.x = width - logo.width - LOGO_RT_MARGIN;
			logo.y = height - logo.height - LOGO_RT_MARGIN;
			logo.scaleX = logo.scaleY = Math.min( logo.scaleX, logo.scaleY );
			drawMouseListenerRect();
		}
		
		/**
		 * 
		 */
		
		private function drawMouseListenerRect():void {
			var graphics:Graphics = mouseListenerRect.graphics;
			graphics.clear();
			graphics.beginFill( 0, 0 );
			graphics.moveTo( 0, 0 );
			graphics.lineTo( width, 0 );
			graphics.lineTo( width, height );
			graphics.lineTo( width - LOGO_RT_MARGIN, height );
			graphics.lineTo( width - LOGO_RT_MARGIN, height - LOGO_RT_MARGIN - logo.height );
			graphics.lineTo( width - LOGO_RT_MARGIN - logo.width, height - LOGO_RT_MARGIN - logo.height );
			graphics.lineTo( width - LOGO_RT_MARGIN - logo.width, height - LOGO_RT_MARGIN );
			graphics.lineTo( width - LOGO_RT_MARGIN, height - LOGO_RT_MARGIN );
			graphics.lineTo( width - LOGO_RT_MARGIN, height );
			graphics.lineTo( 0, height );
			graphics.lineTo( 0, 0 );
			graphics.endFill();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayerInit( event:Event ):void {
			player = new YoutubePlayerInstance( loader.content );
			player.addEventListener( YoutubePlayerEvent.ON_READY, onPlayerReady );
			player.addEventListener( YoutubePlayerEvent.ON_ERROR, onPlayerError );
			player.addEventListener( YoutubePlayerEvent.ON_STATE_CHANGE, onPlayerStateChange );
			player.addEventListener( YoutubePlayerEvent.ON_PLAYBACK_QUALITY_CHANGE, onVideoPlaybackQualityChange );
			drawMask();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayerReady( event:Event ):void {
			isReady = true;
			// Event.data contains the event parameter, which is the Player API ID 
			if( showTraces ) trace( "Player is ready" );
			
			/*Once this event has been dispatched by the player, we can use
			cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			to load a particular YouTube video.*/
			
			player.removeEventListener( YoutubePlayerEvent.ON_READY, onPlayerReady );
			addChild( player.getPlayer() );
			addChild( logo );
			addChild( maskObject );
			
			player.setSize( background.width, background.height );
			
			if ( videoID ) {
				player.cueVideoById( videoID );
			}
			
			if ( queue ) queue.applyAll();
			
			addChild( controllBar );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayerError( event:Event ):void {
			// Event.data contains the event parameter, which is the error code
			var error:String = Object( event ).data;
			if( showTraces ) trace( "player error:", error );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayerStateChange( event:Event ):void {
			// Event.data contains the event parameter, which is the new player state
			var state:int = Object( event ).data;
			if( showTraces ) trace( "player state:", state );
			
			switch( state ) {
				case YoutubePlayerInstance.STATE_NOT_STARTED:
					reset();
				case YoutubePlayerInstance.STATE_READY:
					controllBar.enable();
					break;
				case YoutubePlayerInstance.STATE_PLAYING:
					if ( seekToAfterDetectionDuration ) {
						player.seekTo( player.getDuration() * seekToAfterDetectionDuration, true );
						seekToAfterDetectionDuration = 0;
					}
					
					if ( !mouseListenerRect.visible ) {
						mouseListenerRect.visible = true;
						addChildAt( mouseListenerRect, getChildIndex( player.getPlayer() ) + 1 );
					}
					
					controllBar.dispatchEvent( new MediaControllerEvent( MediaControllerEvent.PLAYING_STARTED ) );
					
					if ( !preloaderTimer.running ) {
						preloaderTimer.start();
					}
					
					playingTimer.start();
					break;
				case YoutubePlayerInstance.STATE_PLAYING_COMPLETED:
					controllBar.dispatchEvent( new MediaControllerEvent( MediaControllerEvent.PLAYING_COMPLETE ) );
					playingTimer.stop();
					break;
				case YoutubePlayerInstance.STATE_PAUSED:
					controllBar.dispatchEvent( new MediaControllerEvent( MediaControllerEvent.PLAYING_PAUSED ) );
					playingTimer.stop();
					break;
			}
		}
		
		/**
		 * 
		 */
		
		private function reset():void {
			if ( preloaderTimer.running ) {
				preloaderTimer.stop();
			}
			
			if ( playingTimer.running ) {
				playingTimer.stop();
			}
			
			if ( mouseListenerRect ) mouseListenerRect.visible = false;
			
			controllBar.reset();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onVideoPlaybackQualityChange( event:Event ):void {
			// Event.data contains the event parameter, which is the new video quality
			var quality:String = Object( event ).data;
			if( showTraces ) trace( "video quality:", quality );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onVideoClicked( event:MouseEvent ):void {
			togglePlaying();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayOrPauseClicked( event:MediaControllerEvent ):void {
			trace( "onPlayOrPauseClicked" );
			event.stopImmediatePropagation();
			togglePlaying();
		}
		
		/**
		 * 
		 */
		
		private function togglePlaying():void {
			switch( player.getPlayerState() ) {
				case YoutubePlayerInstance.STATE_PLAYING :
					player.pauseVideo();
					break;
				case YoutubePlayerInstance.STATE_PAUSED:
				case YoutubePlayerInstance.STATE_PLAYING_COMPLETED:
				case YoutubePlayerInstance.STATE_NOT_STARTED:
				case YoutubePlayerInstance.STATE_READY:
					player.playVideo();
					break;
				
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPreloaderTimer( event:TimerEvent ):void {
			var progress:Number = player.getVideoBytesLoaded() / player.getVideoBytesTotal();
			var progressEvent:ProgressEvent = new ProgressEvent( ProgressEvent.PROGRESS );
			progressEvent.bytesLoaded = player.getVideoBytesLoaded();
			progressEvent.bytesTotal = player.getVideoBytesTotal();
			controllBar.dispatchEvent( progressEvent );
			if ( progress === 1 ) preloaderTimer.stop();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlayingTimer( event:TimerEvent ):void {
			var mediaPlayingProgressEvent:MediaPlayingProgressEvent = new MediaPlayingProgressEvent( MediaPlayingProgressEvent.PROGRESS );
			mediaPlayingProgressEvent.currentTime = player.getCurrentTime();
			mediaPlayingProgressEvent.duration = player.getDuration();
			controllBar.dispatchEvent( mediaPlayingProgressEvent );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSeekerChanged( event:MediaSeekEvent ):void {
			var seekPrecent:Number = player.getDuration() * event.seekPrecent;
			
			if ( !player.getDuration() ) {
				seekToAfterDetectionDuration = event.seekPrecent;
				player.playVideo();
			}
			player.seekTo( seekPrecent, true );
			
			event.stopImmediatePropagation();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onMuteButtonClicked( event:MediaControllerEvent ):void {
			event.stopImmediatePropagation();
			if ( player.isMuted() ) {
				player.unMute();
			} else {
				player.mute();
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onAddedToStage( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage);
			if ( !hasEventListener( Event.REMOVED_FROM_STAGE ) ) {
				addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRemovedFromStage( event:Event ):void {
			removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
			if ( !hasEventListener( Event.ADDED_TO_STAGE ) ) {
				addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			}
			
			if ( player ) {
				player.stopVideo();
			}
		}
		
		/**
		 * 
		 */
		
		private function drawMask():void {
			if ( !player ) return;
			var graphics:Graphics = maskObject.graphics;
			graphics.clear();
			graphics.beginFill( 0xFF0000 );
			graphics.drawRect( 0, 0, background.width, background.height );
			graphics.endFill();
			addChild( maskObject );
			player.getPlayer().mask = maskObject;
		}
		
	}

}