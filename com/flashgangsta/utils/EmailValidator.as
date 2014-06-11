/*
 * EmailValidator
 * Util for e-mail validation by .
 *
 * @author		Sergei Krivtsov
 * @version		1.00.00
 * @e-mail		flashgangsta@gmail.com
 *
*/

package com.flashgangsta.utils {
	
	public class EmailValidator {
		
		private static const EMAIL_REGEX:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
		
		public function EmailValidator() {
			throw new Error( "EmailValidator is a static class and should not be instantiated." );
		}
		
		public static function check( email:String ):Boolean {
			return( Boolean( email.match( EmailValidator.EMAIL_REGEX ) ) );			
		}
		
	}
	
}
