package game.data.levels 
{
	import flash.utils.getQualifiedClassName;
	import game.core.BaseObject;
	import game.data.map.Map;
	import game.data.WaveInfo;
	import game.GameManager;
	import game.visual.wave.Waves;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author K
	 */
	public class Level extends BaseObject
	{
		private var _waves:Waves;
		private var _map:Map = new Map();
		
		public var index:int;
		public var levelId:String;
		
		public function Level() 
		{
			
		}
		
		override public function load(data:Object):void 
		{
			if (data.hasOwnProperty("levelId"))
				levelId = data["levelId"];
				
			/////////Загружаем информацию о волнах
			var wavesArr:Array = data["waves"] as Array;
			if (wavesArr == null)
			{
				Log.add(formatString("{0}:: Error load waves data.", getQualifiedClassName(this)));
				
				return;
			}
			
			var wavesInfos:Vector.<WaveInfo> = new Vector.<WaveInfo>();
			for each (var waveObj:Object in wavesArr)
			{
				var wave:WaveInfo = new WaveInfo();
				wave.load(waveObj);
				
				wavesInfos.push(wave);
			}
			
			_waves = new Waves(wavesInfos, GameManager.creepsInfos);
			/////////////////////////
				
			//////////Загружаем карту
			var mapObj:Object = data["map"];
			if (mapObj == null)
			{
				Log.add(formatString("{0}:: Error! Information about map not found", getQualifiedClassName(this)));
			}
			else
			{
				_map.load(mapObj);
			}
			//////////////////////////////
		}
		
		public function get map():Map 
		{
			return _map;
		}
		
		public function get waves():Waves 
		{
			return _waves;
		}
		
		override public function reset():void
		{
			_waves.reset();
			_map.reset();
		}
		
	}

}