package com.flashgangsta.utils {
	
	/**
	 * ...
	 * @author Sergey Krivtsov
	 * @version 1.01 22/08/2014
	 */
	
	public class NumUtil {
		
		public function NumUtil() {
			
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