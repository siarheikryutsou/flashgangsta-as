package com.flashgangsta.display {
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01 (13.01.2014)
	 */
	
	public class BitmapMovieClipFrame {
		
		private var _bitmapData:BitmapData;
		private var _x:int;
		private var _y:int;
		
		/**
		 * 
		 * @param	bitmapData
		 * @param	x
		 * @param	y
		 */
		
		public function BitmapMovieClipFrame(bitmapData:BitmapData, x:int, y:int) {
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
		
		public function get x():int {
			return _x;
		}
		
		/**
		 * 
		 */
		
		public function get y():int {
			return _y;
		}
		
	}

}