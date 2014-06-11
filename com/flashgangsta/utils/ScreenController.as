package com.flashgangsta.utils {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01
	 */
	
	/**
	* Dispatched when screen changed
	*/
	[Event(name = "change", type = "flash.events.Event")]
	
	public class ScreenController extends Sprite {
		
		private var currentScreen:Sprite;
		private var history:Vector.<Class> = new Vector.<Class>();
		private var instncesList:Dictionary = new Dictionary();
		private var _width:int;
		private var _height:int;
		
		
		/**
		 * 
		 */
		
		public function ScreenController() {
			super.scaleX = super.scaleY = 1;
		}
		
		/**
		 * 
		 */
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width( value:Number ):void {
			_width = value;
		}
		
		/**
		 * 
		 */
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height( value:Number ):void {
			_height = value;
		}
		
		/**
		 * 
		 * @param	screenClass
		 * @return
		 */
		
		public function addScreen( screenClass:Class, createNewInstance:Boolean = false ):DisplayObject {
			removeScreen();
			
			if ( !createNewInstance && instncesList[ screenClass ] ) {
				currentScreen = instncesList[ screenClass ];
			} else {
				currentScreen = new screenClass();
				instncesList[ screenClass ] = currentScreen;
			}
			
			history.push( screenClass );
			addChild( currentScreen );
			dispatchEvent( new Event( Event.CHANGE ) );
			return currentScreen;
		}
		
		/**
		 * 
		 */
		
		public function back():DisplayObject {
			history.pop();
			return addScreen( history.pop(), false );
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getCurrentScreenInstance():DisplayObject {
			return currentScreen;
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getCurrentScreenClass():Class {
			return history[ history.length - 1 ];
		}
		
		/**
		 * 
		 */
		
		private function removeScreen():void {
			if ( !currentScreen ) return;
			removeChild( currentScreen );
		}
		
	}

}