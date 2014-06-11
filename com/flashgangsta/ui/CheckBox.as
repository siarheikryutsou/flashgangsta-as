package com.flashgangsta.ui {
	import com.flashgangsta.managers.ButtonManager;
	import com.flashgangsta.utils.getChildByType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Sergey Krivtsov
	 * @version 1.00.09
	 */
	
	
	/**
	 * Dispatched when a user change state of check box
	 * @eventType	flash.events.Event.CHANGED
	 */
	[Event(name="change", type="flash.events.Event")] 
	
	public class CheckBox extends MovieClip {
		
		private var icon:Icon;
		private var hit:Sprite;
		private var _id:String;
		private var label:Label;
		
		/**
		 * Constructor
		 */
		
		public function CheckBox() {
			icon = getChildByType( this, Icon ) as Icon;
			hit = getChildAt( numChildren - 1 ) as Sprite;
			label = getChildByType( this, Label ) as Label;
			
			icon.mouseEnabled = false;
			icon.mouseChildren = false;
			
			ButtonManager.addButton( this, null, onClick );
		}
		
		public function dispose():void {
			removeEventListener( Event.REMOVED_FROM_STAGE, removed );
			ButtonManager.removeButton( this );
			icon = null;
		}
		
		/**
		 * Обработка удаления объекта
		 * @param	event
		 */
		
		private function removed( event:Event ):void {
			dispose();
		}
		
		/**
		 * Устанавливает выделение для checkbox
		 */
		
		public function set selected( value:Boolean ):void {
			icon.visible = value;
		}
		
		/**
		 * Возвращает состояние выделения чекбокса
		 */
		
		public function get selected():Boolean {
			return icon.visible;
		}
		
		/**
		 * Возвращает состояние включенности чекбокса
		 */
		
		override public function get enabled():Boolean {
			return super.enabled;
		}
		
		/**
		 * Меняет состояние включенности чекбокса
		 */
		
		override public function set enabled( value:Boolean ):void {
			super.enabled = value;
			mouseEnabled = value;
			mouseChildren = value;
			alpha = value ? 1 : .5;
		}
		
		/**
		 * Устанавливает идентификатор
		 */
		
		public function set id( value:String ):void {
			_id = value;
		}
		
		/**
		 * Возвращает идентификатор
		 */
		
		public function get id():String {
			return _id;
		}
		
		/**
		 * 
		 */
		
		public function set value( value:String ):void {
			label.text = value;
			hit.height = label.height + label.y * 2;
		}
		
		public function get value():String {
			return label.text;
		}
		
		
		/**
		 * Обработка нажатия на чекбокс
		 * @param	target
		 */
		
		private function onClick( target:MovieClip ):void {
			selected = !selected;
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		
	}

}