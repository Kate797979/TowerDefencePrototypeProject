package game.visual.creep 
{
	import game.core.commands.Command;
	import game.data.map.CreepPathOneDirectionPart;
	import game.visual.GameLayer;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import utils.MathUtil;
	/**
	 * ...
	 * @author K
	 */
	public class CreepMoveCommand extends Command
	{
		private var _creep:Creep;
		private var _creepPathParts:Vector.<CreepPathOneDirectionPart>;
		private var _gameLayer:GameLayer;
		
		private var _tween:Tween;
		
		private var _currentPathPart:CreepPathOneDirectionPart;
		private var _currentPathPartIndex:int;
		
		private var _currentSpeed:Number;
		
		public function CreepMoveCommand(delay:Number, creep:Creep, creepPathParts:Vector.<CreepPathOneDirectionPart>, gameLayer:GameLayer) 
		{
			super(delay);
			
			_creep = creep;
			_creepPathParts = creepPathParts;
			_gameLayer = gameLayer;
		}
		
		override protected function execute():void 
		{
			super.execute();
			
			_creep.state = CreepStates.MOVING;
			
			subscribeEvents();
			
			_currentSpeed = _creep.speed;
			
			_currentPathPartIndex = 0;
			
			_gameLayer.gameObjectsLayer.addChild(_creep);
			
			startNextTween();
		}
		
		private function subscribeEvents():void
		{
			_creep.addEventListener(Event.CHANGE, creepChangedHandler);
		}
		
		private function unsubscribeEvents():void
		{
			_creep.removeEventListener(Event.CHANGE, creepChangedHandler);
		}
		
		private function startNextTween():void
		{
			_currentPathPart = _creepPathParts[_currentPathPartIndex];
			
			_creep.x = _currentPathPart.fromX;
			_creep.y = _currentPathPart.fromY;
			
			_creep.setDirection(_currentPathPart.direction);
			
			_tween = new Tween(_creep, _currentPathPart.distance / _currentSpeed);
			_tween.moveTo(_currentPathPart.toX, _currentPathPart.toY);
			
			_tween.onComplete = onNextPartComplete;
			
			Starling.juggler.add(_tween);
			
		}
		
		private function onNextPartComplete():void
		{
			if (++_currentPathPartIndex < _creepPathParts.length)
			{
				startNextTween();
			}
			else
			{
				unsubscribeEvents();
				
				_creep.state = CreepStates.COMPLETED;
				
				release();
				complete();
			}
		}
		
		private function creepChangedHandler(e:Event):void 
		{
			if (_creep.state == CreepStates.KILLED)
			{
				unsubscribeEvents();
				release();
				complete();
			}
			else if (_creep.speed != _currentSpeed)
			{
				_currentSpeed = _creep.speed;
				
				resetTween();
			}
		}
		
		private function release():void
		{
			Starling.juggler.removeTweens(_creep);
			_creep.release();
		}
		
		private function resetTween():void
		{
			Starling.juggler.remove(_tween);
			
			var time:Number = MathUtil.getDistance(_creep.x, _creep.y, _currentPathPart.toX, _currentPathPart.toY) / _currentSpeed;
			
			_tween.reset(_creep, time);
			_tween.moveTo(_currentPathPart.toX, _currentPathPart.toY);
			_tween.onComplete = onNextPartComplete;
			
			Starling.juggler.add(_tween);
		}
		
		override public function stop():void 
		{
			super.stop();
			
			Starling.juggler.removeTweens(_creep);
			_creep.stop();
			
			complete();
		}
		
	}

}