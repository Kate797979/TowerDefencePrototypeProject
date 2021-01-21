package game.data 
{
	import flash.utils.getQualifiedClassName;
	import game.core.BaseObject;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author ...
	 */
	public class Level extends BaseObject
	{
		private var _waves:Vector.<Wave> = new Vector.<Wave>();
		
		public var id:int;
		
		public function Level() 
		{
			
		}
		
		override public function load(data:Object):void 
		{
			var wavesArr:Array = data["waves"] as Array;
			if (wavesArr == null)
			{
				Log.add(formatString("{0}:: Error load waves data.", getQualifiedClassName(this)));
				
				return;
			}
			
			for each (var waveObj:Object in wavesArr)
			{
				var wave:Wave = new Wave();
				wave.load(waveObj);
				
				_waves.push(wave);
			}
		}
		
		private var _nextWaveInterval:Number = 10;
		public function get nextWaveInterval():Number 
		{
			return _nextWaveInterval;
		}
		
		public function set nextWaveInterval(value:Number):void 
		{
			_nextWaveInterval = value;
		}
		
		private var _currentWaveIndex:int = 0;
		public function get currentWaveIndex():int 
		{
			return _currentWaveIndex;
		}
		
		private var _currentWave:Wave;
		public function get currentWave():Wave 
		{
			return _currentWave;
		}
		
		public function get wavesCount():int
		{
			return _waves.length;
		}
		
	}

}