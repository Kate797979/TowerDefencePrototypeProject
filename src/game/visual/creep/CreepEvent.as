package game.visual.creep 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author K
	 */
	/// @eventType	game.visual.creep.CreepEvent
	[Event(name = "state_changed", type = "game.visual.creep.CreepEvent")]  
	
	public class CreepEvent extends Event
	{
		public static const STATE_CHANGED:String = "state_changed";
		
		public function CreepEvent(type:String, creep:Creep) 
		{
			super(type);
			
			_creep = creep;
		}
		
		private var _creep:Creep;
		
		public function get creep():Creep 
		{
			return _creep;
		}
		
	}

}