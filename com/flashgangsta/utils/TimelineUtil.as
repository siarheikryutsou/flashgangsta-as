package com.flashgangsta.utils {
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.02	27/01/2014
	 */
	public class TimelineUtil {
		
		public function TimelineUtil() {
			
		}
		
		/**
		 * 
		 * @param	target
		 * @return
		 */
		
		public static function getFrameLabelsByName(target:MovieClip):Dictionary {
			var frames:Array = target.currentLabels;
			var result:Dictionary;
			
			if (frames.length) {
				result = new Dictionary();
				for each(var label:FrameLabel in frames) {
					result[label.name] = label;
				}
			}
			
			return result;
		}
		
	}

}