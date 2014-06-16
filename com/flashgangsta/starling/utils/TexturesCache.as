package com.flashgangsta.starling.utils {
	import com.flashgangsta.display.BitmapMovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 1.01 16/06/2014
	 */
	
	public class TexturesCache {
		
		static private var instance:TexturesCache;
		
		private var cache:Dictionary = new Dictionary();
		
		/**
		 * 
		 */
		
		public function TexturesCache() {
			if(!instance) {
				instance = this;
				init();
			} else {
				throw new Error("TexturesCache is singletone. Use static funtion getInstance() for get an instance of class");
			}
		}
		
		/**
		 * 
		 * @param	sourceClass
		 * @return
		 */
		
		public function getTexture(sourceClass:Class, instance:Object = null):Texture {
			if (!instance) {
				addTextureByClass(sourceClass);
			} else {
				addTextureByInstance(sourceClass, instance);
			}
			
			trace("		Get:", sourceClass);
			return cache[sourceClass];
		}
		
		/**
		 * 
		 * @param	sourceClass
		 * @return
		 */
		
		public function isChached(sourceClass:Class):Boolean {
			return Boolean(cache[sourceClass]);
		}
		
		/**
		 * 
		 * @param	sourceClass
		 * @param	sourceInstance
		 */
		
		private function addTextureByInstance(sourceClass:Class, sourceInstance:Object):void {
			if (isChached(sourceClass)) {
				return;
			}
			
			var texture:Texture;
			
			if (sourceInstance is BitmapData) {
				texture = Texture.fromBitmapData(sourceInstance as BitmapData);
			} else if (sourceInstance is Bitmap) {
				texture = Texture.fromBitmap(sourceInstance as Bitmap);
			} else if (sourceInstance is DisplayObject) {
				var displayObject:DisplayObject = sourceInstance as DisplayObject;
				var matrix:Matrix = new Matrix();
				var objectBounds:Rectangle = displayObject.getBounds(displayObject);
				var bitmapData:BitmapData;
				
				objectBounds.x = Math.floor(objectBounds.x);
				objectBounds.y = Math.floor(objectBounds.y);
				objectBounds.width = Math.ceil(objectBounds.width + 1);
				objectBounds.height = Math.ceil(objectBounds.height + 1);
				
				matrix.identity();
				matrix.translate(Math.ceil(-objectBounds.x + 1), Math.ceil(-objectBounds.y + 1));
				
				bitmapData = new BitmapData(objectBounds.width, objectBounds.height, true, 0x00000000);
				bitmapData.lock();
				bitmapData.draw(displayObject, matrix);
				bitmapData.unlock();
				
				texture = Texture.fromBitmapData(bitmapData);
			} else {
				trace("Incorrect source type:", sourceInstance);
			}
			
			if (texture) {
				trace("	Add:", sourceClass);
				cache[sourceClass] = texture;
			}
		}
		
		/**
		 * 
		 */
		
		static public function getInstance():TexturesCache {
			if(!instance) {
				instance = new TexturesCache();
			}
			return instance;
		}
		
		/**
		 * 
		 */
		
		private function init():void {
			
		}
		
		/**
		 * 
		 */
		
		private function addTextureByClass(sourceClass:Class):void {
			if (isChached(sourceClass)) {
				return;
			}
			
			addTextureByInstance(sourceClass, new sourceClass());
		}
		
	}
	
}