package com.flashgangsta.starling.utils {
	import com.flashgangsta.starling.display.Animation;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class AnimationsCache {
		
		static private var instance:AnimationsCache;
		
		private var cache:Dictionary = new Dictionary();
		
		/**
		 * 
		 */
		
		public function AnimationsCache() {
			if(!instance) {
				instance = this;
				init();
			} else {
				throw new Error("AnimationsCache is singletone. Use static funtion getInstance() for get an instance of class");
			}
		}
		
		/**
		 * 
		 * @param	flashMovieClipClass
		 */
		
		public function getCopy(flashMovieClipClass:Class):Animation {
			addInstance(flashMovieClipClass);
			trace("		GET:", flashMovieClipClass);
			return Animation(cache[flashMovieClipClass]).clone();
		}
		
		/**
		 * 
		 */
		
		public function isCached(flashMovieClipClass:Class):Boolean {
			return Boolean(cache[flashMovieClipClass]);
		}
		
		/**
		 * 
		 */
		
		static public function getInstance():AnimationsCache {
			if(!instance) {
				instance = new AnimationsCache();
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
		 * @param	flashMovieClipClass
		 */
		
		private function addInstance(flashMovieClipClass:Class):void {
			if (isCached(flashMovieClipClass)) {
				return;
			}
			trace("	ADD:", flashMovieClipClass);
			var movieClip:MovieClip = new flashMovieClipClass() as MovieClip;
			var animation:Animation = cache[flashMovieClipClass] = MovieClipToAnimationConverter.getAnimationFromMovieClip(movieClip);
			
			animation.stop();
		}
		
	}
	
}