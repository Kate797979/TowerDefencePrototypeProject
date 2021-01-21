package game.map 
{
	import flash.utils.getQualifiedClassName;
	import game.core.BaseObject;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author ...
	 */
	public class Map extends BaseObject
	{
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		
		private var _tileWidth:Number = 26;
		private var _tileHeight:Number = 13;
		
		private var _tiles:Vector.<Tile> = new Vector.<Tile>();
		private var _field:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
		
		public function Map() 
		{
			
		}
		
		override public function load(data:Object):void 
		{
			if (data.hasOwnProperty("offsetX"))
				_offsetX = data["offsetX"] as Number;
				
			if (data.hasOwnProperty("offsetY"))
				_offsetY = data["offsetY"] as Number;
				
			if (data.hasOwnProperty("tileWidth"))
				_tileWidth = data["tileWidth"] as Number;
				
			if (data.hasOwnProperty("tileHeight"))
				_tileHeight = data["tileHeight"] as Number;
				
			if (!data.hasOwnProperty("field"))
			{
				Log.add(formatString("{0}:: Error load data.", getQualifiedClassName(this)));
				return;
			}
			
			var rowsArray:Array = data["field"] as Array;
			if (rowsArray == null)
			{
				Log.add(formatString("{0}:: Error load data.", getQualifiedClassName(this)));
				return;
			}
			
			var rowsCount:int = rowsArray.length;
			var columnsCount:int = 0;
			var rowOffsetX:Number;
			var rowOffsetY:Number;
			var columnsArr:Array;
			var tile:Tile;
			var posX:Number;
			var posY:Number;
			for (var row:int = 0; row < rowsArray.length; row++)
			{
				columnsArr = rowsArray[row] as Array;
				if (columnsArr == null)
				{
					Log.add(formatString("{0}:: Error load data.", getQualifiedClassName(this)));
					return;
				}
				
				if (row == 0)
				{
					columnsCount = columnsArr.length;
				}
				else
				{
					if (columnsArr.length != columnsCount)
					{
						Log.add(formatString("{0}:: Error load data.", getQualifiedClassName(this)));
						return;
					}
				}
				
				rowOffsetX = _offsetX - _tileWidth * row / 2;
				rowOffsetY = _offsetY + _tileHeight * row / 2;
				
				_field.push(new Vector.<Tile>);
				
				for (var column:int = 0; column < columnsArr.length; column++)
				{
					posX = rowOffsetX + _tileWidth * column / 2;
					posY = rowOffsetY + _tileHeight * column / 2;
					
					tile = new Tile(row, column, posX, posY, columnsArr[column] as int);
					
					_tiles.push(tile);
					_field[row].push(tile);
				}
			}
		}
		
		public function get field():Vector.<Vector.<Tile>> 
		{
			return _field;
		}
		
	}

}