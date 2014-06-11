package com.flashgangsta.net {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * Dispatched when the loading started
	 * @eventType	flash.events.Event.OPEN
	 */
	[Event(name = "open", type = "flash.events.Event")]
	
	/**
	 * Dispatched when the loading reported about loading progress
	 * @eventType	flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")] 
	
	/**
	 * Dispatched when the loading is complete
	 * @eventType	flash.events.ProgressEvent.COMPLETE
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * Dispatched an error occurred when loading
	 * @eventType	flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")] 
	
	/**
	 * Dispatched an security error occurred when loading
	 * @eventType	flash.events.SecurityErrorEvent
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")] 
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.04	07.08.2013
	 */
	
	public class ContentLoader extends EventDispatcher {
		
		static public var context:LoaderContext = null;
		
		///
		private var loader:Loader;
		///
		private var content:DisplayObject;
		///
		private var path:String;
		
		/**
		 * 
		 * @param	path
		 */
		
		public function ContentLoader() {
			
		}
		
		/**
		 * 
		 */
		
		public function load( path:String ):void {
			close();
			loader = new Loader();
			content = null;
			this.path = path;
			loader.contentLoaderInfo.addEventListener( Event.OPEN, onLoadStart );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onProgress );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaded );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			
			loader.load( new URLRequest( path ), ContentLoader.context );
		}
		
		/**
		 * Останавливает загрузку, удаляет слушатели и ссылки
		 */
		
		public function close():void {
			if ( !loader ) return;
			try {
				loader.close();
			} catch ( error:Error ) { };
			removeLoader();
		}
		
		/**
		 * Возвращает загруженный контент
		 * @return
		 */
		
		public function getContent():DisplayObject {
			return content;
		}
		
		/**
		 * 
		 */
		
		private function removeListeners():void {
			loader.contentLoaderInfo.removeEventListener( Event.OPEN, onLoadStart );
			loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onProgress );
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaded );
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoadStart( event:Event ):void {
			dispatchEvent( event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onProgress( event:ProgressEvent ):void {
			dispatchEvent( event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onLoaded( event:Event ):void {
			content = loader.content;
			removeLoader();
			dispatchEvent( event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onIOError( event:IOErrorEvent ):void {
			removeLoader();
			dispatchEvent( event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onSecurityError( event:SecurityErrorEvent ):void {
			removeLoader();
			dispatchEvent( event );
		}
		
		/**
		 * 
		 */
		
		private function removeLoader():void {
			removeListeners();
			loader = null;
		}
	}

}