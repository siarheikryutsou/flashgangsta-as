package com.flashgangsta.starling.display {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.01 25/07/2014
	 */
	
	public class Shapes {
		
		public function Shapes() {
			
		}
		
		static public function getCircleTexture(radius:Number, color:uint, alpha:Number = 1):Texture {
			const shape:Shape = new Shape();
			const graphics:Graphics = shape.graphics;
			const matrix:Matrix = new Matrix();
			const diameter:Number = radius * 2;
			var bitmapData:BitmapData = new BitmapData(diameter, diameter, true, 0x00000000);
			var texture:Texture;
			matrix.translate(radius, radius);
			graphics.beginFill(color, alpha);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
			bitmapData.draw(shape, matrix);
			texture = Texture.fromBitmapData(bitmapData);
			bitmapData.dispose();
			shape.graphics.clear();
			
			return texture;
		}

		
	}

}