package com.flashgangsta.utils {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	
	/**
	 * @version 0.01
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	
	/**
	 * После того как картинка выбрана и загружена
	 * @eventType	flash.events.Event.COMPLETE
	 */
	
	[Event(name="complete", type="flash.events.Event")] 
	
	public class LocalImageLoader extends EventDispatcher {
		
		private var fileReference:FileReference = new FileReference();
		private var fileFiltersList:Array;
		private var bitmap:Bitmap;
		private var loader:Loader;
		
		/**
		 * Конструктор
		 * @param	fileFilters список фильтров файлов
		 */
		
		public function LocalImageLoader( fileFiltersList:Array ) {
			this.fileFiltersList = fileFiltersList;
		}
		
		/**
		 * Вызывает окно выбора файла
		 */
		
		public function browse():void {
			fileReference.browse( fileFiltersList );
			fileReference.addEventListener( Event.SELECT, onFileSelected );
			fileReference.addEventListener( Event.CANCEL, onFileSelectCaneled );
		}
		
		/**
		 * Возвращает битмэп
		 * @return
		 */
		
		public function getBitmap():Bitmap {
			return bitmap;
		}
		
		/**
		 * Убивает все ссылки после завершения работы
		 * @param	event
		 */
		
		public function destroy():void {
			bitmap = null;
			fileReference = null;
			loader = null;
		}
		
		/**
		 * Обработчик выбора файла
		 * @param	event
		 */
		
		private function onFileSelected( event:Event ):void {
			onFileSelectCaneled();
			fileReference.addEventListener( Event.COMPLETE, onFileLoaded );
			fileReference.load();
		}
		
		/**
		 * Обработчик отмены выбора файла
		 * @param	event
		 */
		
		private function onFileSelectCaneled( event:Event = null ):void {
			fileReference.removeEventListener( Event.SELECT, onFileSelected );
			fileReference.removeEventListener( Event.CANCEL, onFileSelectCaneled );
		}
		
		/**
		 * Данные файла загружены
		 * @param	event
		 */
		
		private function onFileLoaded( event:Event ):void {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onBitmapDataLoaded );
			loader.loadBytes( fileReference.data );
		}
		
		/**
		 * Изображение загружено
		 * @param	event
		 */
		
		private function onBitmapDataLoaded( event:Event ):void {
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onBitmapDataLoaded );
			bitmap = loader.content as Bitmap;
			loader = null;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
	}

}