package game.map 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Tile 
	{
		private var _row:int;
		private var _column:int;
		
		private var _posX:Number;
		private var _posY:Number;
		
		private var _type:int = 0;
		
		public function Tile(row:int, column:int, posX:Number, posY:Number, type:int = 0)
		{
			_row = row;
			_column = column;
			
			_posX = posX;
			_posY = posY;
			
			_type = type;
		}
		
		public function get row():int 
		{
			return _row;
		}
		
		public function get column():int 
		{
			return _column;
		}
		
		/**
		 * Координата X центра тайла
		 */
		public function get posX():Number 
		{
			return _posX;
		}
		
		/**
		 * Координата Y центра тайла
		 */
		public function get posY():Number 
		{
			return _posY;
		}
		
		/**
		 * Тип тайла (перечисление TileTipe)
		 */
		public function get type():int 
		{
			return _type;
		}
		
		/**
		 * Тип тайла (перечисление TileTipe)
		 */
		public function set type(value:int):void 
		{
			_type = value;
		}
		
	}

}