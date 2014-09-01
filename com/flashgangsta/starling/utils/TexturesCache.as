package com.flashgangsta.starling.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 1.03 01/09/2014
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
		 */
		
		static public function getInstance():TexturesCache {
			if(!instance) {
				instance = new TexturesCache();
			}
			return instance;
		}
		
		/**
		 * 
		 * @param	sourceClass
		 * @return
		 */
		
		public function getTexture(key:Object):Texture {
			var result:Texture = cache[key];
			
			if (!result) {
				trace("Texture:", key, "not found");
			}
			
			return result;
		}
		
		/**
		 * 
		 * @param	key
		 * @return
		 */
		
		public function isTextureExists(key:Object):Boolean {
			return Boolean(cache[key]);
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function addTextureByClass(sourceClass:Class):Texture {
			if (isTextureExists(sourceClass)) {
				return cache[sourceClass];
			}
			
			var texture:Texture = createTexture(sourceClass);
			
			if (texture) {
				cache[sourceClass] = texture;
			}
			
			return texture;
			
		}
		
		/**
		 * 
		 * @param	instance
		 */
		
		public function addTextureByInstance(instance:Object):Texture {
			var sourceClass:Class = getQualifiedClassName(instance) as Class;
			var texture:Texture;
			
			if (isTextureExists(sourceClass)) {
				return cache[sourceClass];
			}
			
			texture = createTexture(instance);
			cache[sourceClass] = texture;
			
			return texture;
		}
		
		/**
		 * 
		 * @param	name
		 * @param	texture
		 */
		
		public function addTextureByCustomName(name:String, source:Object, overwriteIfExists:Boolean = false):Texture {
			if (isTextureExists(name)) {
				if (!overwriteIfExists) {
					return cache[name];
				} else {
					Texture(cache[name]).dispose();
					delete cache[name];
					cache[name] = null;
				}
			}
			
			var texture:Texture = createTexture(source);
			cache[name] = texture;
			
			return texture;
		}
		
		/**
		 * 
		 * @param	source
		 * @return
		 */
		
		private function createTexture(source:Object):Texture {
			var sourceClass:Class;
			var matrix:Matrix;
			var bounds:Rectangle;
			var bitmapData:BitmapData;
			var texture:Texture;
			var instance:Object;
			
			if (source is Class) {
				sourceClass = source as Class;
				instance = new sourceClass();
			} else {
				instance = source;
			}
			
			if (instance is Texture) {
				texture = instance as Texture;
			} else if (instance is Bitmap) {
				texture = Texture.fromBitmap(instance as Bitmap);
			} else if (instance is BitmapData) {
				texture = Texture.fromBitmapData(instance as BitmapData);
			} else if (instance is DisplayObject) {
				matrix = new Matrix();
				bounds = instance.getBounds(instance);
				
				bounds.x = Math.floor(bounds.x);
				bounds.y = Math.floor(bounds.y);
				bounds.width = Math.ceil(bounds.width + 1);
				bounds.height = Math.ceil(bounds.height + 1);
				
				matrix.identity();
				matrix.translate(Math.ceil(-bounds.x + 1), Math.ceil(-bounds.y + 1));
				
				bitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
				bitmapData.lock();
				bitmapData.draw(instance as DisplayObject, matrix);
				bitmapData.unlock();
				
				texture = Texture.fromBitmapData(bitmapData);
			} else if (instance is Image) {
				texture = Image(instance).texture;
			} else {
				trace("Incorrect source type:", sourceClass);
			}
			
			return texture;
		}
		
		/**
		 * 
		 */
		
		private function init():void {
			
		}
		
	}
	
}