package com.flashgangsta.starling.utils {
	import com.flashgangsta.starling.display.Animation;
	import com.flashgangsta.starling.display.AnimationFrameModel;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class StarlingMovieClipConverter {
		
		/**
		 * 
		 */
		
		public function StarlingMovieClipConverter() {
			
		}
		
		/**
		 * 
		 * @param	movieClip
		 * @param	frameRate
		 * @return
		 */
		
		static public function getAnimationFromMovieClip(movieClip:MovieClip, frameRate:int = 60):Animation {
			return new Animation(getFrameModelsListByMovieClip(movieClip), frameRate);
		}
		
		/**
		 * 
		 * @return
		 */
		
		static public function getFrameModelsListByMovieClip(movieClip:MovieClip):Vector.<AnimationFrameModel> {
			var result:Vector.<AnimationFrameModel> = new Vector.<AnimationFrameModel>();
			var frame:AnimationFrameModel;
			var frameBitmapData:BitmapData;
			var frameBounds:Rectangle;
			var matrix:Matrix;
			
			for (var frameNum:int = 1; frameNum <= movieClip.totalFrames; frameNum++) {
				movieClip.gotoAndStop(frameNum);
				frameBounds = movieClip.getBounds(movieClip);
				frameBounds.x = Math.floor(frameBounds.x);
				frameBounds.y = Math.floor(frameBounds.y);
				frameBounds.width = Math.ceil(frameBounds.width);
				frameBounds.height = Math.ceil(frameBounds.height);
				matrix = new Matrix();
				matrix.identity();
				matrix.translate(Math.ceil(-frameBounds.x + 1), Math.ceil(-frameBounds.y + 1));
				frameBitmapData = new BitmapData(frameBounds.width, frameBounds.height, true, 0x00000000);
				frameBitmapData.lock();
				frameBitmapData.draw(movieClip, matrix);
				frameBitmapData.unlock();
				frame = new AnimationFrameModel(frameBitmapData, frameBounds.x, frameBounds.y);
				result.push(frame);
			}
			
			return result;
		}
		
	}
	
}