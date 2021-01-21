package game.visual.wave 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author K
	 */
	/// @eventType	game.visual.wave.WavesEvent
	[Event(name = "next_wave_need_started", type = "game.visual.wave.WavesEvent")]  
	
	/// @eventType	game.visual.wave.WavesEvent
	[Event(name = "next_wave_interval_changed", type = "game.visual.wave.WavesEvent")]  
	
	/// @eventType	game.visual.wave.WavesEvent
	[Event(name = "wave_completed", type = "game.visual.wave.WavesEvent")]  
	
	/// @eventType	game.visual.wave.WavesEvent
	[Event(name = "all_waves_completed", type = "game.visual.wave.WavesEvent")]  
	
	public class WaveEvent extends Event
	{
		public static const NEXT_WAVE_NEED_STARTED:String = "next_wave_need_started";
		
		public static const NEXT_WAVE_INTERVAL_CHANGED:String = "next_wave_interval_changed";
		
		public static const WAVE_COMPLETED:String = "wave_completed";
		
		public static const ALL_WAVES_COMPLETED:String = "all_waves_completed";
		
		public function WaveEvent(type:String, wave:Wave = null) 
		{
			super(type);
			
			_wave = wave;
		}
		
		private var _wave:Wave;
		
		public function get wave():Wave 
		{
			return _wave;
		}
		
	}

}