package com.flashgangsta.utils {
	import flash.events.DataEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01	11/11/14
	 */
	public class Log {
		
		static private const log:Vector.<String> = new Vector.<String>();
		
		/**
		 * Log it is static class and cannot be instantiated.
		 * Use Log.write() and Log.get()
		 */
		
		public function Log() {
			throw new Error("Log it is static class and cannot be instantiated");
		}
		
		/**
		 * Write message to log
		 * @param	message
		 */
		
		static public function write(...messages:String):void {
			var message:String = "[" + new Date().toUTCString() + "]";
			
			if (messages is String) {
				message += " " + messages;
			} else if (messages is Array) {
				for each(var item:String in messages) {
					message += " " + item;
				}
			} else {
				message += " " + JSON.stringify(message);
			}
			
			log.push(message);
		}
		
		/**
		 * Return log from last to first writes.
		 * @param	writesNum number of last message for return, if value is 0 function will be retrun all writes.
		 * @return
		 */
		
		static public function get(writesNum:int = 0):Vector.<String> {
			return (new Vector.<String>()).concat(writesNum ? log.slice(log.length - writesNum) : log).reverse();
		}
		
	}
	
}