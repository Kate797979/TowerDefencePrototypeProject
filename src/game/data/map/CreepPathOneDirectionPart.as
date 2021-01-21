package game.data.map 
{
	/**
	 * ...
	 * @author K
	 */
	public class CreepPathOneDirectionPart 
	{
		private var _direction:String;
		
		private var _fromX:Number;
		private var _fromY:Number;
		
		private var _toX:Number;
		private var _toY:Number;
		
		private var _distance:Number;
		
		public function CreepPathOneDirectionPart(direction:String, fromX:Number, fromY:Number, toX:Number, toY:Number, distance:Number) 
		{
			_direction = direction;
			
			_fromX = fromX;
			_fromY = fromY;
			
			_toX = toX;
			_toY = toY;
			
			_distance = distance;
		}
		
		public function get direction():String 
		{
			return _direction;
		}
		
		public function get fromX():Number 
		{
			return _fromX;
		}
		
		public function get fromY():Number 
		{
			return _fromY;
		}
		
		public function get toX():Number 
		{
			return _toX;
		}
		
		public function get toY():Number 
		{
			return _toY;
		}
		
		public function get distance():Number 
		{
			return _distance;
		}
		
	}

}