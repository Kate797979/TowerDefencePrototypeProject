package game.visual.wave 
{
	import game.core.commands.ParallelCommand;
	import game.data.creeps.CreepInfo;
	import game.data.map.CreepPathOneDirectionPart;
	import game.data.map.Map;
	import game.data.WaveInfo;
	import game.GameManager;
	import game.visual.creep.Creep;
	import game.visual.creep.CreepEvent;
	import game.visual.creep.CreepMoveCommand;
	import game.visual.creep.CreepStates;
	import game.visual.GameLayer;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author K
	 */
	public class Wave extends EventDispatcher
	{
		
		public function Wave(waveInfo:WaveInfo, creepInfo:CreepInfo) 
		{
			_waveInfo = waveInfo;
			_creepInfo = creepInfo;
		}
		
		private var _waveInfo:WaveInfo;
		private var _creepInfo:CreepInfo;
		
		private var _creeps:Vector.<Creep> = new Vector.<Creep>();
		public function get creeps():Vector.<Creep> 
		{
			return _creeps;
		}
		
		public function get waveInfo():WaveInfo 
		{
			return _waveInfo;
		}
		
		public function createCreeps():void
		{
			var creep:Creep;
			for (var i:int = 0; i < _waveInfo.creepsCount; i++)
			{
				creep = new Creep(_creepInfo, this);
				creep.HP = _waveInfo.creepHP;
				
				_creeps.push(creep);
				
				creep.addEventListener(CreepEvent.STATE_CHANGED, onCreepStateChanged);
			}
		}
		
		private function onCreepStateChanged(e:CreepEvent):void 
		{
			if (e.creep.state == CreepStates.COMPLETED || e.creep.state == CreepStates.KILLED)
			{
				dispatchEvent(new CreepEvent(CreepEvent.STATE_CHANGED, e.creep));
				
				e.creep.removeEventListener(CreepEvent.STATE_CHANGED, onCreepStateChanged);
				_creeps.splice(_creeps.indexOf(e.creep), 1);
				
				if (_creeps.length == 0)
					dispatchEvent(new WaveEvent(WaveEvent.WAVE_COMPLETED, this));
			}
			
		}
		
		public function createWaveMoveCommand(gameLayer:GameLayer, map:Map):ParallelCommand
		{
			var creepPathParts:Vector.<CreepPathOneDirectionPart> = map.getCreepPathParts();
			
			var parallelCommand:ParallelCommand = new ParallelCommand();
			
			var creep:Creep;
			var creepDelay:Number;
			var creepMoveCommand:CreepMoveCommand;
			
			for (var i:int = 0; i < _creeps.length; i++)
			{
				creep = _creeps[i];
				creep.defaultSpeed = creep.speed = map.tileSize * _waveInfo.creepSpeed;
				creepDelay = i * _waveInfo.creepDistance * map.tileSize / creep.speed;
				
				creepMoveCommand = new CreepMoveCommand(creepDelay, creep, creepPathParts, gameLayer);
				parallelCommand.commands.push(creepMoveCommand);
			}
			
			return parallelCommand;
		}
		
	}

}