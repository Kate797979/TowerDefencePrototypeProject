package game.data.map 
{
	/**
	 * ...
	 * @author ...
	 */
	public class NeighborTile 
	{
		private var _tile:Tile;
		private var _direction:String;
		
		public function NeighborTile(tile:Tile, direction:String) 
		{
			_tile = tile;
			_direction = direction;
		}
		
		public function get tile():Tile 
		{
			return _tile;
		}
		
		public function get direction():String 
		{
			return _direction;
		}
		
	}

}