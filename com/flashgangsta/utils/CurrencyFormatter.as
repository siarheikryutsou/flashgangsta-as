package com.flashgangsta.utils {
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.03 2014/11/27
	 * @link http://trigeminal.fmsinc.com/samples/setlocalesample2.asp
	 * 
	 * Lang codes from the ISO 639-1 list
	 */
	
	public class CurrencyFormatter {
		
		/// For example: $ 1,250.00 (Afrikaans)
		static public const LOCALE_AF:String = "af";
		/// For example: 1,250.00 $ (Arabic-Saudi Arabia, Arabic-Iraq, Algeria, Hebrew)
		static public const LOCALE_AR:String = "ar";
		/// For example: 1.250,00 $ (German-Germany, German-Austrian, German-Luxembourg, Greek, Portuguese-Standard, Romanian, Croatian, Serbian-Latin, Serbian-Cyrilic, Swedish, Turkish, Slovenian, Lithuanian, Vietnamese, Catalan, Spanish-International);
		static public const LOCALE_DE:String = "de";
		/// For example: $1,250.00 (Chinese-Traditional, Chinese-Simplified, English-US, English-UK, English-Australia, English-Canadian, English-Irish, Spanish-Mexico, Thai, Japanese, Korean)
		static public const LOCALE_EN:String = "en";
		/// For example: 1 250.00 $ (Estonian)
		static public const LOCALE_ET:String = "et";
		/// For example: 1,250/00 $ (Farsi)
		static public const LOCALE_FA:String = "fa";
		/// For example: 1 250,00 $ (Finnish, Bulgarian, Czech, French-France, French-Canadian, Hungarian, Polish, Belarusian)
		static public const LOCALE_FR:String = "fr";
		/// For example: $ 1.250,00 (Danish, Italian-Italy, Dutch-Netherlands, Portuguese-Brazil, Faeroese, Indonesian)
		static public const LOCALE_IT:String = "it";
		/// For example: $ 1 250,00 (Latvian, Norwegian)
		static public const LOCALE_NO:String = "no";
		/// For example: $ 1'250.00 (Romansh, French-Swiss, Italian-Swiss)
		static public const LOCALE_RM:String = "rm";
		/// For example: 1 250,00$ (Russian, Ukranian)
		static public const LOCALE_RU:String = "ru";
		
		private const defaultLocale:String = LOCALE_EN;
		///
		private const supportedLocales:Vector.<String> = new <String>["af","ar","be","bg","ca","cs","da","de","el","en","es","et","fa","fi","fo","fr","ga","he","hr","hu","id","it","ja","ko","lt","lv","nb","nl","nn","no","pl","pt","rm","ro","ru","sl","sr","sv","th","tr","uk","vi","zh","zh-CN","zh-TW"];
		
		///
		private var _localeID:String;
		private var ifNotSupportedUseLocale:String;
		private var decimalPlaces:int;
		private var currencySymbol:String;
		private var pricePattern:String;
		private var thousandSeparator:String;
		private var decimalSeparator:String;
		
		
		/**
		 * 
		 */
		
		public function CurrencyFormatter(localeID:String = CurrencyFormatter.LOCALE_EN, currencySymbol:String = null, decimalPlaces:int = 2, ifNotSupportedUseLocale:String = CurrencyFormatter.LOCALE_EN) {
			this.currencySymbol = currencySymbol;
			this.decimalPlaces = decimalPlaces;
			this.ifNotSupportedUseLocale = isSupportedLocale(ifNotSupportedUseLocale) ? getLocaleByLangCode(ifNotSupportedUseLocale) : defaultLocale;
			_localeID = isSupportedLocale(localeID) ? getLocaleByLangCode(localeID) : ifNotSupportedUseLocale;
			pricePattern = getPricePattern();
			applySeparators();
		}
		
		/**
		 * 
		 * @param	localeISOCode - by ISO 639-1 code
		 * @return
		 */
		
		public function isSupportedLocale(localeISOCode:String):Boolean {
			return supportedLocales.indexOf(localeISOCode) !== -1;
		}
		
		/**
		 * 
		 * @param	sum
		 * @param	withCurrencySymbol
		 * @return
		 */
		
		public function format(sum:Number, withCurrencySymbol:Boolean = true):String {
			var price:String = getFormattedPrice(sum);
			
			if (withCurrencySymbol && currencySymbol) {
				return pricePattern.replace("%price%", price).replace("%currencySymbol%", currencySymbol);
			} else {
				return price;
			}
		}
		
		/**
		 * 
		 * @param	price
		 * @return
		 */
		
		public function toNumber(price:String):Number {
			return parseFloat(price.split(currencySymbol).join("").split(thousandSeparator).join("").split(decimalSeparator).join("."));
		}
		
		/**
		 * 
		 * @return
		 */
		
		private function getLocaleByLangCode(localeID:String):String {
			switch(localeID.toLowerCase()) {
				case "af":
					return LOCALE_AF;
				case "ar":
				case "he":
					return LOCALE_AR;
				case "de":
				case "el":
				case "pt":
				case "ro":
				case "hr":
				case "sr":
				case "sv":
				case "tr":
				case "sl":
				case "lt":
				case "vi":
				case "ca":
				case "es":
					return LOCALE_DE;
				case "en":
				case "zh":
				case "zh-CN":
				case "zh-TW":
				case "ga":
				case "th":
				case "ja":
				case "ko":
					return LOCALE_EN;
				case "et":
					return LOCALE_ET;
				case "fa":
					return LOCALE_FA;
				case "fr":
				case "fi":
				case "bg":
				case "cs":
				case "hu":
				case "pl":
				case "be":
					return LOCALE_FR;
				case "it":
				case "da":
				case "nl":
				case "fo":
				case "id":
					return LOCALE_IT;
				case "no":
				case "nn":
				case "nb":
				case "lv":
					return LOCALE_NO;
				case "rm":
					return LOCALE_RM;
				case "ru":
				case "uk":
					return LOCALE_RU;
				default :
					return defaultLocale;
			}
		}
		
		/**
		 * 
		 * @param	sum
		 * @return
		 */
		
		private function getFormattedPrice(sum:Number):String {
			var numeric:String = sum.toFixed(decimalPlaces);
			var decimal:String = "";
			
			if(decimalPlaces) {
				decimal = numeric.substr(-1 - decimalPlaces);
				numeric = numeric.substr(0, numeric.length - 1 - decimalPlaces);
				decimal = decimal.split(".").join(decimalSeparator);
			}
			
			while (numeric.length > 3) {
				decimal = thousandSeparator + numeric.substr(-3) + decimal;
				numeric = numeric.substr(0, numeric.length - 3);
			}
			
			return numeric + decimal;
		}
		
		/**
		 * 
		 */
		
		private function getPricePattern():String {
			switch(_localeID) {
				case LOCALE_AF:
				case LOCALE_IT:
				case LOCALE_NO:
				case LOCALE_RM:
					return "%currencySymbol% %price%";
				case LOCALE_EN:
					return "%currencySymbol%%price%";
				case LOCALE_AR:
				case LOCALE_DE:
				case LOCALE_ET:
				case LOCALE_FA:
				case LOCALE_FR:
					return "%price% %currencySymbol%";
				case LOCALE_RU:
					return "%price%%currencySymbol%";
				default:
					return "%currencySymbol% %price%";
			}
		}
			
			/**
			 * 
			 */
			
		private function applySeparators():void {
			switch(_localeID) {
				case LOCALE_AF:
				case LOCALE_AR:
				case LOCALE_EN:
					thousandSeparator = ",";
					decimalSeparator = ".";
					break;
				case LOCALE_DE:
				case LOCALE_IT:
					thousandSeparator = ".";
					decimalSeparator = ",";
					break;
				case LOCALE_ET:
					thousandSeparator = " ";
					decimalSeparator = ".";
					break;
				case LOCALE_FR:
				case LOCALE_NO:
				case LOCALE_RU:
					thousandSeparator = " ";
					decimalSeparator = ",";
					break;
				case LOCALE_FA:
					thousandSeparator = ",";
					decimalSeparator = "/";
					break;
				case LOCALE_RM:
					thousandSeparator = "'";
					decimalSeparator = ".";
					break;
			}
		}
		
	}

}