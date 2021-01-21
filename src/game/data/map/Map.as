package game.data.map 
{
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import game.core.BaseObject;
	import starling.utils.formatString;
	import utils.MathUtil;
	/**
	 * ...
	 * @author K
	 */
	public class Map extends BaseObject
	{
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		
		private var _tileWidth:Number = 26;
		private var _tileHeight:Number = 13;
		
		/**
		 * Длина грани тайла в изометрической проекции
		 */
		private var _tileSize:Number = 0;
		
		private var _rowsCount:int;
		private var _columnsCount:int;
		
		private var _field:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
		
		private var _startTile:Tile;
		
		public function Map() 
		{
			
		}
		
		override public function load(data:Object):void 
		{
			_loadedData = data;
			
			//Центр первого тайла 
			if (data.hasOwnProperty("offsetX"))
				_offsetX = data["offsetX"] as Number;
				
			if (data.hasOwnProperty("offsetY"))
				_offsetY = data["offsetY"] as Number;
			////////////////
				
			if (data.hasOwnProperty("tileWidth"))
				_tileWidth = data["tileWidth"] as Number;
				
			if (data.hasOwnProperty("tileHeight"))
				_tileHeight = data["tileHeight"] as Number;
				
			_tileSize = Math.sqrt(_tileWidth * _tileWidth + _tileHeight * _tileHeight) / 2;
				
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
			
			_rowsCount = rowsArray.length;
			_columnsCount = 0;
			var rowOffsetX:Number;
			var rowOffsetY:Number;
			var columnsArr:Array;
			var tile:Tile;
			var posX:Number;
			var posY:Number;
			var type:int;
			var row:int;
			var column:int;
			var tiles:Vector.<Tile> = new Vector.<Tile>();
			for (row = 0; row < rowsArray.length; row++)
			{
				columnsArr = rowsArray[row] as Array;
				if (columnsArr == null)
				{
					Log.add(formatString("{0}:: Error load data.", getQualifiedClassName(this)));
					return;
				}
				
				if (row == 0)
				{
					_columnsCount = columnsArr.length;
				}
				else
				{
					if (columnsArr.length != _columnsCount)
					{
						Log.add(formatString("{0}:: Error load data.", getQualifiedClassName(this)));
						return;
					}
				}
				
				rowOffsetX = _offsetX - _tileWidth * row / 2;
				rowOffsetY = _offsetY + _tileHeight * row / 2;
				
				_field.push(new Vector.<Tile>);
				
				for (column = 0; column < columnsArr.length; column++)
				{
					posX = rowOffsetX + _tileWidth * column / 2;
					posY = rowOffsetY + _tileHeight * column / 2;
					
					type = columnsArr[column] as int;
					tile = new Tile(row, column, posX, posY, type);
					
					tiles.push(tile);
					_field[row].push(tile);
					
					if (type == TileType.START_PATH)
					{
						if (_startTile == null)
						{
							_startTile = tile;
						}
						else
						{
							Log.add(formatString("{0}:: Error load data. More then one start tile was found.", getQualifiedClassName(this)));
						}
					}
				}
			}
			
			if (_startTile == null)
			{
				Log.add(formatString("{0}:: Error load data. No one start tile was found.", getQualifiedClassName(this)));
			}
			
			////Для каждого тайла формируем список соседних тайлов
			for each (tile in tiles)
			{
				row = tile.row;
				column = tile.column;
				
				if (column > 0)
					tile.neighborTiles.push(new NeighborTile(_field[row][column - 1], Direction.TOP_LEFT));
					
				if (column < _columnsCount - 1)
					tile.neighborTiles.push(new NeighborTile(_field[row][column + 1], Direction.DOWN_RIGHT));
				
				if (row > 0)
				{
					tile.neighborTiles.push(new NeighborTile(_field[row - 1][column], Direction.TOP_RIGHT));
					
					if (column > 0)
						tile.neighborTiles.push(new NeighborTile(_field[row - 1][column - 1], Direction.TOP));
						
					if (column < _columnsCount - 1)
						tile.neighborTiles.push(new NeighborTile(_field[row - 1][column + 1], Direction.RIGHT));
				}
				
				if (row < _rowsCount - 1)
				{
					tile.neighborTiles.push(new NeighborTile(_field[row + 1][column], Direction.DOWN_LEFT));
					
					if (column > 0)
						tile.neighborTiles.push(new NeighborTile(_field[row + 1][column - 1], Direction.LEFT));
						
					if (column < _columnsCount - 1)
						tile.neighborTiles.push(new NeighborTile(_field[row + 1][column + 1], Direction.DOWN));
				}
				
			}
			//////////////////////////
		}
		
		public function get field():Vector.<Vector.<Tile>> 
		{
			return _field;
		}
		
		public function get startTile():Tile 
		{
			return _startTile;
		}
		
		/**
		 * Длина грани тайла в изометрической проекции
		 */
		public function get tileSize():Number 
		{
			return _tileSize;
		}
		
		public function get tileWidth():Number 
		{
			return _tileWidth;
		}
		
		public function get tileHeight():Number 
		{
			return _tileHeight;
		}
		
		public function get rowsCount():int 
		{
			return _rowsCount;
		}
		
		public function get columnsCount():int 
		{
			return _columnsCount;
		}
		
		public function get offsetX():Number 
		{
			return _offsetX;
		}
		
		public function get offsetY():Number 
		{
			return _offsetY;
		}
		
		/**
		 * Список тайлов пути в порядке следования 
		 */
		public function get pathTiles():Vector.<Tile> 
		{
			return _pathTiles;
		}
		
		private var _pathTiles:Vector.<Tile>;
		private var _creepPathPartsArray:Vector.<CreepPathOneDirectionPart>;
		public function getCreepPathParts():Vector.<CreepPathOneDirectionPart>
		{
			if (_creepPathPartsArray != null)
				return _creepPathPartsArray;
				
			_creepPathPartsArray = new Vector.<CreepPathOneDirectionPart>();
			
			if (_startTile)
			{
				var creepPathPart:CreepPathOneDirectionPart;
				var currentDirection:String;
				var firstTile:Tile;
				var lastTile:Tile;
				
				firstTile = _startTile;
				
				_pathTiles = new Vector.<Tile>();
				var directions:Vector.<String> = new Vector.<String>();
				
				getPathNextTiles(_startTile, null, _pathTiles, directions);
				
				var direction:String;
				for (var i:int = 0; i < directions.length; i++)
				{
					direction = directions[i];
					if (currentDirection == null)
					{
						currentDirection = direction;
						lastTile = _pathTiles[i];
						
						continue;
					}
					else
					{
						if (currentDirection != direction)
						{
							creepPathPart = new CreepPathOneDirectionPart(currentDirection, firstTile.posX, firstTile.posY, 
								lastTile.posX, lastTile.posY, MathUtil.getDistance(firstTile.posX, firstTile.posY, lastTile.posX, lastTile.posY));
							_creepPathPartsArray.push(creepPathPart);
							
							firstTile = lastTile;
							lastTile = _pathTiles[i];
							currentDirection = direction;
							
							continue;
						}
						else
						{
							lastTile = _pathTiles[i];
							
							continue;
						}
					}
				}
				///Финальная часть
				creepPathPart = new CreepPathOneDirectionPart(currentDirection, firstTile.posX, firstTile.posY, 
					lastTile.posX, lastTile.posY, MathUtil.getDistance(firstTile.posX, firstTile.posY, lastTile.posX, lastTile.posY));
				_creepPathPartsArray.push(creepPathPart);
			}
			
			return _creepPathPartsArray;
		}
		
		private function getPathNextTiles(currentTile:Tile, previousTile:Tile, pathTiles:Vector.<Tile>, directions:Vector.<String>):void
		{
			var neighborTile:NeighborTile;
			for each (neighborTile in currentTile.neighborTiles)
			{
				if ((neighborTile.tile.type == TileType.PATH || neighborTile.tile.type == TileType.END_PATH)
					&& neighborTile.tile != previousTile)
				{
					pathTiles.push(neighborTile.tile);
					directions.push(neighborTile.direction);
					
					getPathNextTiles(neighborTile.tile, currentTile, pathTiles, directions);
					
					break;
				}
			}
			
		}
		
		public function getTopLeftCorner():Point
		{
			return new Point(_offsetX, _offsetY - _tileHeight / 2);
		}
		
		public function getPixelsToTile(x:Number, y:Number):Tile
		{
			var mapOffsetX:Number = _offsetX;
			var mapOffsetY:Number = _offsetY - _tileHeight / 2;
			
			var row:int = Math.floor(( mapOffsetX - x) / _tileWidth + (y - mapOffsetY) / _tileHeight);
			var column:int = Math.floor((x - mapOffsetX) / _tileWidth + (y - mapOffsetY) / _tileHeight);
			
			if (row >= 0 && row < _rowsCount && column >= 0 && column < _columnsCount)
			{
				return _field[row][column];
			}
			
			return null;
		}
		
		override public function reset():void 
		{
			_field = new Vector.<Vector.<Tile>>();
			
			super.reset();
		}
		
	}

}