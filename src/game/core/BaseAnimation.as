package game.core 
{
	import starling.display.Sprite;
	/**
	 * ...
	 * @author kate
	 */
	public class BaseAnimation  extends Sprite implements IBaseAnimation
	{
		
		protected var _scale:Number = 1;
		protected var _fps:Number = 24;
		protected var _skinKey:String;
		
		public function BaseAnimation(skinKey:String, x:Number = 0, y:Number = 0, scale:Number = 1, fps:Number = 24) 
		{
			this.x = x;
			this.y = y;
			
			_scale = scale;
			_fps = fps;
			_skinKey = skinKey;
		}
		
		public function stop():void
		{
			_paused = false;
			_playing = false;
		}
		
		protected var _paused:Boolean = false;
		public function pause():void
		{
			if (_playing)
				_paused = true;
		}
		
		public function resume():void
		{
			if (_paused)
				_paused = false;
		}
		
		protected var _playing:Boolean = false;
		protected var _onComplete:Function;
		public function play(onComplete:Function = null):void
		{
			_paused = false;
			_playing = true;
			
			_onComplete = onComplete;
		}
		
		public function onComplete(e:*):void
		{
			if (_onComplete != null)
				_onComplete();
		}
		
		protected var _currentState:String;
		protected var _onStateComplete:Function;
		public function setState(key:String, onComplete:Function = null, ... params):void
		{
			_currentState = key;
			_onStateComplete = onComplete;
			
			if (!_paused) 
				_playing = true;
		}
		
		public function onStateComplete(e:*):void
		{
			if (_onStateComplete != null)
				_onStateComplete();
		}
		
		public function get playing():Boolean 
		{
			return _playing;
		}
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		public function get currentState():String 
		{
			return _currentState;
		}
		
		public function release():void
		{
			this.removeFromParent();
		}
		
		public function update(dt:Number = 0):void
		{
			
		}
		
	}

}