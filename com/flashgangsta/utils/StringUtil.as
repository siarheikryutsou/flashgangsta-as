package com.flashgangsta.utils {
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.02 31/07/2014
	 */
	public class StringUtil {
		
		public function StringUtil() {
			
		}
		
		/**
		 * 
		 * @param	lenght string lenght. Default value is 1.
		 * @param	symbols for using. Default value is "abcdefghijklmnopqrstuvwzyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".
		 * @return
		 */
		
		public static function getRandomString( lenght:int = 1, symbols:String = "abcdefghijklmnopqrstuvwzyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" ):String {
			var result:String = "";
			for ( var i:Number = 0; i < lenght; i++ ) {
				result += symbols.charAt( Math.floor( Math.random() * symbols.length ) );
			}
			return result;
		}
		
		static public function getStringWithCapitalLetter(string:String):String {
			return string.substr(0, 1).toUpperCase() + string.substr(1).toLocaleLowerCase();
		}
		
	}

}