package com.flashgangsta.utils {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01 29/07/2013
	 */
	public class MathUtil {
		
		public function MathUtil() {
			trace("MathUtil is a static class");
		}
		
		/**
		 * Equation of a Line from 2 Points (Уравнение прямой проходящей через 2 точки)
		 * @param	x1 start of 
		 * @param	x2
		 * @param	x3
		 * @param	y1
		 * @param	y2
		 * @param	y3
		 */
		
		static public function pointCoordinate(x1:Number, x2:Number, x3:Number, y1:Number, y2:Number, y3:Number):Number {
			var result:Number;
			
			if (isNaN(y3)) {
				if(x1 === x2) {
					y3 = (y1 + y2) / 2;
				} else {
					y3 = (x3 - x1) * (y1 - y2) / (x1 - x2) + y1;
				}
				result = y3;
			} else if (isNaN(x3)) {
				if (y1 === y2) {
					x3 = (x1 + x2) / 2;
				} else {
					x3 = (y3 - y1) * (x1 - x2) / (y1 - y2) + x1;
				}
				result = x3;
			}
			
			return result;
		}
		
	}

}