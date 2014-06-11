package com.flashgangsta.display {
	import assets.Building01;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.02 (13.01.2014)
	 */
	
	public class BitmapMovieClipsCache {
		
		static private var instance:BitmapMovieClipsCache;
		
		private var framesListByClassName:Dictionary = new Dictionary();
		
		/**
		 * 
		 */
		
		public function BitmapMovieClipsCache() {
			if(!instance) {
				instance = this;
				init();
			} else {
				throw new Error("BitmapMovieClipsCache is singletone. Use static funtion getInstance() for get an instance of class");
			}
		}
		
		/**
		 * 
		 */
		
		static public function getInstance():BitmapMovieClipsCache {
			if(!instance) {
				instance = new BitmapMovieClipsCache();
			}
			return instance;
		}
		
		/**
		 * 
		 * @param	movieClipClass
		 * @return
		 */
		
		public function cache(movieClipClass:Class):void {
			if (framesListByClassName[movieClipClass]) {
				return;
			}
			
			var movieClip:MovieClip = new movieClipClass() as MovieClip;
			var totalFrames:int = movieClip.totalFrames;
			var frameRectangle:Rectangle;
			var frameBitmapData:BitmapData;
			var matrix:Matrix;
			var bitmapMovieClip:BitmapMovieClip;
			var bitmapMovieClipFrame:BitmapMovieClipFrame;
			var framesList:Vector.<BitmapMovieClipFrame> = new Vector.<BitmapMovieClipFrame>();
			
			for (var i:int = 1; i <= totalFrames; i++) {
				movieClip.gotoAndStop(i);
				
				frameRectangle = movieClip.getBounds(movieClip);
				frameRectangle.x = Math.floor(frameRectangle.x);
				frameRectangle.y = Math.floor(frameRectangle.y);
				
				matrix = new Matrix();
				matrix.identity();
				matrix.translate(Math.ceil(-frameRectangle.x + 1), Math.ceil(-frameRectangle.y + 1));
				//TODO: прикрепить скалирование matrix.scale(movieClip.scaleX, movieClip.scaleY);
				frameRectangle.width = Math.ceil(frameRectangle.width);
				frameRectangle.height = Math.ceil(frameRectangle.height);
				
				frameBitmapData = new BitmapData(int(frameRectangle.width), int(frameRectangle.height), true, 0x00000000);
				frameBitmapData.lock();
				frameBitmapData.draw(movieClip, matrix);
				frameBitmapData.unlock();
				
				bitmapMovieClipFrame = new BitmapMovieClipFrame(frameBitmapData, frameRectangle.x, frameRectangle.y);
				framesList.push(bitmapMovieClipFrame);
			}
			
			framesListByClassName[movieClipClass] = framesList;
		}
		
		/**
		 * 
		 * @param	movieClipClass
		 * @return
		 */
		
		public function getBitmapMovieClip(movieClipClass:Class):BitmapMovieClip {
			var framesList:Vector.<BitmapMovieClipFrame> = framesListByClassName[movieClipClass];
			
			if (!framesList) {
				cache(movieClipClass);
				framesList = framesListByClassName[movieClipClass];
			}
			
			return new BitmapMovieClip(framesList);
		}
		
		/**
		 * 
		 */
		
		private function init():void {
			
		}
		
	}
	
}