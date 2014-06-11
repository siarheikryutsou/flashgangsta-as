/*
 * Anchor
 * Class to set the navigation flash through the browser bar.
 *
 * @author		Sergei Krivtsov
 * @version		1.00.01
 * @e-mail		flashgangsta@gmail.com
 *
 *
 */


package com.flashgangsta.navigation {
	
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Anchor {
		
		private static var currentAnchor:String;
		private static var lastAnchor:String;
		private static var anchors:Array;
		private static var handler:Function;
		private static var anchorCheckTimer:Timer = new Timer( 200 );
		private static var levels:int;
		
		public function Anchor() {
			throw new Error( "Anchor is a static class and should not be instantiated." );
		}
		
		public static function addAnchor( sectionsData:Array, onChanged:Function ):void {
			
			Anchor.anchors = sectionsData;
			Anchor.levels = Anchor.getLevels();
			Anchor.handler = onChanged;
			
			
			Anchor.lastAnchor = Anchor.anchors[ 0 ].section;
			Anchor.currentAnchor = Anchor.getAnchor();
			
			Anchor.verifyAnchor();
			
			anchorCheckTimer.addEventListener( TimerEvent.TIMER, onAnchorReaded );
			anchorCheckTimer.start();
			
		}
		
		public static function setAnchor( anchor:String ):void {
			ExternalInterface.call( "function() { window.location = '#" + anchor + "' }");
		}
		
		private static function getAnchor():String {
			var fullAnchor:String = String( ExternalInterface.call( "window.location.hash.toString" ) );
			var factAnchor:String = fullAnchor !== "null" ? fullAnchor.substr( 1, fullAnchor.length ) : "null";
			if( factAnchor.charAt( factAnchor.length - 1 ) === "/" ) {
				factAnchor = factAnchor.substr( 0, factAnchor.length - 1 );
			}
			return factAnchor;
		}
		
		private static function verifyAnchor():void {
			
			var section:String;
			var subsection:String;
			
			if( Anchor.currentAnchor !== "null" )  {
				if( Anchor.currentAnchor.indexOf( "/" ) > -1 && Anchor.currentAnchor.charAt( Anchor.currentAnchor.length - 1 ) !== "/" ) {
					// Если подраздел есть.
					//trace( "Есть" );
					section = Anchor.currentAnchor.substr( 0, Anchor.currentAnchor.indexOf( "/" ) );
					subsection = Anchor.currentAnchor.substr( Anchor.currentAnchor.indexOf( "/" ) + 1, Anchor.currentAnchor.length );
				} else {
					// Если подраздела нет.
					//trace( "Нет" );
					section = Anchor.currentAnchor;
				}
				
				for( var i:int = 0; i < Anchor.anchors.length; i++ ) {
				
					var verifydSection:String = anchors[ i ].section;
					var verifydSubsection:String;
					var foundSection:String;
					var foundSubsection:String;
				
					if( section === verifydSection ) {
						
						foundSection = verifydSection;
						
						if( Anchor.anchors[ i ].subsections ) {
							for( var j:int = 0; j < Anchor.anchors[ i ].subsections.length; j++ ) {
								verifydSubsection = Anchor.anchors[ i ].subsections[ j ].section;
								if( subsection === verifydSubsection ) { 
									foundSubsection = verifydSubsection;
									break;
								}
							}
						}
						break;
					}
				}
			}
			
			//trace( subsection );
			
			if( foundSection ) { //Если найден раздел
				Anchor.currentAnchor = foundSection;
				if( foundSubsection ) { //Если найден подраздел
					Anchor.currentAnchor += "/" + foundSubsection;
				} else if( subsection !== null ) { //Если подраздел ненайден и он искался
					Anchor.currentAnchor = Anchor.lastAnchor;
					Anchor.setAnchor( Anchor.currentAnchor );
				}
				
				//trace( subsection === null, foundSubsection !== null,  subsection !== null );
				
				if( ( subsection === null || foundSubsection !== null && subsection !== null ) ) {
					Anchor.handler( foundSection, foundSubsection );
				}
				
			} else {
				Anchor.currentAnchor = Anchor.lastAnchor;
				Anchor.setAnchor( Anchor.currentAnchor );
			}
			
			Anchor.lastAnchor = Anchor.currentAnchor;
		}
		
		private static function onAnchorReaded( event:TimerEvent ):void {
			if( Anchor.getAnchor() !== Anchor.lastAnchor ) {
				Anchor.currentAnchor = Anchor.getAnchor();
				Anchor.verifyAnchor();
			}
		}
		
		private static function getLevels():int {
			/*var levelsLength:int = 0;
			var currentLevel:int = 0;
			for( var i:int = 0; i < Anchor.anchors.length; i++ ) {
				
			}*/
			return 2;
		}
		
		private static function checkCurrentLevel( currentLevel:Array ):int {
			for( var i:int = 0; i < currentLevel.length; i++ ) {
				if( currentLevel[ i ].subsection ) {
					return 1;
				}
			}
			return 0;
		}
	}
	
}