package game.visual.wave 
{
	import flash.utils.Dictionary;
	import game.data.WaveInfo;
	import game.GameManager;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author K
	 */
	public class Waves extends EventDispatcher
	{
		private var _wavesInfos:Vector.<WaveInfo>;
		private var _activeWaves:Vector.<Wave> = new Vector.<Wave>();
		private var _creepsInfos:Dictionary;
		
		public function Waves(wavesInfos:Vector.<WaveInfo>, creepsInfos:Dictionary) 
		{
			_wavesInfos = wavesInfos;
			_creepsInfos = creepsInfos;
			
			if (_wavesInfos.length > 0)
				_nextWaveInterval = _wavesInfos[0].previousWaveInterval;
		}
		
		public function get wavesInfos():Vector.<WaveInfo> 
		{
			return _wavesInfos;
		}
		
		public function get wavesCount():int
		{
			return _wavesInfos.length;
		}
		
		private var _nextWaveInterval:Number = 0;
		public function get nextWaveInterval():Number 
		{
			return _nextWaveInterval;
		}
		
		public function set nextWaveInterval(value:Number):void 
		{
			_nextWaveInterval = value;
			
			if (_nextWaveInterval == 0)
			{
				if (_currentWaveIndex + 1 < _wavesInfos.length)
				{
					dispatchEvent(new WaveEvent(WaveEvent.NEXT_WAVE_NEED_STARTED));
				}
			}
			else if (_nextWaveInterval == -1)
			{
				if (_currentWaveIndex < _wavesInfos.length - 1)
				{
					_nextWaveInterval = _wavesInfos[_currentWaveIndex + 1].previousWaveInterval;
					dispatchEvent(new WaveEvent(WaveEvent.NEXT_WAVE_INTERVAL_CHANGED));
				}
			}
		}
		
		public function startNextWave():void
		{
			_currentWaveIndex++;
			
			_currentWaveInfo = _wavesInfos[_currentWaveIndex];
			_currentWave = new Wave(_currentWaveInfo, _creepsInfos[_currentWaveInfo.creepType]);
			_activeWaves.push(_currentWave);
			_currentWave.createCreeps();
			
			_currentWave.addEventListener(WaveEvent.WAVE_COMPLETED, waveComleteHandler);
		}
		
		private function waveComleteHandler(e:WaveEvent):void 
		{
			_activeWaves.splice(_activeWaves.indexOf(e.wave), 1);
			
			if (_activeWaves.length == 0 && _currentWaveIndex == _wavesInfos.length - 1)
				dispatchEvent(new WaveEvent(WaveEvent.ALL_WAVES_COMPLETED));
		}
		
		private var _currentWaveIndex:int = -1;
		public function get currentWaveIndex():int 
		{
			return _currentWaveIndex;
		}
		
		private var _currentWaveInfo:WaveInfo;
		public function get currentWaveInfo():WaveInfo 
		{
			return _currentWaveInfo;
		}
		
		private var _currentWave:Wave;
		public function get currentWave():Wave 
		{
			return _currentWave;
		}
		
		public function get activeWaves():Vector.<Wave> 
		{
			return _activeWaves;
		}
		
		public function reset():void
		{
			_activeWaves = new Vector.<Wave>();
			
			_currentWave = null;
			_currentWaveInfo = null;
			_currentWaveIndex = -1;
			
			if (_wavesInfos.length > 0)
				_nextWaveInterval = _wavesInfos[0].previousWaveInterval;
		}
		
	}

}