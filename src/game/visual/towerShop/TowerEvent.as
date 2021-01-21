package game.visual.towerShop 
{
	import game.data.TowerInfo;
	import starling.events.Event;
	/**
	 * ...
	 * @author K
	 */
	/// @eventType	game.visual.tower.TowerEvent
	[Event(name = "over", type = "game.visual.tower.TowerEvent")]  
	
	/// @eventType	game.visual.tower.TowerEvent
	[Event(name = "out", type = "game.visual.tower.TowerEvent")]  
	
	/// @eventType	game.visual.tower.TowerEvent
	[Event(name = "trigged", type = "game.visual.tower.TowerEvent")]  
	
	public class TowerEvent extends Event
	{
		public static const TRIGGED:String = "trigged";
		
		public static const OVER:String = "over";
		
		public static const OUT:String = "out";
		
		public function TowerEvent(type:String, towerInfo:TowerInfo) 
		{
			super(type);
			
			_towerInfo = towerInfo;
		}
		
		private var _towerInfo:TowerInfo;
		
		public function get towerInfo():TowerInfo 
		{
			return _towerInfo;
		}
		
	}

}