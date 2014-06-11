/*
 * ButtonManager
 * Manager for quick and easy drawing.
 *
 * @author		Sergei Krivtsov
 * @version		1.00.10 20.12.2013
 * @e-mail		flashgangsta@gmail.com
 *
 *
*/

package com.flashgangsta.display {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.Sprite;
	
	public class Drawing {

		public function Drawing() {
			// constructor code
		}
		
		/**
		 * Рисует квадрат с градиентом
		 * @param	target Sprite or Shape object
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	colors
		 * @param	alphas
		 * @param	rotation
		 * @param	type
		 */
		
		static public function drawGradientRectangle(target:*, x:Number, y:Number, width:Number, height:Number, colors:Array, alphas:Array, rotation:Number = 90, type:String = "linear" ):void {
			var matrix:Matrix = new Matrix();
			var ratios:Array = [];
			var graphics:Graphics = target.graphics;
			
			checkType(target, Sprite, Shape);
			
			matrix.createGradientBox(width, height, Math.PI / 180 * rotation);
			
			for(var i:int = 0; i < colors.length; i++) {
				ratios.push((255 / (colors.length - 1)) * i);
			}
			
			graphics.beginGradientFill(type === "linear" ? GradientType.LINEAR : GradientType.RADIAL, colors, alphas, ratios, matrix);  
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
		}
		
		/**
		 * Рисует рамку
		 * @param	target Sprite or Shape instance
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	color
		 * @param	borderHeight
		 * @param	alpha
		 * @param	clear
		 */
		
		static public function drawBorder( target:*, x:Number, y:Number, width:Number, height:Number, color:Number = 0, borderHeight:Number = 1, alpha:Number = 1, clear:Boolean = false):void {
			checkType(target, Sprite, Shape);
			
			if(clear) target.graphics.clear();
			
			Drawing.drawRectangle(target, x, y, width, borderHeight, color, alpha);
			Drawing.drawRectangle(target, x, y + height - borderHeight, width, borderHeight, color, alpha);
			Drawing.drawRectangle(target, x, y + borderHeight, borderHeight, height - borderHeight * 2, color, alpha);
			Drawing.drawRectangle(target, width - borderHeight, y + borderHeight, borderHeight, height - borderHeight * 2, color, alpha);
		}
		
		/**
		 * 
		 * @param	target Sprite or Shape object
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	color
		 * @param	alpha
		 */
		
		static public function drawRectangle(target:*, x:Number, y:Number, width:Number, height:Number, color:Number, alpha:Number):void {
			checkType(target, Sprite, Shape);
			var graphics:Graphics = target.graphics;
			graphics.beginFill(color, alpha);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
		}
		
		/**
		 * Рисует пунктирную линию
		 * @param	target Sprite or Shape object
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	thickness
		 * @param	color
		 * @param	alpha
		 * @param	dash
		 * @param	spacing
		 * @param	caps
		 */
		
		static public function drawDashedLine(target:*, x:Number, y:Number, width:Number, height:Number, thickness:Number = 1, color:uint = 0, alpha:Number = 1, dash:Number = 6, spacing:Number = 6, caps:String = null):void {
			checkType(target, Sprite, Shape);
			var graphics:Graphics = target.graphics;
			var segLength:Number = dash + spacing; 								// Размер одной полоски с пробелом
			var delta:Number = Math.sqrt((width * width) + (height * height));	// Длина линии
			var segsCount:Number = Math.floor(Math.abs(delta / segLength)); 	// Сумма штрихов с пробелами
			var radians:Number = Math.atan2(height, width); 					// Угол
			var xPoint:Number = x; 												// Начало полосы по x
			var yPoint:Number = y; 												// Начало полосы по y
			var xEndPoint:Number = x + width; 									// Конечная точка по x
			var yEndPoint:Number = y + height; 									// Конечная точка по y
			var xDelta:Number = Math.cos(radians) * segLength;
			var yDelta:Number = Math.sin(radians) * segLength;
			
			graphics.lineStyle(thickness, color, alpha, false, LineScaleMode.NORMAL, caps);
			
			for (var i:int = 0; i < segsCount; i++) {
				graphics.moveTo(xPoint, yPoint);
				graphics.lineTo(xPoint + Math.cos(radians) * dash, yPoint + Math.sin(radians) * dash);
				xPoint += xDelta;
				yPoint += yDelta;
			}
			
			graphics.moveTo(xPoint, yPoint);
			delta = Math.sqrt(( xEndPoint - xPoint ) * (xEndPoint - xPoint) + (yEndPoint - yPoint) * (yEndPoint - yPoint));
			
			if(delta > dash) {
				graphics.lineTo(xPoint + Math.cos(radians) * dash, yPoint + Math.sin(radians) * dash);
			} else if(delta > 0) {
				graphics.lineTo(xPoint + Math.cos(radians) * delta, yPoint + Math.sin(radians) * delta);
			}
			
			graphics.moveTo(xEndPoint, yEndPoint);
			
		}
		
		/**
		 * Рисует клин
		 * @param	target Sprite or Shape instance
		 * @param	x Крайняя левая точка от которой начнется клин
		 * @param	y Крайняя верхняя точка от которой начнется клин
		 * @param	radius Радиус клина
		 * @param	startAngle Угол с которого начинается отрисовка клина
		 * @param	arc Угол клина
		 * @param	yRadius [optional] Радиус клина по оси Y, по умолчанию он равен радиусу по оси X
		 * @param	alpha [optional] Прозрачность
		 * @param	color [optional] Заливка
		 */
		
		static public function drawWedge(target:*, x:Number, y:Number, radius:Number, startAngle:Number, arc:Number, yRadius:Number = 0, alpha:Number = 1, color:uint = 0):void {
			checkType(target, Sprite, Shape);
			x += radius;
			y += radius;
			
			if (!yRadius) {
				yRadius = radius;
			}
			
			if (Math.abs(arc) > 360) {
				arc = 360;
			}
			
			var graphics:Graphics = target.graphics;
			var segsCount:Number = Math.ceil(Math.abs(arc) / 45); // Высчитываем кол-во сегментов
			var theta:Number = -((arc / segsCount) / 180) * Math.PI; // Размах каждого сегмента в радианах
			var angle:Number = -(startAngle / 180) * Math.PI; // Преобразования угла startAngle в радианы
			var angleMid:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;
			
			graphics.beginFill(color, alpha);
			graphics.moveTo(x, y);
			
			// Рисуем кривую в между сегментами не более 45 градусов
			if (segsCount > 0) {
				// рисуется линия от центра к точке от которой будет рисоваться кривая
				ax = x + Math.cos(startAngle / 180 * Math.PI) * radius;
				ay = y + Math.sin(-startAngle / 180 * Math.PI) * yRadius;
				graphics.lineTo(ax, ay);
				
				for (var i:int = 0; i < segsCount; i++) {
					angle += theta;
					angleMid = angle - (theta / 2);
					bx = x + Math.cos(angle) * radius;
					by = y + Math.sin(angle) * yRadius;
					cx = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
					cy = y + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
					graphics.curveTo(cx, cy, bx, by);
				}
				graphics.lineTo(x, y);
			}
		}
		
		/**
		 * 
		 * @param	target
		 * @param	...types
		 */
		
		static private function checkType(target:*, ...types):void {
			var result:Boolean;
			for (var i:int = 0; i < types.length; i++) {
				if (target is types[i]) {
					result = true;
					break;
				}
			}
			
			if (!result) {
				throw new Error("target object must be extends by one of this classes: " + types );
			}
		}
		
	}
	
}
