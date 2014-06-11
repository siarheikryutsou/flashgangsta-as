package com.flashgangsta.ui {
	import com.flashgangsta.utils.getChildByType;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01
	 */
	
	public class Label extends Sprite {
		
		private var label:TextField;
		
		/**
		 * 
		 */
		
		public function Label() {
			label = getChildByName( "label_txt" ) as TextField;
			if ( !label ) label = getChildByType( this, TextField ) as TextField;
			label.mouseEnabled = false;
			label.mouseWheelEnabled = false;
			label.autoSize = TextFieldAutoSize.LEFT;
			mouseEnabled = mouseChildren = false;
		}
		
		/**
		 * 
		 */
		
		public function get text():String {
			return label.text;
		}
		
		public function set text( value:String ):void {
			label.text = value;
		}
		
		public function get textField():TextField {
			return label;
		}
		
		/**
		 * 
		 */
		
		public function dispose():void {
			
		}
		
	}

}