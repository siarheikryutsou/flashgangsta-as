package com.flashgangsta.starling.display {
	import flash.display.BitmapData;
	import starling.display.Image;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class AnimationFrameModel {
		private var _bitmapData:BitmapData;
		private var _x:Number;
		private var _y:Number;
		private var image:Image;
		
		/**
		 * 
		 * @param	bitmapData
		 * @param	x
		 * @param	y
		 */
		
		public function AnimationFrameModel(bitmapData:BitmapData, x:int, y:int) {
			_y = y;
			_x = x;
			_bitmapData = bitmapData;
		}
		
		/**
		 * 
		 */
		
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		
		/**
		 * 
		 */
		
		public function get x():Number {
			return _x;
		}
		
		/**
		 * 
		 */
		
		public function get y():Number {
			return _y;
		}
		
	}

}