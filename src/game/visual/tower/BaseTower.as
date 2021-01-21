package game.visual.tower 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import game.data.levels.Level;
	import game.data.map.Map;
	import game.data.map.Tile;
	import game.data.map.tile.Tile;
	import game.data.map.tile.TileType;
	import game.data.TowerInfo;
	import game.GameManager;
	import game.visual.creep.Creep;
	import game.visual.creep.CreepStates;
	import game.visual.VisualManager;
	import game.visual.wave.Wave;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	import starling.utils.Color;
	import utils.MathUtil;
	/**
	 * ...
	 * @author  K
	 */
	public class BaseTower extends Sprite
	{
		protected var _towerInfo:TowerInfo;
		protected var _level:Level;
		
		private var _defaultStateImage:Image;
		private var _wrongStateImage:Image;
		private var _fitStateImage:Image;
		private var _bottomMarker:Sprite;
		private var _fireRangeImage:Image;
		
		private var _currentState:String;
		
		private var _realSizeInTiles:Number;
		protected var _sizeInTiles:int;
		
		protected var _fireRadius:Number;
		
		/**
		 * Интервал между выстрелами (в секунду)
		 */
		private var _fireInterval:Number = 0;
		
		public function BaseTower(towerInfo:TowerInfo, level:Level) 
		{
			_towerInfo = towerInfo;
			_level = level;
			
			_fireInterval = 1 / _towerInfo.fireRate;
			
			_defaultStateImage = createStateImage(TowerStates.DEFAULT);
			
			_fireRadius = ((_sizeInTiles + _towerInfo.range * 2) * _level.map.tileWidth / Math.sqrt(2)) / 2;
			
			_bottomMarker = createBottomMarker();
			_fireRangeImage = createFireRangeImage();			
			_fitStateImage = createStateImage(TowerStates.FIT_PLACE);
			_wrongStateImage = createStateImage(TowerStates.WRONG_PLACE);
			
			setState(TowerStates.DEFAULT);
		}
		
		private function createStateImage(state:String):Image
		{
			var towerTextureId:String = _towerInfo.type + "_texture";
			
			var tTexture:Texture = VisualManager.getTexture(towerTextureId);
			
			var resultImage:Image = new Image(tTexture);
			
			if (isNaN(_realSizeInTiles))
			{
				_realSizeInTiles = resultImage.width / _level.map.tileWidth;
				_sizeInTiles = int(Math.ceil(_realSizeInTiles));
			}
			
			resultImage.pivotX = resultImage.width >> 1;
			resultImage.pivotY = resultImage.height - _realSizeInTiles * _level.map.tileHeight / 2;
			
			if (state != TowerStates.DEFAULT)
			{
				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
				colorFilter.tint(state == TowerStates.FIT_PLACE ? Color.GREEN : Color.RED, 0.75);
				
				resultImage.filter = colorFilter;
				resultImage.alpha = 0.75;
			}
			
			addChild(resultImage);
			
			return resultImage;
		}
		
		private function createBottomMarker():Sprite
		{
			var bottomMarker:Sprite = new Sprite();
			
			///////////////// Рисуем маркер дна башни
			var bottomMarkerQuadBatch:QuadBatch = new QuadBatch();
			
			var edgeWidth:Number = 4;
			var color:uint = Color.GRAY;
			
			var size:Number = _sizeInTiles * _level.map.tileWidth / Math.sqrt(2);
			
			var leftEdgeQuad:Quad = new Quad(edgeWidth, size, color);
			bottomMarkerQuadBatch.addQuad(leftEdgeQuad);
			
			var bottomEdgeQuad:Quad = new Quad(size, edgeWidth, color);
			bottomEdgeQuad.y = size - edgeWidth;
			bottomMarkerQuadBatch.addQuad(bottomEdgeQuad);
			
			var topEdgeQuad:Quad = new Quad(size, edgeWidth, color);
			bottomMarkerQuadBatch.addQuad(topEdgeQuad);
			
			var rightEdgeQuad:Quad = new Quad(edgeWidth, size, color);
			rightEdgeQuad.x = size - edgeWidth;
			bottomMarkerQuadBatch.addQuad(rightEdgeQuad);

			bottomMarkerQuadBatch.alignPivot();
			bottomMarkerQuadBatch.rotation = Math.PI / 4;
			
			bottomMarker.addChild(bottomMarkerQuadBatch);
			bottomMarker.height = bottomMarkerQuadBatch.height / 2;
			
			addChild(bottomMarker);

			return bottomMarker;
		}
		
		private function createShotLine():Image
		{
			var tTexture:Texture = VisualManager.getTexture("fireLineTexture");
			
			var fireLineImage:Image = new Image(tTexture);
			
			fireLineImage.alignPivot("left", "center");
			
			fireLineImage.x = 0;
			fireLineImage.y = -_defaultStateImage.pivotY + 20;
			
			return fireLineImage;
		}
		
		private function createFireRangeImage():Image
		{
			var fireRangeImage:Image = getIsoCircle(_fireRadius, Color.RED);
			addChildAt(fireRangeImage, 0);
			
			return fireRangeImage;
		}
		
		private function getIsoCircle(radius:Number, color:uint):Image
		{
			//////Изврат, т.к. не знаю, как по другому нарисовать окружность
			var circleShape:Shape = new Shape();
			circleShape.graphics.lineStyle(4, color);
			circleShape.graphics.drawCircle(radius, radius, radius - 2);

			var bmpData:BitmapData = new BitmapData(radius * 2, radius * 2);
			bmpData.draw(circleShape);
			
			var bmpData1:BitmapData = new BitmapData(radius * 2, radius * 2);
			bmpData1.threshold(bmpData, bmpData1.rect, new Point(0, 0), "!=", color, 0, 0x00FFFFFF, true);

			var circleImage:Image = Image.fromBitmap(new Bitmap(bmpData1, "auto", true));
			circleImage.alignPivot();
			circleImage.height = circleImage.height / 2;
			
			return circleImage;
		}
		
		public function setState(state:String):void
		{
			if (_currentState != state)
			{
				unflatten();
				
				_currentState = state;
				
				_defaultStateImage.visible = state == TowerStates.DEFAULT;
				_fitStateImage.visible = state == TowerStates.FIT_PLACE;
				_wrongStateImage.visible = state == TowerStates.WRONG_PLACE;
				
				_bottomMarker.visible = state != TowerStates.DEFAULT && GameManager.showMapField;
				_fireRangeImage.visible = state == TowerStates.FIT_PLACE;
				
				if (state != TowerStates.DEFAULT)
					flatten();
			}
		}
		
		public function canSetInTile(tile:Tile):Boolean
		{
			var map:Map = _level.map;
			
			var delta:int = Math.floor(_sizeInTiles / 2);
			
			var rowStartIndex:int = tile.row - delta;
			if (rowStartIndex < 0 || rowStartIndex >= map.rowsCount)
				return false;
				
			var rowEndIndex:int = tile.row + delta;
			if (rowStartIndex < 0 || rowEndIndex >= map.rowsCount)
				return false;
				
			var columnStartIndex:int = tile.column - delta;
			if (columnStartIndex < 0 || columnStartIndex >= map.columnsCount)
				return false;
				
			var columnEndIndex:int = tile.column + delta;
			if (columnEndIndex < 0 || columnEndIndex >= map.columnsCount)
				return false;
				
			rowStartIndex = Math.max(0, rowStartIndex - 1);
			rowEndIndex = Math.min(rowEndIndex + 1, map.rowsCount - 1);
			columnStartIndex = Math.max(0, columnStartIndex - 1);
			columnEndIndex = Math.min(columnEndIndex + 1, map.columnsCount - 1);
			
			var checkTile:Tile;
			for (var row:int = rowStartIndex; row <= rowEndIndex; row++)
			{
				for (var column:int = columnStartIndex; column <= columnEndIndex; column++)
				{
					checkTile = map.field[row][column];
					if (checkTile.type != TileType.EMPTY)
						return false;
				}
			}
				
			return true;
		}
		
		public function setInTile(tile:Tile):void
		{
			var map:Map = _level.map;
			
			var delta:int = Math.floor(_sizeInTiles / 2);
			
			var rowStartIndex:int = tile.row - delta;
			var rowEndIndex:int = tile.row + delta;
				
			var columnStartIndex:int = tile.column - delta;
			var columnEndIndex:int = tile.column + delta;
			
			var setTile:Tile;
			for (var row:int = rowStartIndex; row <= rowEndIndex; row++)
			{
				for (var column:int = columnStartIndex; column <= columnEndIndex; column++)
				{
					setTile = map.field[row][column];
					setTile.type = TileType.FILLED_BY_TOWER;
				}
			}
			
			setState(TowerStates.DEFAULT);
			
			_defaultStateImage.addEventListener(TouchEvent.TOUCH, touchEventHandler);
		}
		
		private var _overActivated:Boolean = false;
		private function touchEventHandler(e:TouchEvent):void 
		{
			var targetDO:DisplayObject = e.target as DisplayObject;
			
			var hoverTouch:Touch = e.getTouch(targetDO, TouchPhase.HOVER);
			if (hoverTouch)
			{
				if (!_overActivated)
				{
					_overActivated = true;
					
					_fireRangeImage.visible = true;
				}
			}
			else
			{
				if (_overActivated)
				{
					_overActivated = false;
					
					_fireRangeImage.visible = false;
				}
			}

		}
		
		protected function fire(creep:Creep, onBlow:Function, onComplete:Function = null):void
		{
			var blowPos:Point = creep.localToGlobal(new Point(creep.blowX, creep.blowY));
			blowPos = globalToLocal(blowPos);
			
			var fireLine:Image = createShotLine();
			fireLine.width = 2;
			addChild(fireLine);
			
			var tweenObject:Object = { "width":2 };
			var fireTween:Tween = new Tween(tweenObject, 0.2);
			var distance:Number = MathUtil.getDistance(blowPos.x, blowPos.y, fireLine.x, fireLine.y);
			fireTween.animate("width", distance);
				
			var rotation:Number = Math.atan2(blowPos.y - fireLine.y, blowPos.x - fireLine.x);
			fireTween.onUpdate = function ():void
			{
				fireLine.rotation = 0;
				fireLine.width = tweenObject.width;
				fireLine.rotation = rotation;
			};
			fireTween.onComplete = function ():void
			{
				if (onBlow != null)
					onBlow(creep);
					
				fireTween.reset(fireLine, 0.1);	
				fireTween.animate("alpha", 0);
				fireTween.onComplete = function ():void
				{
					fireLine.removeFromParent();

					if (onComplete != null)
						onComplete();
				};
				
				Starling.juggler.add(fireTween);
			};
			Starling.juggler.add(fireTween);
		}
		
		protected var _deltaTime:Number = 0;
		public function update(deltaTime:Number):void
		{
			_deltaTime += deltaTime;
			if (_deltaTime >= _fireInterval)
			{
				_deltaTime -= _fireInterval;
				
				apply();
			}
		}
		
		protected function apply():void
		{
			
		}
		
		private var _transformationMatrix:Matrix;
		protected function isCreepInFireRange(creep:Creep):Boolean
		{
			if (_transformationMatrix == null)
			{
				_transformationMatrix = new Matrix();
				
				var mapOffset:Point = _level.map.getTopLeftCorner();
				_transformationMatrix.translate(mapOffset.x, mapOffset.y);
				_transformationMatrix.rotate(Math.PI / 2);
				
				var matrix2:Matrix = new Matrix();
				matrix2.scale(1, 1 / 2);
				
				_transformationMatrix.concat(matrix2);
				_transformationMatrix.invert();
			}
			
			var creepPos:Point = _transformationMatrix.transformPoint(new Point(creep.x, creep.y));
			var towerPos:Point = _transformationMatrix.transformPoint(new Point(x, y));
			
			return MathUtil.getDistance(towerPos.x, towerPos.y, creepPos.x, creepPos.y) <= _fireRadius;
		}
		
		protected function getCreepsInFireRange():Vector.<Creep>
		{
			var activeWaves:Vector.<Wave> = _level.waves.activeWaves;
			var creepsInFireRange:Vector.<Creep> = new Vector.<Creep>();
			
			for each (var wave:Wave in activeWaves)
			{
				for each (var creep:Creep in wave.creeps)
				{
					if (creep.state == CreepStates.MOVING)
					{
						if (isCreepInFireRange(creep))
							creepsInFireRange.push(creep);
					}
				}
			}
			
			return creepsInFireRange;
		}
		
		protected function getForwardCreep(creeps:Vector.<Creep>):Creep
		{
			if (creeps.length > 0)
			{
				var map:Map = _level.map;
				var pathTiles:Vector.<Tile> = map.pathTiles;
				var forwardCreep:Creep = creeps[0];
				var creepTile:Tile = map.getPixelsToTile(forwardCreep.x, forwardCreep.y);
				var forwardIndexInPath:int = pathTiles.indexOf(creepTile);
				
				var creep:Creep;
				var indexInPath:int;
				for (var i:int = 1; i < creeps.length; i++)
				{
					creep = creeps[i];
					creepTile = map.getPixelsToTile(creep.x, creep.y);
					indexInPath = pathTiles.indexOf(creepTile);
					if (indexInPath > forwardIndexInPath)
					{
						forwardIndexInPath = indexInPath;
						forwardCreep = creep;
					}
				}
				
				return forwardCreep;
				//return creeps[0];/////////!!!!!!!!!!!!!!!!////Определяем, кто ближе всего к выходу (вычислить тайл, использовать массив тропинки, минимальный индекс)
			}
			
			return null;
		}
		
		public function get towerInfo():TowerInfo
		{
			return _towerInfo;
		}
		
		public function get level():Level 
		{
			return _level;
		}
		
		public function get sizeInTiles():int 
		{
			return _sizeInTiles;
		}
	}

}