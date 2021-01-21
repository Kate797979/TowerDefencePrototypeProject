package game.data 
{
	import game.core.BaseObject;
	import starling.events.Event;
	/**
	 * ...
	 * @author K
	 */
	public class Player extends BaseObject
	{
		public function Player() 
		{
			
		}
	
		/**
		 * Средства игрока
		 */
		public var funds:Number = 0;
				
		/**
		 * Жизни игрока
		 */
		public var lives:int;
		
	}

}