package com.flashgangsta.media.video {
	import com.flashgangsta.events.YoutubePlayerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	/**
	* Вызывается при загрузке и инициализации проигрывателя, что означает его готовность к приему вызовов API.
	*/
	[Event(name = "onReady", type = "com.flashgangsta.events.YoutubePlayerEvent")]
	
	/**
	* Это событие возникает при изменении состояния проигрывателя.
	* Возможные значения:
		* не запущен (-1),
		* воспроизведение закончено (0),
		* идет воспроизведение (1),
		* пауза (2),
		* буферизация (3),
		* видео размечено (5).
	*
	* Сначала при загрузке SWF сообщается о событии "не запущен" (-1).
	* Когда видео размечено и готово к воспроизведению, сообщается о событии "видео размечено" (5).
	*/
	[Event(name = "onStateChange", type = "com.flashgangsta.events.YoutubePlayerEvent")]
	
	/**
	* Это событие возникает при изменении качества воспроизведения видео.
	* Например, при вызове функции setPlaybackQuality(suggestedQuality) это событие возникнет,
	* если качество воспроизведения изменится. Код должен отвечать на событие,
	* а не предполагать, что качество автоматически изменится при вызове функции setPlaybackQuality(suggestedQuality).
	* Точно так же код не должен предполагать,
	* что качество воспроизведения будет меняться только в результате явного вызова setPlaybackQuality или другой функции,
	* позволяющей установить предлагаемое качество воспроизведения.
	* 
	* Значение, сообщаемое событием, указывает новое качество воспроизведения.
	* Возможны следующие значения: small, medium, large и hd720.
	*/
	[Event(name = "onReady", type = "com.flashgangsta.events.YoutubePlayerEvent")]
	
	/**
	* Это событие вызывается, если в проигрывателе произошла ошибка.
	* Возможны следующие коды ошибок: 100, 101 и 150.
		* Код ошибки 100 выдается, когда запрошенное видео не найдено. Это происходит, если видео было удалено (по любой причине) или было помечено как личное.
		* Код ошибки 101 выдается, если запрошенное видео не может быть воспроизведено встроенными проигрывателями.
		* Код ошибки 150 означает то же самое, что и 101. Это просто замаскированный 101.
	*/
	[Event(name = "onReady", type = "com.flashgangsta.events.YoutubePlayerEvent")]
	
	public class YoutubePlayerInstance extends EventDispatcher {
		
		/// минимальное разрешение проигрывателя – 1280 х 720 пикселей.
		static public const QUALITY_HD720:String = "hd720";
		/// минимальное разрешение проигрывателя – 854 х 480 пикселей.
		static public const QUALITY_LARGE:String = "large";
		/// минимальное разрешение проигрывателя – 640 х 360 пикселей.
		static public const QUALITY_MEDIUM:String = "medium";
		/// разрешение проигрывателя – менее 640 х 360 пикселей.
		static public const QUALITY_SMALL:String = "small";
		/// YouTube выбирает подходящее качество воспроизведения.
		static public const QUALITY_DEFAULT:String = "default";
		
		/// не запущено
		static public const STATE_NOT_STARTED:int = -1;
		/// проигрывание завершено
		static public const STATE_PLAYING_COMPLETED:int = 0;
		/// проигрывается
		static public const STATE_PLAYING:int = 1;
		/// установлена пауза
		static public const STATE_PAUSED:int = 2;
		/// идет буферизация
		static public const STATE_BUFFERING:int = 3;
		/// видео размечено и готово к воспроизведению
		static public const STATE_READY:int = 5;
		
		/// выдается, когда запрошенное видео не найдено. Это происходит, если видео было удалено (по любой причине) или было помечено как личное.
		static public const ERROR_VIDEO_NOT_FOUND:int = 100;
		/// запрошенное видео не может быть воспроизведено встроенными проигрывателями.
		static public const ERROR_NOT_AVIABLE_FOR_EXTERNAL_PLAYERS:int = 101;
		/// то же самое, что и 101. Это просто замаскированный 101.
		static public const ERROR_NOT_AVIABLE_FOR_EXTERNAL_PLAYERS_MASKED:int = 150;
		
		
		/// экземпляр youtube проигрывателя
		private var player:Object;
		
		/**
		 * 
		 * @param	player
		 */
		
		public function YoutubePlayerInstance( player:Object ) {
			this.player = player;
		}
		
		public function getPlayer():DisplayObject {
			return player as DisplayObject;
		}
		
		/**								*
		 * 								*
		 *  	LOAD VIDEO CONTROLL		*
		 * 								*
		 *								*/
		
		/**
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		
		override public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			getEventDispatcher( type ).addEventListener( type, listener, useCapture );
		}
		
		/**
		 * 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		
		override public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void {
			getEventDispatcher( type ).removeEventListener( type, listener, useCapture );
		}
		
		/**
		 * 
		 * @param	type
		 * @return
		 */
		
		override public function hasEventListener( type:String ):Boolean {
			return getEventDispatcher( type ).hasEventListener( type );
		}
		
		/**
		 * 
		 * @param	eventType
		 * @return
		 */
		
		private function getEventDispatcher( eventType:String ):EventDispatcher {
			var result:EventDispatcher;
			switch( eventType ) {
				case YoutubePlayerEvent.ON_READY:
				case YoutubePlayerEvent.ON_ERROR:
				case YoutubePlayerEvent.ON_STATE_CHANGE:
				case YoutubePlayerEvent.ON_PLAYBACK_QUALITY_CHANGE:
					result = player as EventDispatcher;
					break;
				default :
					result = super;
			}
			return result;
		}
		
		/**
		 * Загрузка значка указанного видео и подготовка проигрывателя к воспроизведению видео.
		 * Проигрыватель не запрашивает FLV до тех пор, пока не будет вызвана функция playVideo() или seekTo().
		 * @param	videoId	определяет идентификатор воспроизводимого видео YouTube. В фидах видео API данных YouTube тег <yt:videoId> определяет идентификатор.
		 * @param	startSeconds	может принимать целочисленные значения или значения с плавающей точкой и задает время, с которого начнется воспроизведение видео при вызове playVideo(). Если задать значение startSeconds и затем вызвать seekTo(), проигрыватель начнет воспроизведение с момента, указанного в вызове seekTo(). Когда видео размечено и готово к воспроизведению, проигрыватель передает событие "видео размечено" (5).
		 * @param	suggestedQuality	определяет предлагаемое качество воспроизведения видео. Дополнительная информация о качестве воспроизведения видео приведена в определении функции setPlaybackQuality.
		 */
		
		public function cueVideoById( videoId:String, startSeconds:Number = 0, suggestedQuality:String = YoutubePlayerInstance.QUALITY_DEFAULT ):void {
			player.cueVideoById( videoId, startSeconds, suggestedQuality );
		}
		
		/**
		 * Загрузка и воспроизведение указанного видео.
		 * @param	videoId определяет идентификатор воспроизводимого видео YouTube. В фидах видео API данных YouTube тег <yt:videoId> определяет идентификатор.
		 * @param	startSeconds принимает целочисленные значения и значения с плавающей точкой. Если этот параметр установлен, воспроизведение видео начнется с ключевого кадра, ближайшего к указанному времени.
		 * @param	suggestedQuality определяет предлагаемое качество воспроизведения видео. Дополнительная информация о качестве воспроизведения видео приведена в определении функции setPlaybackQuality.
		 */
		
		public function loadVideoById( videoId:String, startSeconds:Number = 0, suggestedQuality:String = YoutubePlayerInstance.QUALITY_DEFAULT ):void {
			player.loadVideoById( videoId, startSeconds, suggestedQuality );
		}
		
		/**
		 * Загрузка значка указанного видео и подготовка проигрывателя к воспроизведению видео.
		 * Проигрыватель не запрашивает FLV до тех пор, пока не будет вызвана функция playVideo() или seekTo().
		 * @param	mediaContentUrl нужно использовать полный URL проигрывателя YouTube в формате http://www.youtube.com/v/VIDEO_ID. Если атрибут format тега <media:content> имеет значение 5, в фидах видео API данных YouTube атрибут url этого тега будет содержать полный URL проигрывателя.
		 * @param	startSeconds может принимать целочисленные значения или значения с плавающей точкой и задает время, с которого начнется воспроизведение видео при вызове playVideo(). Если задать значение startSeconds и затем вызвать seekTo(), проигрыватель начнет воспроизведение с момента, указанного в вызове seekTo(). Когда видео размечено и готово к воспроизведению, проигрыватель передает событие "видео размечено" (5).
		 */
		
		public function cueVideoByUrl( mediaContentUrl:String, startSeconds:Number = 0 ):void {
			player.cueVideoByUrl( mediaContentUrl, startSeconds );
		}
		
		/**
		 * Загрузка и воспроизведение указанного видео.
		 * @param	mediaContentUrl ужно использовать полный URL проигрывателя YouTubeв формате http://www.youtube.com/v/VIDEO_ID. Если атрибут format тега <media:content> имеет значение 5, в фидах видео API данных YouTube атрибут url этого тега будет содержать полный URL проигрывателя.
		 * @param	startSeconds может принимать целочисленные значения или значения с плавающей точкой и задает время, с которого начнется воспроизведение видео. Если задать параметр startSeconds (можно в формате с плавающей точкой), воспроизведение видео начнется с ключевого кадра, ближайшего к указанному моменту времени.
		 */
		
		public function loadVideoByUrl( mediaContentUrl:String, startSeconds:Number = 0 ):void {
			player.loadVideoByUrl( mediaContentUrl, startSeconds );
		}
		
		
		/**								*
		 * 								*
		 *  	PLAYING CONTROLL		*
		 * 								*
		 *								*/
		
		 
		/**
		 * Воспроизведение размеченного/загруженного видео.
		 */
		
		public function playVideo():void {
			player.playVideo();
		}
		
		/**
		 * Приостановка воспроизведения видео.
		 */
		
		public function pauseVideo():void {
			player.pauseVideo();
		}
		
		/**
		 * Остановка воспроизведения видео. Эта функция также отменяет загрузку видео.
		 */
		
		public function stopVideo():void {
			try {
				player.stopVideo();
			} catch ( error:Error ) {
				
			}
		}
		
		/**
		 * Переход к указанному времени в видео (в секундах). Функция seekTo()
		 * @param	seconds будет искать ближайший ключевой кадр до времени, определенного параметром. Это означает, что иногда воспроизведение будет начинаться в момент, предшествующий заданному времени (обычно не более чем на 2 секунды).
		 * @param	allowSeekAhead определяет, будет ли проигрыватель делать новый запрос серверу, если значение seconds превышает продолжительность загруженных видеоданных.
		 */
		
		public function seekTo( seconds:Number, allowSeekAhead:Boolean = true ):void {
			player.seekTo( seconds , allowSeekAhead );
		}
		
		/**
		 * Удаление видео с экрана. Эта функция используется, если нужно удалить с экрана видео,
		 * оставшееся после вызова функции stopVideo(). Обратите внимание,
		 * что в API проигрывателя ActionScript 3.0 эта функция считается устаревшей.
		 */
		
		public function clearVideo():void {
			player.clearVideo();
		}
		
		/**
		 * Возвращает состояние воспроизведения видео
		 * @return
		 */
		
		public function isPlaying():Boolean {
			return player ? getPlayerState() === STATE_PLAYING : false;
		}
	
		/**
		 * Возвращает состояние паузы видео
		 * @return
		 */
		
		public function isPaused():Boolean {
			return player ? getPlayerState() === STATE_PAUSED : false;
		}
		
		/**							*
		 * 							*
		 *  	SOUND CONTROLL		*
		 * 							*
		 *							*/
		
		
		/**
		 * Выключает звук в проигрывателе.
		 */
		
		public function mute():void {
			player.mute();
		}
		
		/**
		 * Включает звук в проигрывателе.
		 */

		public function unMute():void {
			player.unMute();
		}
		
		/**
		 * Возвращает состояние звука
		 * @return Возвращает значение true, если звук в проигрывателе выключен, и false, если включен.
		 */
		
		public function isMuted():Boolean {
			return player.isMuted();
		}
		
		/**
		 * Устанавливает громкость. Принимает целочисленное значение от 0 до 100.
		 * @param	volume
		 */
		
		public function setVolume( volume:Number ):void {
			player.setVolume( volume );
		}
		
		/**
		 * Возвращает уровень громкости, установленный в проигрывателе (целое число от 0 до 100).
		 * Обратите внимание, что getVolume() возвращает установленный уровень громкости,
		 * даже если звук в проигрывателе отключен.
		 */
		
		public function getVolume():void {
			player.getVolume();
		}
		
		/**							*
		 * 							*
		 *  	SIZE CONTROLL		*
		 * 							*
		 *							*/
		
		/**
		 * Устанавливает размер проигрывателя в пикселях.
		 * Этот метод следует использовать вместо установки свойств, определяющих ширину и высоту в MovieClip.
		 * Обратите внимание на то, что этот метод не накладывает ограничений на пропорции проигрывателя видео,
		 * поэтому вам будет необходимо поддерживать соотношение 4:3. Размер по умолчанию для отображения файла
		 * SWF проигрывателя Chromeless при загрузке в другом файле SWF – 320х240 пикселей;
		 * размер по умолчанию для отображения файла SWF встроенного проигрывателя – 480х385 пикселей.
		 * @param	width
		 * @param	height
		 */
		
		public function setSize( width:Number, height:Number ):void {
			trace( "player.setSize(", width, height, ");" );
			player.setSize( width, height );
		}
		
		/**							*
		 * 							*
		 *  	STATES CONTROLL		*
		 * 							*
		 *							*/
		
		/**
		 * Возвращает число байтов, загруженных для текущего видео.
		 * @return
		 */
		
		public function getVideoBytesLoaded():Number {
			return player.getVideoBytesLoaded();
		}
		
		/**
		 * Возвращает размер в байтах текущего загруженного/воспроизводимого видео.
		 * @return
		 */
		
		public function getVideoBytesTotal():Number {
			return player.getVideoBytesTotal();
		}
		
		/**
		 * Возвращает число байтов, с которого началась загрузка видеофайла.
		 * Пример применения. Пользователь переходит вперед в место, которое еще не было загружено,
		 * и проигрыватель делает новый запрос для воспроизведения фрагмента видео, который еще не был загружен.
		 * @return
		 */
		
		public function getVideoStartBytes():Number {
			return player.getVideoStartBytes();
		}
		
		/**
		 * Возвращает состояние проигрывателя.
		 * Возможные значения:
			 * не запущен (-1),
			 * воспроизведение закончено (0),
			 * идет воспроизведение (1),
			 * пауза (2),
			 * буферизация (3),
			 * видео размечено (5).
		 * @return
		 */
		
		public function getPlayerState():Number {
			return player.getPlayerState();
		}
		
		/**
		 * Возвращает время в секундах, прошедшее с начала воспроизведения видео.
		 * @return
		 */
		
		public function getCurrentTime():Number {
			return player.getCurrentTime();
		}
		
		/**								*
		 * 								*
		 *  	QUALITY CONTROLL		*
		 * 								*
		 *								*/
		
		/**
		 * Эта функция получает фактическое значение качества текущего видео.
		 * Если текущее видео отсутствует, возвращается undefined.
		 * @return  Могут возвращаться следующие значения: hd720, large, medium и small.
		 */
		
		public function getPlaybackQuality():String {
			return player.getPlaybackQuality();
		}
		
		/**
		 * Эта функция устанавливает предлагаемое значение качества текущего видео.
		 * При вызове этой функции видео перезагружается с текущей позиции с новым качеством.
		 * Качество воспроизведения изменится только для видео, воспроизводимого в данный момент.
		 * 
		 * При вызове этой функции не гарантируется, что качество воспроизведения действительно изменится.
		 * Качество воспроизведения изменится только для видео, воспроизводимого в данный момент.
		 * В этот момент возникает событие onPlaybackQualityChange, и код должен реагировать на него, а не на факт вызова функции setPlaybackQuality.
		 * 
		 * Параметр suggestedQuality может принимать значения small, medium, large, hd720 и default.
		 * Присвоение параметру значения default предписывает YouTube выбрать наиболее подходящее качество воспроизведения в зависимости от пользователя,
		 * видео, применяемых систем и других условий воспроизведения.
		 * 
		 * Если для видео принято предложение в отношении качества воспроизведения, это предлагаемое значение будет действительно только для данного видео.
		 * Следует выбирать такое качество воспроизведения, которое соответствует размеру проигрывателя видео.
		 * Например, если на странице отображается проигрыватель, имеющий размеры 640 х 360 пикселей,
		 * видео в качестве medium будет выглядеть лучше, чем в качестве large.
		 * В следующем списке приводятся рекомендованные уровни качества воспроизведения для различных размеров проигрывателя.
		 * 
		 * Уровень качества small: разрешение проигрывателя – менее 640 х 360 пикселей.
		 * Уровень качества medium: минимальное разрешение проигрывателя – 640 х 360 пикселей.
		 * Уровень качества large: минимальное разрешение проигрывателя – 854 х 480 пикселей.
		 * Уровень качества hd720: минимальное разрешение проигрывателя – 1280 х 720 пикселей.
		 * Уровень качества default: YouTube выбирает подходящее качество воспроизведения.
		 * Данная настройка возвращает уровень качества в значение по умолчанию и отменяет все предыдущие действия
		 * по настройке качества воспроизведения с использованием функций cueVideoById, loadVideoById или setPlaybackQuality.
		 * 
		 * Если функция setPlaybackQuality вызывается с уровнем качества suggestedQuality, который недоступен для данного видео,
		 * то будет установлен следующий доступный более низкий уровень качества.
		 * Например, если запрашивается уровень качества large и он недоступен,
		 * будет установлено качество воспроизведения medium (если данный уровень качества доступен).
		 * 
		 * Также присвоение параметру suggestedQuality значения, которое не является распознаваемым уровнем качества,
		 * равносильно установке для suggestedQuality значения default. player.getAvailableQualityLevels():Array
		 * Эта функция возвращает набор форматов качества, которые доступны для текущего видео.
		 * Эта функция может использоваться для определения того, доступно ли для просматриваемого видео более высокое качество,
		 * и проигрыватель может отобразить кнопку или другой элемент, позволяющий пользователю изменить качество.
		 * 
		 * @param	suggestedQuality может принимать значения small, medium, large, hd720 и default.
		 */
		
		public function setPlaybackQuality( suggestedQuality:String ):void {
			player.setPlaybackQuality( suggestedQuality );
		}
		
		/**
		 * Эта функция возвращает массив строк, упорядоченных от самого высокого до самого низкого качества.
		 * Элементы массива могут принимать значения hd720, large, medium и small. Функция возвращает пустой массив,
		 * если текущее видео отсутствует.
		 * 
		 * Ваш клиент не должен автоматически переключаться на использование самого высокого (или низкого) качества или формата
		 * с неизвестным названием. YouTube может расширить список уровней качества, чтобы включить форматы, которые могут подходить
		 * для контекста вашего проигрывателя.
		 * Аналогично YouTube может удалить параметры качества, которые могут отрицательно повлиять на восприятие пользователя.
		 * Добившись того, чтобы ваш клиент переключался только на известные, доступные форматы, вы сможете гарантировать,
		 * что на работу клиента не повлияет введение новых уровней качества или удаление уровней качества,
		 * неподходящих для контекста вашего проигрывателя.
		 * 
		 * @return
		 */
		
		public function getAvailableQualityLevels():Array {
			return player.getAvailableQualityLevels();
		}
		
		/**								*
		 * 								*
		 *  	VIDEO DATA INFO			*
		 * 								*
		 *								*/
		
		/**
		 * Возвращает длительность в секундах видео, воспроизводимого в текущий момент.
		 * Обратите внимание на то, что getDuration() возвратит 0, если метаданные видео еще не загружены,
		 * что обычно случается в самом начале воспроизведения видео.
		 * @return
		 */
		
		public function getDuration():Number {
			return player.getDuration();
		}
		
		/**
		 * Возвращает URL на YouTube.com для видео, загружаемого или воспроизводимого в текущий момент.
		 * @return
		 */
		
		public function getVideoUrl():String {
			return player.getVideoUrl();
		}
		
		/**
		 * Возвращает код встраивания для видео, загружаемого или воспроизводимого в текущий момент.
		 * @return
		 */
		
		public function getVideoEmbedCode():String {
			return player.getVideoEmbedCode();
		}
		
		/**								*
		 * 								*
		 *  	VIDEO DATA INFO			*
		 * 								*
		 *								*/
		
		/**
		 * Эта функция, которая еще не была реализована для API проигрывателя AS3, уничтожает экземпляр проигрывателя.
		 * Она должна быть вызвана перед выгрузкой SWF проигрывателя из родительского SWF.
		 * 
		 * Внимание! Всегда следует вызывать player.destroy() для выгрузки проигрывателя YouTube.
		 * Эта функция закрывает объект NetStream и останавливает загрузку дополнительных видео после выгрузки проигрывателя.
		 * Если код содержит дополнительные ссылки на проигрыватель SWF,
		 * то во время его выгрузки эти экземпляры должны быть выгружены по отдельности.
		 */
		
		public function destroy():void {
			try {
				player.destroy();
			} catch ( e:Error ) {
				player.addEventListener( YoutubePlayerInstance.STATE_READY, callDestroyAfterReady );
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function callDestroyAfterReady( event:Event ):void {
			player.removeEventListener( YoutubePlayerInstance.STATE_READY, callDestroyAfterReady );
			player.destroy();
		}
	}

}