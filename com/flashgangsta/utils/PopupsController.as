package com.flashgangsta.utils {
	import caurina.transitions.Tweener;
	import com.flashgangsta.events.PopupsControllerEvent;
	import com.flashgangsta.managers.MappingManager;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.02
	 */
	
	public class PopupsController extends EventDispatcher {
		
		static private var instance:PopupsController;
		
		private var stage:Stage;
		private var blockRectColor:uint;
		private var blockRectAlpha:Number;
		private var blockRect:Sprite = new Sprite();
		private var blockRectMotionIn:Object = { alpha: 1, time: .4, transition: "easeOutCubic", onComplete: onBlockRectMotionComplete };
		private var blockRectMotionOut:Object = { alpha: 0, time: .4, transition: "easeInCubic" };
		private var popupMotionIn:Object = { alpha: 1, time: .5, transition: "easeOutExpo" };
		private var popupMotionOut:Object = { alpha: 0, time: .1, transition: "easeInCubic" };
		private var popup:DisplayObject;
		private var isLocked:Boolean = false;
		
		
		public function PopupsController() {
			if ( !instance ) instance = this;
			else throw new Error( "PopupController has singletone, use PopupControlle.getInstance()" );
		}
		
		/**
		 * 
		 * @return
		 */
		
		static public function getInstance():PopupsController {
			if ( !instance ) instance = new PopupsController();
			return instance;
		}
		
		/**
		 * 
		 * @param	stage
		 * @param	blockRectColor
		 * @param	blockRectAlpha
		 */
		
		public function init( stage:Stage, blockRectColor:uint = 0, blockRectAlpha:Number = .65 ):void {
			this.stage = stage;
			
			blockRect.alpha = 0;
			blockRect.mouseChildren = false;
			blockRect.mouseEnabled = false;
			blockRect.addEventListener( MouseEvent.CLICK, onBlockRectClicked );
			
			setBlockRect( blockRectColor, blockRectAlpha );
			
			
			stage.addEventListener( Event.RESIZE, onStageResize );
			
			///
			popupMotionOut.onComplete = function() {
				onPopupMotionOutComplete( this );
			}
		}
		
		/**
		 * 
		 * @param	blockRectColor
		 * @param	blockRectAlpha
		 */
		
		public function setBlockRect( blockRectColor:uint = 0, blockRectAlpha:Number = .65 ):void {
			this.blockRectAlpha = blockRectAlpha;
			this.blockRectColor = blockRectColor;
			drawBlockRect();
		}
		
		/**
		 * 
		 * @param	popup
		 * @param	isModal
		 */
		
		public function showPopup( popup:DisplayObject, isModal:Boolean = false ):DisplayObject {
			if ( isModal ) {
				stage.addChild( blockRect );
				if ( blockRect.alpha < 1 ) {
					Tweener.addTween( blockRect, blockRectMotionIn );
				} else {
					onBlockRectMotionComplete();
				}
				unlock();
			}
			
			this.popup = popup;	
			popup.alpha = 0;
			popup.y = 0;
			setPopupX();
			popupMotionIn.y = MappingManager.getCentricPoint( stage.stageHeight, popup.height );
			stage.addChild( popup );
			
			Tweener.addTween( popup, popupMotionIn );
			
			return popup;
		}
		
		/**
		 * 
		 */
		
		public function hidePopup():void {
			var event:PopupsControllerEvent = new PopupsControllerEvent( PopupsControllerEvent.CLOSING );
			
			if ( blockRect.parent ) {
				stage.removeChild( blockRect );
				blockRect.alpha = 0;
				blockRect.mouseChildren = false;
				blockRect.mouseEnabled = false;
			}
			
			Tweener.addTween( popup, popupMotionOut );
			
			popup.dispatchEvent( event );
			dispatchEvent( event );
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		public function getCurrentPopup():DisplayObject {
			return popup;
		}
		
		/**
		 * 
		 */
		
		public function lock():void {
			if ( popup is InteractiveObject ) { 
				InteractiveObject( popup ).mouseEnabled = false;
			}
			
			if ( popup is Sprite ) {
				Sprite( popup ).mouseChildren = false;
			}
			
			blockRect.mouseChildren = blockRect.mouseEnabled = false;
			
			isLocked = true;
		}
		
		/**
		 * 
		 */
		
		public function unlock():void {
			if ( popup is InteractiveObject ) { 
				InteractiveObject( popup ).mouseEnabled = true;
			}
			
			if ( popup is Sprite ) {
				Sprite( popup ).mouseChildren = true;
			}
			
			blockRect.mouseChildren = blockRect.mouseEnabled = true;
			
			isLocked = false;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onStageResize( event:Event ):void {
			blockRect.width = stage.stageWidth;
			blockRect.height = stage.stageHeight;
			if ( popup ) {
				setPopupX();
				if ( !Tweener.isTweening( popup ) && popup.alpha === 1 ) {
					popup.y = MappingManager.getCentricPoint( stage.stageHeight, popup.height );
				}
			}
		}
		
		/**
		 * 
		 */
		
		private function setPopupX():void {
			popup.x = MappingManager.getCentricPoint( stage.stageWidth, popup.width );
		}
		
		/**
		 * 
		 */
		
		private function drawBlockRect():void {
			var graphics:Graphics = blockRect.graphics;
			graphics.clear();
			
			graphics.beginFill( blockRectColor, blockRectAlpha );
			graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			graphics.endFill();
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onBlockRectClicked( event:MouseEvent ):void {
			hidePopup();
		}
		
		/**
		 * 
		 */
		
		private function onBlockRectMotionComplete():void {
			if ( blockRect.alpha === 1 ) {
				blockRect.alpha = 1;
				if( !isLocked ) blockRect.mouseChildren = blockRect.mouseEnabled = true;
			}
		}
		
		/**
		 * 
		 * @param	popup
		 */
		
		private function onPopupMotionOutComplete( popup:DisplayObject ):void {
			var event:PopupsControllerEvent = new PopupsControllerEvent( PopupsControllerEvent.CLOSED );
			event.popup = popup;
			stage.removeChild( popup );
			popup.dispatchEvent( event );
			dispatchEvent( event );
		}
		
	}

}