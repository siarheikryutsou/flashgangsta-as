package com.flashgangsta.utils {
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01 30/07/2014
	 */
	
	public class ArrayMixer extends Array {
		
		public function ArrayMixer() {
			
		}
		
		public static function mixArray(array:Array):Array {
			array.sort(sortHandler);
			return array;
		}
		
		public static function getMixedNumbersArray(from:Number, to:Number):Array {
			var array:Array = [];
			for (var i:Number = from; i <= to; i++) {
				array.push(i);
			}
			return mixArray(array);
		}
		
		static private function sortHandler(a:Number, b:Number):Number {
			var random:Number = Math.random();
			return (random < 0.33) ? -1 : (random < 0.66 ? 1 : 0);
		}
		
	}

}
