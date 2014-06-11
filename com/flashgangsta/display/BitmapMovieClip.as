package com.flashgangsta.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.05 (27.01.2014)
	 */
	
	public class BitmapMovieClip extends Sprite {
		
		private var bitmap:Bitmap = new Bitmap(null, PixelSnapping.NEVER);
		private var _totalFrames:int = 0;
		private var _currentFrame:int = 1;
		private var _isPlayed:Boolean = false;
		private var framesList:Vector.<BitmapMovieClipFrame>;
		
		
		/**
		 * 
		 * @param	movieClipClass
		 */
		
		public function BitmapMovieClip(framesList:Vector.<BitmapMovieClipFrame>) {
			this.framesList = framesList;
			_totalFrames = framesList.length;
			addChild(bitmap);
			showFrame();
			play();
		}
		
		/**
		 * 
		 */
		
		public function play():void {
			if (!_isPlayed) {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
				_isPlayed = true;
			}
		}
		
		/**
		 * 
		 */
		
		public function stop():void {
			if (_isPlayed) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_isPlayed = false;
			}
		}
		
		/**
		 * 
		 * @param	frame
		 */
		
		public function gotoAndPlay(frame:int):void {
			setFrame(frame);
			showFrame();
			play();
		}
		
		/**
		 * 
		 * @param	frame
		 */
		
		public function gotoAndStop(frame:int):void {
			setFrame(frame);
			showFrame();
			stop();
		}
		
		/**
		 * 
		 */
		
		public function nextFrame():void {
			setFrame(currentFrame + 1);
			showFrame();
		}
		
		/**
		 * 
		 */
		
		public function prevFrame():void {
			setFrame(currentFrame - 1);
			showFrame();
		}
		
		/**
		 * 
		 */
		
		public function get totalFrames():int {
			return _totalFrames;
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
		
		public function get isPlayed():Boolean {
			return _isPlayed;
		}
		
		/**
		 * 
		 */
		
		public function get smoothing():Boolean {
			return bitmap.smoothing;
		}
		
		public function set smoothing(value:Boolean):void {
			bitmap.smoothing = value;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			stop();
			framesList = null;
			bitmap.bitmapData.dispose();
			bitmap.bitmapData = null;
			bitmap = null;
		}
		
		/**
		 * 
		 */
		
		public function getCloneOfFrameBitmapData(frame:int = 1):BitmapData {
			return getCurrentFrame().bitmapData.clone();
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getCloneOfFrameBitmapDataWithFrameOptions():BitmapData {
			var frame:BitmapMovieClipFrame = getCurrentFrame();
			var frameBitmapData:BitmapData = frame.bitmapData;
			var result:BitmapData = new BitmapData(frameBitmapData.width + frame.x, frameBitmapData.height + frame.y, true, 0x00000000);
			result.merge(frameBitmapData, frameBitmapData.rect, new Point(frame.x, frame.y), 0xFF, 0xFF, 0xFF, 0xFF);
			return result;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getCurrentFrameBitmapData():BitmapData {
			return bitmap.bitmapData;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getCurrentFrameX():int {
			return getCurrentFrame().x;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getCurrentFrameY():int {
			return getCurrentFrame().y;
		}
		
		/**
		 * 
		 * @param	frame
		 */
		
		private function setFrame(frame:int):void {
			if (frame < 1) {
				frame = 1;
			} else if (frame > _totalFrames) {
				frame = _totalFrames;
			}
			
			_currentFrame = frame;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onEnterFrame(event:Event = null):void {
			_currentFrame = ++_currentFrame % totalFrames;
			setFrame(_currentFrame);
			showFrame();
		}
		
		/**
		 * 
		 */
		
		private function showFrame():void {
			var frameIndex:int = _currentFrame - 1;
			var frame:BitmapMovieClipFrame = framesList[frameIndex];
			bitmap.bitmapData = frame.bitmapData;
			bitmap.x = frame.x;
			bitmap.y = frame.y;
		}
		
		/**
		 * 
		 * @return
		 */
		
		private function getCurrentFrame():BitmapMovieClipFrame {
			return framesList[currentFrame - 1];
		}
	}
}