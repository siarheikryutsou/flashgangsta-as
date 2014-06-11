package com.flashgangsta.utils {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.02 07.01.2014
	 */
	
	public class UnitConverterUtil {
		
		/**
		 * 
		 */
		
		public function UnitConverterUtil() {
			
		}
		
		/**
		 * 
		 * @param	rgb
		 * @param	alpha
		 */
		
		static public function rgbToArgb(rgb:uint, alpha:uint = 0xFF):uint {
			return (alpha << 24) + rgb;
		}
		
	}

}