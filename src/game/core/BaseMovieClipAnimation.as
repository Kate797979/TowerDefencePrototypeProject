package game.core 
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	/**
	 * ...
	 * @author kate
	 */
	public class BaseMovieClipAnimation extends BaseAnimation
	{
		
		protected var _mClipKey:String;
		protected var _mClip:MovieClip;
		protected var _reverse:Boolean = false;
		
		public function BaseMovieClipAnimation(skinKey:String, x:Number, y:Number, scale:Number = 1, fps:Number = 24) 
		{
			super(skinKey, x, y, scale, fps);
		}
		
		public function set loop(value:Boolean):void
		{
			if (_mClip) _mClip.loop = value;
		}
		
		override public function pause():void 
		{
			pauseMovieClip();
			
			super.pause();
		}
		
		override public function resume():void 
		{
			playMovieClip();
			
			super.resume();
		}
		
		protected function pauseMovieClip():void
		{
			if (_mClip) _mClip.pause();
		}
		
		override public function play(onComplete:Function = null):void 
		{
			playMovieClip();
			
			super.play();
		}
		
		protected function playMovieClip():void
		{
			if (_mClip) 
			{
				if (!_paused) Starling.juggler.add(_mClip);
				else _mClip.play();
			}
		}
		
		override public function stop():void 
		{
			super.stop();
			
			stopMovieClip();
		}
		
		/**
		 * Останавливает текущий клип, но не всю анимацию
		 */
		protected function stopMovieClip():void
		{
			if (_mClip)
			{
				//////// Изврат, т.к. Starling при остановке клипа сбрасывает текущую позицию в 0
				var currFrame:int = _mClip.currentFrame;
				_mClip.stop();
				_mClip.currentFrame = currFrame;
				///////
				
				Starling.juggler.remove(_mClip);
			}
		}
		
		public function get currentFrame():int
		{
			if (_mClip) return _mClip.currentFrame;
			
			return 0;
		}
		
		public function get isComplete():Boolean
		{
			if (_mClip) return _mClip.isComplete;
			
			return true;
		}
		
		public function get isPlaying():Boolean
		{
			if (_mClip) return _mClip.isPlaying;
			
			return false;
		}
		
		protected function releaseMovieClip():void
		{
			if (_mClip)
			{
				_mClip.stop();
				Starling.juggler.remove(_mClip);
				
				if (_onStateComplete != null)
				{
					_mClip.removeEventListener(Event.COMPLETE, onStateComplete);
					_onStateComplete = null;
				}
				if (_onComplete != null)
				{
					_mClip.removeEventListener(Event.COMPLETE, onComplete);
					_onComplete = null;
				}
				
				_mClip.removeFromParent();
				_mClip = null;
			}
			
		}
		
		override public function release():void
		{
			releaseMovieClip();
			super.release();
		}
		
	}

}