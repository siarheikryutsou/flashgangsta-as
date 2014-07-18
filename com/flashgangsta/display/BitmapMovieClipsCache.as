package com.flashgangsta.display {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.05 (18.07.2014)
	 */
	
	public class BitmapMovieClipsCache {
		
		static private var instance:BitmapMovieClipsCache;
		
		private var framesListByClassName:Dictionary = new Dictionary();
		private var trim:Boolean;
		
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
			var framesList:Vector.<BitmapMovieClipFrame> = generateFramesList(movieClip);
			
			framesListByClassName[movieClipClass] = framesList;
		}
		
		/**
		 * 
		 * @param	movieClipClass
		 * @return
		 */
		
		public function getBitmapMovieClip(movieClipClass:Class, trim:Boolean = true):BitmapMovieClip {
			this.trim = trim;
			var framesList:Vector.<BitmapMovieClipFrame> = framesListByClassName[movieClipClass];
			
			if (!framesList) {
				cache(movieClipClass);
				framesList = framesListByClassName[movieClipClass];
			}
			
			return new BitmapMovieClip(framesList);
		}
		
		/**
		 * 
		 * @param	movieClip
		 * @return
		 */
		
		public function getCachedCopyByMovieClip(movieClip:MovieClip, trim:Boolean = true):BitmapMovieClip {
			this.trim = trim;
			const framesList:Vector.<BitmapMovieClipFrame> = generateFramesList(movieClip);
			const result:BitmapMovieClip = new BitmapMovieClip(framesList);
			
			return result;
		}
		
		/**
		 * 
		 * @param	movieClip
		 */
		
		private function generateFramesList(movieClip:MovieClip):Vector.<BitmapMovieClipFrame> {
			const totalFrames:int = movieClip.totalFrames;
			var frameRectangle:Rectangle;
			var frameBitmapData:BitmapData;
			var matrix:Matrix;
			var bitmapMovieClipFrame:BitmapMovieClipFrame;
			var framesList:Vector.<BitmapMovieClipFrame> = new Vector.<BitmapMovieClipFrame>();
			
			for (var i:int = 1; i <= totalFrames; i++) {
				movieClip.gotoAndStop(i);
				
				frameRectangle = movieClip.getBounds(movieClip);
				frameRectangle.x = Math.floor(frameRectangle.x);
				frameRectangle.y = Math.floor(frameRectangle.y);
				
				if(trim) {
					matrix = new Matrix();
					matrix.identity();
					matrix.translate(Math.ceil( -frameRectangle.x + 1), Math.ceil( -frameRectangle.y + 1));
					//TODO: прикрепить скалирование matrix.scale(movieClip.scaleX, movieClip.scaleY);
					frameRectangle.width = Math.ceil(frameRectangle.width);
					frameRectangle.height = Math.ceil(frameRectangle.height);
				} else {
					frameRectangle.width = frameRectangle.x + Math.ceil(frameRectangle.width);
					frameRectangle.height = frameRectangle.y + Math.ceil(frameRectangle.height);
				}
				
				frameBitmapData = new BitmapData(int(frameRectangle.width), int(frameRectangle.height), true, 0x00000000);
				frameBitmapData.lock();
				frameBitmapData.draw(movieClip, matrix, null, null, null, true);
				frameBitmapData.unlock();
				
				bitmapMovieClipFrame = new BitmapMovieClipFrame(frameBitmapData, frameRectangle.x, frameRectangle.y);
				framesList.push(bitmapMovieClipFrame);
			}
			
			return framesList;
		}
		
		/**
		 * 
		 */
		
		private function init():void {
			
		}
		
	}
	
}