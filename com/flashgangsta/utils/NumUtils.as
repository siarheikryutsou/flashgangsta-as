package com.flashgangsta.utils {
	
	/**
	 * ...
	 * @author Sergey Krivtsov
	 * @version 1.00
	 */
	
	public class NumUtils {
		
		public function NumUtils() {
			
		}
		
		/**
		 * Конвертирует число в двузначную строку, добавляя ноль перед однозначным числом
		 * @param	value
		 * @return
		 */
		
		public static function toTwoDigit( value:int ):String {
			return value > 9 ? value.toString() : "0" + value;
		}
	}

}