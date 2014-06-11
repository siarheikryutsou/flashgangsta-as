/*
 * ButtonManager
 * Manager for quick and easy assignment of event handlers for the buttons.
 *
 * @author		Sergei Krivtsov
 * @version		1.00.95 (06.08.2013)
 * @e-mail		flashgangsta@gmail.com
 *
 *
 * class public methods:
 *
 *		@ addButton() method 	Добавляет кнопку, присваивает ей стандартное поведение:
 *
 *									ROLL_OVER		— проигрывает анимацию от текущего до предпоследнего кадра.
 *
 *									ROLL_OUT		— проигрывает анимацию от текущего до первого кадра.
 *
 *									MOUSE_DOWN		— перходит на последний кадр.
 *
 *									MOUSE_UP		— переходит на предпоследний кадр.
 *
 *								Ожидаемые параметры:
 * 
 * 									target			— слудует указывать обект, который будет являться кнопкой. (Обязательный параметр).
 *
 *									hit				— следует указывать объект MovieClip который будет являться фактической областью наведения кнопки, в случае его указания, кнопкой будет являться он,
 *													  а анимация будет проигрываться в обекте под параметром target. Создано это с для того, чтобы была возможность применять утилиту к объекту, не являющемуся
 * 													  MovieClip (Необязательный параметр).
 *									
 *									release			— функция которая выполнится по нажатию кнопки, и отпускании в её области. (Необязательный параметр).
 *									
 *									releaseoutside  — функция которая выполнится при нажатии на кнопку, и отпускании вне её области. (Необязательный параметр).
 *									
 *									press			— функция которая выполнится при нажатии на кнопку. (Необязательный параметр).
 *									
 *									over			— функция которая выполниться при наведении на кнопку. (Необязательный параметр).
 *									
 *									out				— функция которая выполнится при снятии курсора с кнопки, после его наведения. (Необязательный параметр).
 *									
 *									useHandCursor	— булева велечина, указываещее на надобность использования курсора в виде руки при наведении на кнопку. (Необязательный параметр, по умолчанию = true).
 *									
 *									
 *
 *		@ addButtonGroup() method
 *		@ addMouseChildrens() method
 *		@ callOutHandler() method
 *		@ callOverHandler() method
 *		@ callReleaseHandler() method
 *		@ getButtonEnable() method
 *		@ getCurrentState() method
 *		@ removeButton() method
 *		@ removeMouseChildrens() method
 *		@ setButtonEnable() method
 *		@ setButtonState() method
 *
 * class public constants:
 *
 *		@ STATE_NORMAL constant
 *		@ STATE_SELECTED constant
 *		@ STATE_PRESSED constant
 *		@ STATE_OVER constant
 *		@ STATE_OUT constant
 *
 *
*/

package com.flashgangsta.managers {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	public class ButtonManager {

		private static var trg:MovieClip;
		private static var currentState:String;
		private static var buttonGroups:Array = [];
		private static var buttonGroupID:Number = 0;
		private static var cursor:MovieClip;
		private static var mousePressed:Boolean = false;
		/// Текущая нажатая кнопка
		private static var nowPressedButton:MovieClip;
		
		private static const CURSOR_ARROW:String = "arrow";
		private static const CURSOR_BUTTON:String = "button";
		
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_SELECTED:String = "selected";
		public static const STATE_PRESSED:String = "pressed";
		public static const STATE_OVER:String = "over";
		public static const STATE_OUT:String = "out";
		
		/// Шаг в кадрах при 
		public static var EASED_MOTION_STEP:int = 5;
		
		// constructor
		
		public function ButtonManager() {
			throw new Error( "ButtonManager is a static class and should not be instantiated." );
		}
		
		public static function addButton( target:MovieClip, hit:MovieClip = null, release:Function = null, releaseoutside:Function = null, press:Function = null, over:Function = null, out:Function = null, useHandCursor:Boolean = true ):void {
			
			if( !target ) throw new Error( "ButtonManager.addButton() error:", "Button = null." );
			
			if( hit ) {
				hit.eventObject = hit;
				hit.eventObject.button = target;
				target = hit;
			} else {
				target.eventObject = target;
				target.eventObject.button = target;
			}
			
			ButtonManager.setButtonState( target, ButtonManager.STATE_NORMAL );
			
			if( target.lable_mc ) {
				ButtonManager.removeMouseChildrens( target.lable_mc );
			}
			
			if( target.lable_txt ) {
				ButtonManager.removeMouseChildrens( target.lable_txt );
			}
			
			if( target.label_mc ) {
				ButtonManager.removeMouseChildrens( target.label_mc );
			}
			
			if( target.label_txt ) {
				ButtonManager.removeMouseChildrens( target.label_txt );
			}
			
			//target.eventObject.isEasedButton = false;
			
			target.eventObject.overHandler = over;
			target.eventObject.outHandler = out;
			target.eventObject.pressHandler = press;
			target.eventObject.releaseoutsideHandler = releaseoutside;
			target.eventObject.releaseHandler = release;
			
			target.eventObject.buttonMode = useHandCursor;
			
			target.eventObject.addEventListener( MouseEvent.ROLL_OVER, isOver );
			target.eventObject.addEventListener( MouseEvent.ROLL_OUT, isOut );
			target.eventObject.addEventListener( MouseEvent.MOUSE_DOWN, isPress );
			target.eventObject.addEventListener( MouseEvent.MOUSE_UP, isRelease );
			
			currentState = ButtonManager.STATE_NORMAL;
		}
		
		/**
		 * 
		 * @param	target
		 * @param	hit
		 * @param	release
		 * @param	releaseoutside
		 * @param	press
		 * @param	over
		 * @param	out
		 * @param	useHandCursor
		 */
		
		public static function addEasedButton( target:MovieClip, hit:MovieClip = null, release:Function = null, releaseoutside:Function = null, press:Function = null, over:Function = null, out:Function = null, useHandCursor:Boolean = true ):void {
			target.isEasedButton = true;
			addButton( target, hit, release, releaseoutside, press, over, out, useHandCursor );
		}
		
		/**
		 * 
		 * @param	...buttons
		 */
		
		public static function removeButton( ...buttons ):void {
			
			for ( var i:int = 0; i < buttons.length; i++ ) {
				var target:MovieClip = buttons[ i ];
				
				if ( !target ) {
					throw new Error( "ButtonManager.removeButton() error: Button = null." );
				} else if ( target is MovieClip === false ) {
					throw new Error( "ButtonManager.removeButton() error: Button is not a MovieClip" ); 
				}
				
				target.buttonMode = false;
				target.removeEventListener( MouseEvent.ROLL_OVER, isOver );
				target.removeEventListener( MouseEvent.ROLL_OUT, isOut );
				target.removeEventListener( MouseEvent.MOUSE_DOWN, isPress );
				target.removeEventListener( MouseEvent.MOUSE_UP, isRelease );
				target.removeEventListener( Event.ENTER_FRAME, gotoOutState );
				target.removeEventListener( Event.ENTER_FRAME, gotoOverState );
				
				target.eventObject = null;
			}
			
		}
		
		public static function addButtonGroup( buttons:Array, eased:Boolean = false, selectedButton:MovieClip = null, alphed:Boolean = false, disableState:String = null, release:Function = null, releaseoutside:Function = null, press:Function = null, over:Function = null, out:Function = null, useHandCursor:Boolean = true ):void {
			
			if( disableState === null ) disableState = ButtonManager.STATE_SELECTED;
			
			ButtonManager.buttonGroups.push( { id: ButtonManager.buttonGroupID, buttons: buttons, alphed: alphed, disableState: disableState, selectedButton: selectedButton, selectionHistory: [] } );
			
			var button:MovieClip;
			
			for( var i:int = 0; i < buttons.length; i++ ) {
				button = buttons[ i ];
				if( !button ) throw new Error( "ButtonManager.addButtonGroup() error: Button #" + i + " = null." );
				button.groupID = ButtonManager.buttonGroupID;
				if( eased ) {
					ButtonManager.addEasedButton( buttons[ i ], null, release, releaseoutside, press, over, out, useHandCursor );
				} else {
					ButtonManager.addButton( buttons[ i ], null, release, releaseoutside, press, over, out, useHandCursor );
				}
				button.addEventListener( MouseEvent.CLICK, buttonGroupClicked );
			}
			
			if( selectedButton !== null ) {
				button = selectedButton;
				ButtonManager.buttonGroups[ ButtonManager.buttonGroups.length - 1 ].selectedButton = button;
				ButtonManager.setButtonEnable( button, false, alphed );
				ButtonManager.setButtonState( button, disableState );
				ButtonManager.buttonGroups[ ButtonManager.buttonGroups.length - 1 ].selectionHistory.push( selectedButton );
			}
			
			ButtonManager.buttonGroupID ++;
			
		}
		
		public static function getSelectedButtonOfGroup( onceButtonOfGroup:MovieClip ):MovieClip {
			var groupInfo:Object = getButtonInfo( onceButtonOfGroup.groupID );
			return groupInfo.selectedButton;
		}
		
		public static function getOldSelectedButton( onceButtonOfGroup:MovieClip ):MovieClip {
			var groupInfo:Object = getButtonInfo( onceButtonOfGroup.groupID );
			return groupInfo.oldSelectedButton;
		}
		
		/*
		*
		*	Меняет выделение группы
		*
		*/
		
		public static function setSelectionOnGroup( newSelectedButton:MovieClip ):void {
			var groupInfo:Object = getButtonInfo( newSelectedButton.groupID );
			var selectedButton:MovieClip = getSelectedButtonOfGroup( newSelectedButton );
			
			if( selectedButton ) {
				ButtonManager.setButtonEnable( selectedButton, true, groupInfo.alphed );
				ButtonManager.setButtonState( selectedButton, ButtonManager.STATE_NORMAL );
			}
				
			groupInfo.selectionHistory.push( newSelectedButton );
			
			ButtonManager.setButtonEnable( newSelectedButton, false, groupInfo.alphed );
			ButtonManager.setButtonState( newSelectedButton, groupInfo.disableState );
			
			groupInfo.selectedButton = newSelectedButton;
			groupInfo.oldSelectedButton = groupInfo.selectionHistory.length > 1 ? selectedButton : null;
			
			
		}
		
		
		/*
		*
		*	Сбрасывает выделение группы
		*
		*/
		
		
		public static function resetSelectionOnGroup( onceButtonOfGroup:MovieClip ):void {
			var groupInfo:Object = getButtonInfo( onceButtonOfGroup.groupID );
			
			if ( !groupInfo.selectedButton ) return;
			
			ButtonManager.setButtonEnable( groupInfo.selectedButton, true, true );
			ButtonManager.setButtonState( groupInfo.selectedButton, ButtonManager.STATE_NORMAL );
			
			groupInfo.oldSelectedButton = null;
			groupInfo.selectedButton = null;
			groupInfo.selectionHistory = [];
		}
		
		
		/**
		*
		*	Возвращает предыдущее состояние группе
		*
		*/
		
		
		public static function returnOldSelectionOfGroup( onceButtonOfGroup:MovieClip ):void {
			var groupInfo:Object = getButtonInfo( onceButtonOfGroup.groupID );
			var selectedButton:MovieClip = groupInfo.selectionHistory.pop();
			
			ButtonManager.setButtonEnable( selectedButton, true, groupInfo.alphed );
			ButtonManager.setButtonState( selectedButton, ButtonManager.STATE_NORMAL );
			
			selectedButton = groupInfo.selectionHistory[ groupInfo.selectionHistory.length - 1 ];
			
			if ( !selectedButton ) return;
			
			
			ButtonManager.setButtonEnable( selectedButton, false, groupInfo.alphed );
			ButtonManager.setButtonState( selectedButton, groupInfo.disableState );
			
			groupInfo.selectedButton = selectedButton;
			groupInfo.oldSelectedButton = groupInfo.selectionHistory.length > 1 ? groupInfo.selectionHistory[ groupInfo.selectionHistory.length - 2 ] : null;
			
		}
		
		
		/*
		*
		*	Удаляет группу кнопок
		*
		*/
		
		
		public static function removeButtonGroup( onceButtonOfGroup:MovieClip ):void {
			var groupInfo:Object = getButtonInfo( onceButtonOfGroup.groupID );
			for( var i:int = 0; i < groupInfo.buttons.length; i++ ) {
				var button:MovieClip = groupInfo.buttons[i];
				if( !button ) throw new Error( "ButtonManager.removeButtonGroup() error: Button #" + i + " = null." ); 
				ButtonManager.removeButton( button );
				button.removeEventListener( MouseEvent.CLICK, buttonGroupClicked );
				button.groupID = 0;
			}
			groupInfo.selectionHistory = [];
			groupInfo = null;
		}
		
		
		/**
		 * Включает/выключает кнопку
		 * @param	target
		 * @param	enabled
		 * @param	alphed
		 * @param	alphaValue
		 */
		
		public static function setButtonEnable( target:MovieClip, enabled:Boolean = true, alphed:Boolean = false, alphaValue:Number = .5 ):void {
			target.mouseChildren = enabled;
			target.mouseEnabled = enabled;
			
			if( alphed ) {
				target.alpha = enabled ? 1 : alphaValue;
			}
		}
		
		
		/*
		*
		*	Возвращает состояние включенности кнопки
		*
		*/
		
		
		public static function getButtonEnable( target:MovieClip ):Boolean {
			return target.mouseEnabled;
		}
		
		
		/*
		*
		*	Устанавливает состояние кнопки
		*
		*/
		
		
		public static function setButtonState( target:MovieClip, state:String ):void {
			switch( state ) {
				case ButtonManager.STATE_NORMAL : {
					target.button.gotoAndStop( 1 );
					currentState = ButtonManager.STATE_NORMAL;
					break;
				}
				case ButtonManager.STATE_SELECTED : {
					target.button.gotoAndStop( target.button.totalFrames - 1 );
					currentState = ButtonManager.STATE_SELECTED;
					break;
				}
				case ButtonManager.STATE_PRESSED : {
					target.button.gotoAndStop( target.button.totalFrames );
					currentState = ButtonManager.STATE_PRESSED;
					break;
				}
				case ButtonManager.STATE_OUT : {
					isOut( { currentTarget: target } );
					break;
				}
				case ButtonManager.STATE_OVER : {
					isOver( { currentTarget: target } );
					break;
				}
			}
		}
		
		
		/*
		*
		*	Вызывает обработчик наведения на кнопку
		*
		*/
		
		
		public static function callOverHandler( target:MovieClip ):void {
			target.dispatchEvent( new MouseEvent( MouseEvent.ROLL_OVER ) );
		}
		
		
		/*
		*
		*	Вызывает обработчик уведения мыши с кнопки
		*
		*/
		
		
		public static function callOutHandler( target:MovieClip ):void {
			target.dispatchEvent( new MouseEvent( MouseEvent.ROLL_OUT ) );
		}
		
		
		/*
		*
		*	Вызывает обработчик нажатия мыши на кнопке
		*
		*/
		
		
		public static function callPressHandler( target:MovieClip ):void {
			//if ( target.eventObject.pressHandler !== null ) target.eventObject.pressHandler( target );
			target.dispatchEvent( new MouseEvent( MouseEvent.MOUSE_DOWN ) );
		}
		
		
		/*
		*
		*	Вызывает обработчик нажатия мыши на кнопке, и отпускания её вне кнопки
		*
		*/
		
		
		public static function callReleaseHandler( target:MovieClip ):void {
			if( target.eventObject.releaseHandler !== null ) target.eventObject.releaseHandler( target );
		}
		
		
		/*
		*
		*	Возвращает текущее состояние кнопки
		*
		*/
		
		
		public static function getCurrentState( target:MovieClip ):String {
			return currentState;
		}
		
		
		public static function addMouseChildrens( target:Object ):void {
			target.mouseChildren = true;
			target.mouseEnabled = true;
			target.buttonMode = true;
		}
		
		/**
		 * 
		 * @param	target
		 */
		
		public static function removeMouseChildrens( target:Object ):void  {
			if ( target is TextField ) {
				target.mouseWheelEnabled = false;
			} else {
				target.mouseChildren = false;
				target.buttonMode = false;
			}
			target.mouseEnabled = false;
		}
		
		
		/*
		 * 
		 * Возрвращает, является ли объект кнопкой
		 * 
		 */
		
		public static function isButton( object:Object ):Boolean {
			return object.eventObject ? true : false;
		}
		
		/*
		 * 
		 * Добавляет катомный курсор мыши
		 * 
		 */
		
		public static function addCustomMouseCursor( container:DisplayObjectContainer, cursorLink:Class, stageLink:Stage ):void {
			Mouse.hide();
			container.mouseChildren = false;
			container.mouseEnabled = false;
			cursor = new cursorLink();
			cursor.gotoAndStop( CURSOR_ARROW );
			cursor.x = stageLink.mouseX;
			cursor.y = stageLink.mouseY;
			container.addChild( cursor );
			stageLink.addEventListener( MouseEvent.MOUSE_MOVE, ButtonManager.moveCursor );
			stageLink.addEventListener( Event.MOUSE_LEAVE, ButtonManager.onMouseLeave );
		}
		
		/**
		 * Возвращает текущую нажатую кнопку
		 * @param	event
		 */
		
		public static function getNowPressedButton():MovieClip {
			return nowPressedButton;
		}
		
		
		private static function isOver( event:Object ):void {
			
			if ( mousePressed ) return;
			
			var scope:MovieClip = event.currentTarget.eventObject;
			scope.removeEventListener( Event.ENTER_FRAME, gotoOutState );
			
			if ( ButtonManager.cursor ) {
				cursor.gotoAndStop( CURSOR_BUTTON );
			}
			
			if( event.currentTarget.mouseIsDown ) {
				return;
			}
			
			scope.addEventListener( Event.ENTER_FRAME, gotoOverState );
			
			currentState = ButtonManager.STATE_OVER;
			
			if( event.currentTarget.overHandler !== null ) {
				event.currentTarget.overHandler( scope.button );
			}
		}
		
		private static function isOut( event:Object ):void {
			var scope:MovieClip = event.currentTarget.eventObject;
			scope.removeEventListener( Event.ENTER_FRAME, gotoOverState );
			
			if( event.currentTarget.mouseIsDown || !event.currentTarget.eventObject.mouseEnabled ) {
				return;
			}
			
			if ( ButtonManager.cursor && !mousePressed ) {
				cursor.gotoAndStop( CURSOR_ARROW );
			}
			
			scope.addEventListener( Event.ENTER_FRAME, gotoOutState );
			
			currentState = ButtonManager.STATE_OUT;
			
			if( event.currentTarget.outHandler !== null && event is MouseEvent ) {
				event.currentTarget.outHandler( scope.button );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private static function isPress( event:MouseEvent ):void {
			mousePressed = true;
			
			if ( ButtonManager.cursor) {
				cursor.gotoAndStop( CURSOR_BUTTON );
			}
			
			var scope:MovieClip = event.currentTarget.eventObject;
			trg = scope;
			scope.parent.stage.addEventListener( MouseEvent.MOUSE_UP, isRelease );
			
			event.currentTarget.mouseIsDown = true;
			
			currentState = ButtonManager.STATE_PRESSED;
			
			scope.button.gotoAndStop( scope.button.totalFrames );
			
			if( event.currentTarget.pressHandler !== null ) { 
				event.currentTarget.pressHandler( scope.button );
			}
			
			nowPressedButton = scope;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private static function isReleaseoutside( event:Object ):void {
			
			mousePressed = false;
			
			var scope:MovieClip = event.currentTarget.eventObject;
			isOut( { currentTarget: event.currentTarget } );
			
			if( event.currentTarget.releaseoutsideHandler !== null ) {
				event.currentTarget.releaseoutsideHandler( scope.button );
			}
			
			nowPressedButton = null;
			
		} 
		
		private static function isRelease( event:MouseEvent ):void {
			
			mousePressed = false;
			nowPressedButton = null;
			
			if ( !trg ) return;
			
			trg.parent.stage.removeEventListener( MouseEvent.MOUSE_UP, isRelease );
			
			trg.mouseIsDown = false;
			
			if( trg === event.currentTarget ) {
				var scope:MovieClip = event.currentTarget.eventObject;
				scope.button.prevFrame();
				if( event.currentTarget.releaseHandler !== null ) {
					event.currentTarget.releaseHandler( scope.button );
				}
			} else {
				if( isReleaseoutside !== null ) {
					isReleaseoutside( { currentTarget: trg } );
				}
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private static function gotoOverState( event:Event ):void {
			var scope:MovieClip = event.currentTarget.eventObject;
			if( scope.button.currentFrame !== scope.button.totalFrames - 1 ) {
				if( scope.isEasedButton ) {
					if( scope.button.currentFrame + EASED_MOTION_STEP < scope.button.totalFrames ) {
						scope.button.gotoAndStop( scope.button.currentFrame + EASED_MOTION_STEP );
					} else {
						scope.button.gotoAndStop( scope.button.totalFrames - 1 );
					}
				} else {
					scope.button.nextFrame();
				}
			} else {
				scope.removeEventListener( Event.ENTER_FRAME, gotoOverState );
			}
		}
		
		private static function gotoOutState( event:Event ):void {
			var scope:MovieClip = event.currentTarget.eventObject;
			if( scope.button.currentFrame !== 1 ) {
				scope.button.prevFrame();
			} else {
				scope.removeEventListener( Event.ENTER_FRAME, gotoOutState );
				currentState = ButtonManager.STATE_NORMAL;
			}
		}
		
		private static function buttonGroupClicked( event:Event ):void {
			var groupInfo:Object = ButtonManager.getButtonInfo( event.currentTarget.groupID );
			
			if ( ButtonManager.cursor ) {
				cursor.gotoAndStop( CURSOR_ARROW );
			}
			
			if( groupInfo.selectedButton ) {
				ButtonManager.setButtonEnable( groupInfo.selectedButton, true, groupInfo.alphed );
				ButtonManager.setButtonState( groupInfo.selectedButton, ButtonManager.STATE_NORMAL );
			}
			
			groupInfo.oldSelectedButton = groupInfo.selectedButton;
			groupInfo.selectedButton = event.currentTarget;
			groupInfo.selectionHistory.push( groupInfo.selectedButton );
			ButtonManager.setButtonEnable( groupInfo.selectedButton, false, groupInfo.alphed );
			ButtonManager.setButtonState( groupInfo.selectedButton, groupInfo.disableState );
			
		}
		
		private static function getButtonInfo( id:Number ):Object {
			for( var i:Number = 0; i < ButtonManager.buttonGroups.length; i++ ) {
				if( ButtonManager.buttonGroups[ i ].id == id ) {
					break;
				}
			}
			return ButtonManager.buttonGroups[ i ];
		}
		
		private static function moveCursor( event:MouseEvent ):void {
			if ( !ButtonManager.cursor.visible ) ButtonManager.cursor.visible = true;
			ButtonManager.cursor.x = event.stageX;
			ButtonManager.cursor.y = event.stageY;
		}
		
		private static function onMouseLeave( event:Event ):void {
			ButtonManager.cursor.visible = false;
			cursor.gotoAndStop( CURSOR_ARROW );
		}
		
	}
}