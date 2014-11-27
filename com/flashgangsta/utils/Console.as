package com.flashgangsta.utils {
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01 13/06/2014
	 */
	
	public class Console {
		static public var outputToTrace:Boolean = true;
		static public var outputToConsole:Boolean = true;
		static public var outputToAlert:Boolean = false;
		
		/**
		 * 
		 */
		
		public function Console() {
			
		}
		
		/**
		 * 
		 * @param	outputToTrace
		 * @param	outputToConsole
		 * @param	outputToAlert
		 */
		
		static public function setup(outputToTrace:Boolean = true, outputToConsole:Boolean = true, outputToAlert:Boolean = false):void {
			Console.outputToAlert = outputToAlert;
			Console.outputToConsole = outputToConsole;
			Console.outputToTrace = outputToTrace;
			
		}
		
		/**
		 * 
		 * @param	...messages
		 */
		
		static public function log(...messages):void {
			var messageResult:String = String(messages).split(",").join(" ");
			
			if (outputToTrace) {
				trace(messageResult);
			}
			
			if (outputToConsole && ExternalInterface.available) {
				ExternalInterface.call("console.log", messageResult);
			}
			
			if (outputToAlert && ExternalInterface.available) {
				ExternalInterface.call("alert", messageResult);
			}
		}
		
	}

}