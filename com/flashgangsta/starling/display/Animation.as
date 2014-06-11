package com.flashgangsta.starling.display {
	import com.flashgangsta.starling.display.AnimationFrameModel;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Animation extends Sprite {
		private var frameRate:int;
		private var frameModels:Vector.<AnimationFrameModel>;
		private var _imagesList:Vector.<Image> = new Vector.<Image>();
		private var _currentFrame:int = 1;
		private var isPlayed:Boolean = false;
		private var enterFrameHandlerCounter:int = 0;
		private var frameRateDifference:Number;
		
		/**
		 * 
		 * @param	frames
		 * @param	frameRate
		 */
		
		public function Animation(frameModels:Vector.<AnimationFrameModel>, frameRate:int) {
			super();
			this.frameRate = frameRate;
			this.frameModels = frameModels;
			
			frameRateDifference = Math.round(Starling.current.nativeStage.frameRate / frameRate);
			
			if(frameModels) {
				init();
			}
		}
		
		/**
		 * 
		 */
		
		private function init():void {
			var frameModel:AnimationFrameModel;
			var image:Image;
			var texture:Texture;
			
			for (var i:int = 0; i < frameModels.length; i++) {
				frameModel = frameModels[i];
				texture = Texture.fromBitmapData(frameModel.bitmapData);
				image = new Image(texture);
				image.x = frameModel.x;
				image.y = frameModel.y;
				_imagesList.push(image);
			}
			
			gotoAndStop(1);
		}
		
		/**
		 * 
		 * @param	frame
		 */
		
		public function gotoAndPlay(frame:int):void {
			gotoAndStop(frame);
			play();
		}
		
		/**
		 * 
		 * @param	frame
		 */
		
		public function gotoAndStop(frame:int):void {
			showFrame(frame);
			stop();
		}
		
		/**
		 * 
		 */
		
		public function play():void {
			if (isPlayed) {
				return;
			}
			
			isPlayed = true;
			
			if (hasEventListener(EnterFrameEvent.ENTER_FRAME)) {
				removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler)
			}
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * 
		 */
		
		public function stop():void {
			if (hasEventListener(EnterFrameEvent.ENTER_FRAME)) {
				removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrameHandler);
			}
			isPlayed = false;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function clone():Animation {
			var result:Animation = new Animation(null, frameRate);
			result.imagesList = _imagesList;
			return result;
		}
		
		/**
		 * 
		 */
		
		public function get currentFrame():int {
			return _currentFrame;
		}
		
		/**
		 * 
		 */
		
		public function set imagesList(value:Vector.<Image>):void {
			var image:Image;
			var imageCopy:Image;
			var result:Vector.<Image> = new Vector.<Image>();
			
			for each(image in value) {
				imageCopy = new Image(image.texture);
				imageCopy.x = image.x;
				imageCopy.y = image.y;
				result.push(imageCopy);
			}
			
			_imagesList = result;
		}
		
		/**
		 * 
		 */
		
		public function get totalFrames():int {
			return _imagesList.length;
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			var image:Image;
			
			stop();
			
			for (var i:int = 0; i < totalFrames; i++) {
				image = _imagesList[i];
				image.texture.dispose();
				image.dispose();
			}
			
			super.dispose();
		}
		
		/**
		 * 
		 * @param	frame
		 */
		
		private function showFrame(frame:int):void {
			if (frame < 1) {
				frame = 1;
			} else if (frame > totalFrames) {
				frame = totalFrames;
			}
			removeChild(_imagesList[currentFrame - 1]);
			addChild(_imagesList[frame - 1]);
			_currentFrame = frame;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function enterFrameHandler(event:EnterFrameEvent = null):void {
			if (++enterFrameHandlerCounter < frameRateDifference) {
				return;
			}
			
			enterFrameHandlerCounter = 0;
			
			showFrame(currentFrame === totalFrames ? 1 : currentFrame + 1);
		}
		
	}

}