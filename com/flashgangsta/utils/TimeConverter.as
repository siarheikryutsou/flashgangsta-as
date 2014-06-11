/*
 * TimeConverter
 * Utility to convert and display seconds in time format.
 *
 * @author		Sergei Krivtsov
 * @version		1.00.03
 * @e-mail		flashgangsta@gmail.com
 *
*/


package com.flashgangsta.utils {
	
	public class TimeConverter {

		public function TimeConverter() {
			throw new Error( "TimeConverter has static class" );
		}
		
		public static const H_MM_SS:String = "a";
		public static const HH_MM_SS:String = "b";
		public static const M_SS:String = "c";
		public static const MM_SS:String = "d";
		public static const H_MM:String = "e";
		
		/**
		 * Преобразует секунды во время
		 * @param	seconds
		 * @param	format
		 * @param	separator
		 * @return
		 */
		
		public static function getTime( seconds:int, format:String = TimeConverter.MM_SS, separator:String = ":" ):String {
			var result:String;
			
			switch( format ) {
				case TimeConverter.M_SS : {
					result = TimeConverter.convertMinutes( seconds, false ) + separator + TimeConverter.convertSeconds( seconds );
					break;
				}
				
				case TimeConverter.MM_SS : {
					result = TimeConverter.convertMinutes( seconds, false, true ) + separator + TimeConverter.convertSeconds( seconds );
					break;
				}
				case TimeConverter.H_MM : {
					result = TimeConverter.convertHours( seconds, false, true ) + separator + TimeConverter.convertMinutes( seconds, true );
					break;
				}
				case TimeConverter.HH_MM_SS : {
					result = TimeConverter.convertHours( seconds, false, true ) + separator + TimeConverter.convertMinutes( seconds, true ) + separator + TimeConverter.convertSeconds( seconds );
					break;
				}
				case TimeConverter.H_MM_SS : {
					result = TimeConverter.convertHours( seconds, false ) + separator + TimeConverter.convertMinutes( seconds, true ) + separator + TimeConverter.convertSeconds( seconds );
					break;
				}
				default : {
					throw new Error( "Undefined value of property format in TimeConverter.getTime method." );
				}
			}
			
			return result;
			
		}
		
		/**
		 * Преобразует дату во времяы
		 * @param	date
		 * @param	format
		 * @param	separator
		 * @return
		 */
		
		public static function getTimeByDate( date:Date, format:String = TimeConverter.H_MM, separator:String = ":" ):String {
			var result:String;
			switch( format ) {
				case H_MM : {
					result = date.getHours() + separator + toTwoDigitNumber( date.getMinutes() );
					break;
				}
			}
			return result;
		}
		
		/**
		 * Возвращает число в двузначином формате добавляя 0 ели число меньше десяти
		 */
		
		public static function toTwoDigitNumber( number:int ):String {
			return number < 10 ? "0" + number : number.toString();
		}
		
		private static function convertHours( seconds:Number, crop:Boolean = false, addNull:Boolean = false ):String {
			var hours:Number = Math.floor( seconds / 3600 );
			if( crop ) hours = hours % 60;
			return String( addNull ? toTwoDigitNumber( hours ) : hours );
		}
		
		
		private static function convertMinutes( seconds:Number, crop:Boolean = false, addNull:Boolean = false ):String {
			var minutes:Number = Math.floor( seconds / 60 );
			if( crop ) minutes = minutes % 60;
			return String( addNull ? toTwoDigitNumber( minutes ) : minutes );
		}
		
		
		private static function convertSeconds( seconds:Number ):String {
			var _seconds:Number = seconds % 60;
			return toTwoDigitNumber( _seconds );
		}
		
	}
	
}
