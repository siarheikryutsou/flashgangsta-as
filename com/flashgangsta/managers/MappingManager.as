/**
 * MappingManager
 * Manager for quick and easy to scale and align objects.
 *
 * @author		Sergei Krivtsov
 * @version		1.00.18		25/08/2014
 *
 */

package com.flashgangsta.managers {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	
	public class MappingManager {
		
		public function MappingManager() {
			trace("MappingManager is a static class and should not be instantiated.");
		}
		
		/**
		 * Пропорционально скалирует объект относительно указанной ширины и высоты
		 * @param	target
		 * @param	maxWidth
		 * @param	maxHeight
		 */
		
		public static function setScale(target:Object, maxWidth:int, maxHeight:int):void {
			var targetRect:Rectangle = target.getBounds(target);
			target.scaleX = target.scaleY = Math.min(maxWidth / targetRect.width, maxHeight / targetRect.height);
			roundSides(target);
		}
		
		/**
		 * Пропорционально скалирует объект относительно указанной ширины и высоты но не более его исходного размера
		 * @param	target
		 * @param	maxWidth
		 * @param	maxHeight
		 */
		
		public static function setScaleOnlyReduce(target:DisplayObject, maxWidth:int, maxHeight:int):void {
			var targetRect:Rectangle = target.getBounds(target);
			target.scaleX = target.scaleY = Math.min(maxWidth / targetRect.width, maxHeight / targetRect.height, 1);
			roundSides(target, Math.floor);
		}
		
		/**
		 * Скалирует объект по ширине не более его истинного размера
		 * @param	target
		 * @param	stageWidth
		 */
		
		static public function setScaleByWidthOnlyReduce(target:DisplayObject, width:int):void {
			var targetRect:Rectangle = target.getBounds(target);
			target.scaleX = target.scaleY = Math.min(width / targetRect.width, 1);
			roundSides(target, Math.floor);
		}
		
		/**
		 * Пропорционально скалирует объект так, что бы он полностью заполнил указанную зону
		 * @param	target объект подвергаемый скалированию
		 * @param	area зона которую он должен заполнить
		 */
		
		public static function setScaleFillArea(target:Object, area:Rectangle):void {
			var targetRect:Rectangle = target.getBounds(target);
			target.scaleX = target.scaleY = Math.max(area.width / targetRect.width, area.height / targetRect.height);
			roundSides(target, Math.ceil);
		}
		
		/**
		 * Устанавливает объект в центр указанной зоны
		 * @param	target
		 * @param	area
		 */
		
		public static function alignToCenter(target:Object, area:Rectangle, neededRoundPosition:Boolean = true):void {
			var targetBounds:Rectangle = target.getBounds(target);
			target.x = area.x + ((area.width - target.width) / 2) - targetBounds.x;
			target.y = area.y + ((area.height - target.height) / 2) - targetBounds.y;
			
			if (neededRoundPosition) {
				roundPositionPoint(target);
			}
		}
		
		/**
		 * 
		 * @param	target
		 * @param	area
		 * @param	neederRoundPosition
		 */
		
		static public function alignCenterY(target:Object, area:Rectangle, neededRoundPosition:Boolean = true):void {
			var targetBounds:Rectangle = target.getBounds(target);
			target.y = area.y + ((area.height - target.height) / 2) - targetBounds.y;
			
			if (neededRoundPosition) {
				target.y = Math.round(target.y);
			}
		}
		
		/**
		 * 
		 * @param	target
		 * @param	area
		 * @param	neederRoundPosition
		 */
		
		static public function alignCenterX(target:Object, area:Rectangle, neededRoundPosition:Boolean = true):void {
			var targetBounds:Rectangle = target.getBounds(target);
			target.x = area.x + ((area.width - target.width) / 2) - targetBounds.x;
			
			if (neededRoundPosition) {
				target.x = Math.round(target.x);
			}
		}
		
		/**
		 * Возвращает точку объекта которую ему нужно присвоить, что бы он находился в центре относительно базового объекта
		 * @param	basicValue размер базового объекта
		 * @param	objectValue
		 * @return
		 */
		
		public static function getCentricPoint(basicValue:Number, objectValue:Number):int {
			return Math.round((basicValue - objectValue) / 2);
		}
		
		/**
		 * Выравнивет объект в рамках указанной зоны
		 * @param	target объект для выравнивания
		 * @param	area зона
		 */
		
		public static function setMargins(target:DisplayObject, area:Rectangle):void {
			if (target.x + target.width > area.x + area.width) {
				target.x = Math.floor(area.x + area.width - target.width);
			}
			
			if (target.x < area.x) {
				target.x = Math.ceil(area.x);
			}
			
			if (target.y < area.y) {
				target.y = Math.ceil(area.y);
			}
			
			if (target.y + target.height > area.y + area.height) {
				target.y = Math.floor(area.y + area.height - target.height);
			}
		}
		
		/**
		 * Округляет размеры объекта
		 * @param	target
		 * @param	method метод округления. Допустимые значения:
		 * Math.ceil
		 * Math.floor
		 * Math.round
		 */
		
		public static function roundSides(target:Object, method:Function = null):void {
			if (method === null) {
				method = Math.round;
			}
			target.width = method(target.width);
			target.height = method(target.height);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	methond default value is Math.round
		 */
		
		static public function roundPositionPoint(target:Object, methond:Function = null):void {
			if (methond === null) {
				methond = Math.round;
			}
			target.x = methond(target.x);
			target.y = methond(target.y);
		}
		
		/**
		 * Возвращает y координату нижней граници объекта
		 * @param	target
		 * @param	targetCoordinateSpace
		 * @return
		 */
		
		public static function getBottom(target:DisplayObject, targetCoordinateSpace:DisplayObject):int {
			return Math.ceil(target.getBounds(targetCoordinateSpace).bottom);
		}
		
		/**
		 * 
		 * @param	target
		 * @param	targetCoordinateSpace
		 * @return
		 */
		
		public static function getRight(target:DisplayObject, targetCoordinateSpace:DisplayObject):int {
			return Math.ceil(target.getBounds(targetCoordinateSpace).right);
		}
		
		/**
		 *  Устанавливает x, y свойства от одного объекта к другому
		 * @param	copyTo объект к которому будут применены свойства
		 * @param	copyFrom объект от которого будут взяты применяемые свойства
		 */
		
		static public function copyPosition(copyTo:Object, copyFrom:Object):void {
			copyTo.x = copyFrom.x;
			copyTo.y = copyFrom.y;
		}
		
		/**
		 *  Устанавливает width, height свойства от одного объекта к другому
		 * @param	copyTo объект к которому будут применены свойства
		 * @param	copyFrom объект от которого будут взяты применяемые свойства
		 */
		
		static public function copySize(copyTo:Object, copyFrom:Object):void {
			copyTo.width = copyFrom.width;
			copyTo.height = copyFrom.height;
		}
		
		/**
		 *  Устанавливает x, y, width, height свойства от одного объекта к другому
		 * @param	copyTo объект к которому будут применены свойства
		 * @param	copyFrom объект от которого будут взяты применяемые свойства
		 */
		
		static public function copyPositionAndSize(copyTo:Object, copyFrom:Object):void {
			copyPosition(copyTo, copyFrom);
			copySize(copyTo, copyFrom);
		}
	
	}

}
