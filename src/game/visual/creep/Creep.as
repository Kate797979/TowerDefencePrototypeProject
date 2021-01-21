package game.visual.creep 
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import game.core.BaseObject;
	import game.data.creeps.CreepInfo;
	import game.visual.wave.Wave;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.utils.Color;
	/**
	 * ...
	 * @author K
	 */
	public class Creep extends Sprite
	{
		private var _creepAnimation:CreepAnimation;
		
		private var _creepHPTextField:TextField;
		
		private var _wave:Wave;
		
		private var _state:String;
		
		private var _hitTestPoint:Point;
		
		/**
		 * Позиция X для удара по крипу
		 */
		private var _blowX:Number = 0;
		
		/**
		 * Позиция Y для удара по крипу
		 */
		private var _blowY:Number = 0;
		
		public function Creep(creepInfo:CreepInfo, wave:Wave) 
		{
			_creepInfo = creepInfo;
			_wave = wave;
			
			_state = CreepStates.CREATED;
			
			_creepAnimation = new CreepAnimation(creepInfo);
			addChild(_creepAnimation);
			
			/////Создаём текстовое поля для вывода HP
			_creepHPTextField = new TextField(32, 18, "", "Times New Roman", 12, Color.WHITE, true);
			
			_creepHPTextField.x = _creepInfo.textX;
			_creepHPTextField.y = _creepInfo.textY;
			
			addChild(_creepHPTextField);
			///////////////////////////
			
			_hitTestPoint = new Point(_creepInfo.textX, _creepInfo.textY);
			
			_blowX = 0;
			_blowY = _creepInfo.textY / 3;
		}
		
		private var _currentDirection:String;
		public function setDirection(direction:String):void
		{
			if (_currentDirection != direction)
			{
				_currentDirection = direction;
				_creepAnimation.setState(direction);
			}
		}
		
		private var _freezColorFilter:ColorMatrixFilter;
		private var _frozen:Boolean = false;
		/**
		 * Снижает скорость крипа
		 * @param	percent На сколько процентов снизить скорость
		 * @param	time Время действия эффекта (в секундах)
		 */
		public function freez(percent:Number, time:Number):void
		{
			if (!_frozen)
			{
				_frozen = true;
				
				speed = speed * (100 - percent) / 100;
				
				if (_freezColorFilter == null)
				{
					_freezColorFilter = new ColorMatrixFilter();
					_freezColorFilter.tint(Color.BLUE, 0.5);
				}
				
				_creepAnimation.filter = _freezColorFilter;
				
				setTimeout(unfreez, time * 1000);
			}
		}
		
		public function unfreez():void
		{
			if (_frozen && _playing && _state==CreepStates.MOVING)
			{
				_creepAnimation.filter = null;
				speed = _defaultSpeed;
				
				_frozen = false;
			}
		}
		
		private var _creepInfo:CreepInfo;
		public function get creepInfo():CreepInfo 
		{
			return _creepInfo;
		}
		
		private var _defaultSpeed:Number = 0;
		/**
		 * Скорость крипа по умолчанию (когда нет эффекта заморозки) 
		 */
		public function get defaultSpeed():Number 
		{
			return _defaultSpeed;
		}
		
		/**
		 * Скорость крипа по умолчанию (когда нет эффекта заморозки) 
		 */
		public function set defaultSpeed(value:Number):void 
		{
			_defaultSpeed = value;
		}
		
		private var _speed:Number = 0;
		/**
		 * Текущая скорость крипа (пикселей в секунду)
		 */
		public function get speed():Number 
		{
			return _speed;
		}
		
		/**
		 * Текущая сорость крипа (пикселей в секунду)
		 */
		public function set speed(value:Number):void 
		{
			_speed = value;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private var _HP:int = 10;
		public function get HP():int 
		{
			return _HP;
		}
		
		public function set HP(value:int):void 
		{
			_HP = Math.max(0, value);
			_creepHPTextField.text = _HP.toString();
			
			if (_HP == 0)
				state = CreepStates.KILLED;
		}
		
		public function get wave():Wave 
		{
			return _wave;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			_state = value;
			
			dispatchEvent(new CreepEvent(CreepEvent.STATE_CHANGED, this));
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get blowX():Number 
		{
			return _blowX;
		}
		
		public function get blowY():Number 
		{
			return _blowY;
		}
		
		public function get frozen():Boolean 
		{
			return _frozen;
		}
		
		public function release():void
		{
			_creepAnimation.release();
			removeFromParent();
		}
		
		private var _playing:Boolean = true;
		public function get playing():Boolean 
		{
			return _playing;
		}
		
		public function get hitTestPoint():Point 
		{
			return _hitTestPoint;
		}
		
		public function stop():void
		{
			_playing = false;

			_creepAnimation.stop();
		}
	}

}