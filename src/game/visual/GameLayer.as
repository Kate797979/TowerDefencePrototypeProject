package game.visual 
{
	import flash.geom.Point;
	import game.data.levels.Level;
	import game.data.map.Map;
	import game.data.map.tile.Tile;
	import game.data.TowerInfo;
	import game.GameManager;
	import game.visual.creep.Creep;
	import game.visual.tower.BaseTower;
	import game.visual.tower.TowerStates;
	import game.visual.wave.Wave;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;
	/**
	 * ...
	 * @author K
	 */
	public class GameLayer extends Sprite 
	{
		private var _instance:GameLayer;
		
		private var _tilesMarksLayer:Sprite;
		private var _gameObjectsLayer:Sprite;
		private var _draggingTowerLayer:Sprite;
		
		private var _towersSeted:Vector.<BaseTower> = new Vector.<BaseTower>();
		
		public function GameLayer() 
		{
			/////////Формируем бэк сцены
			var mapTexture:Texture = VisualManager.getTexture("mapTexture");
			var mapImage:Image = new Image(mapTexture);
			
			addChild(mapImage);
			///////////////////
			
			_tilesMarksLayer = new Sprite();
			addChild(_tilesMarksLayer);
			
			_gameObjectsLayer = new Sprite();
			addChild(_gameObjectsLayer);
			
			_draggingTowerLayer = new Sprite();
			addChild(_draggingTowerLayer);
		
			_instance = this;
		}
		
		//{ Добавление башни
		
		private var _towerDragging:Boolean = false;
		private var _draggingTower:BaseTower;
		private var _draggingTowerInfo:TowerInfo;
		public function startDragTower(towerInfo:TowerInfo, mouseX:Number, mouseY:Number):void
		{
			_towerDragging = true;
			
			_draggingTowerInfo = towerInfo;
			
			var towerClass:Class = towerInfo.towerClass;
			_draggingTower = new towerClass(towerInfo, _currentLevel);
			
			_draggingTower.x = mouseX;
			_draggingTower.y = mouseY;
			
			_draggingTowerLayer.addChild(_draggingTower);
			
			addEventListener(TouchEvent.TOUCH, touchEventHandler);
		}
		
		private function touchEventHandler(e:TouchEvent):void 
		{
			if (_towerDragging)
			{
				var localMousePos:Point;
				var overTile:Tile;
				
				var targetDO:DisplayObject = e.target as DisplayObject;
				
				var hoverTouch:Touch = e.getTouch(targetDO, TouchPhase.HOVER);
				if (hoverTouch)
				{
					localMousePos = hoverTouch.getLocation(_instance);
					
					overTile = _currentLevel.map.getPixelsToTile(localMousePos.x, localMousePos.y);
					if (overTile == null)
					{
						_draggingTower.x = localMousePos.x;
						_draggingTower.y = localMousePos.y;
						
						_draggingTower.setState(TowerStates.WRONG_PLACE);
					}
					else
					{
						_draggingTower.x = overTile.posX;
						_draggingTower.y = overTile.posY;
						
						_draggingTower.setState(_draggingTower.canSetInTile(overTile) ?
							TowerStates.FIT_PLACE : TowerStates.WRONG_PLACE);
					}
				}
				
				var touch:Touch = e.getTouch(targetDO);
				
				if (touch && touch.phase == TouchPhase.ENDED)
				{
					if (targetDO.hitTest(touch.getLocation(targetDO)))//Убеждаемся, что отпустили кнопку над башней
					{
						localMousePos = touch.getLocation(_instance);
						overTile = _currentLevel.map.getPixelsToTile(localMousePos.x, localMousePos.y);
						
						if (overTile && _draggingTower.canSetInTile(overTile))
						{
							////////Добавляем башню на карту
							_gameObjectsLayer.addChild(_draggingTower);
							_towersSeted.push(_draggingTower);
							
							_draggingTower.setInTile(overTile);
							
							stopDragging();
							//////////////////////////////
						}
					}
				}
			}

		}
		
		private function stopDragging():void
		{
			removeEventListener(TouchEvent.TOUCH, touchEventHandler);
			
			_towerDragging = false;
			_draggingTowerInfo = null;
		}
		
		public function get towerDragging():Boolean 
		{
			return _towerDragging;
		}
		
		//}
		
		public function drawMap(map:Map):void
		{
			var mapRows:Vector.<Vector.<Tile>> = map.field;
			var columns:Vector.<Tile>;
			var tile:Tile;
			var color:uint;
			var tileMark:Quad;
			for (var row:int = 0; row < mapRows.length; row++)
			{
				columns = mapRows[row];
				for (var column:int = 0; column < columns.length; column++)
				{
					tile = columns[column];
					
					color = tile.type > 0 && tile.type < 4 ? Color.BLACK :
						tile.type == 4 ? Color.RED : Color.WHITE;
						
					tileMark = new Quad(4, 4, color);
					
					tileMark.alignPivot();
					
					tileMark.x = tile.posX;
					tileMark.y = tile.posY;
					
					_tilesMarksLayer.addChild(tileMark);
				}
			}
			
			_tilesMarksLayer.flatten();
		}
		
		public function update(deltaTime:Number):void
		{
			for each (var tower:BaseTower in _towersSeted)
			{
				tower.update(deltaTime);
			}
			
			_gameObjectsLayer.sortChildren(function (child1:DisplayObject, child2:DisplayObject):int
			{
				if (child1.y > child2.y)
					return 1;
					
				if (child1.y < child2.y)
					return -1;
					
				return 0;	
			});
		}
		
		private var _currentLevel:Level;
		public function set currentLevel(value:Level):void
		{
			_currentLevel = value;
		}
		
		public function clearAll():void
		{
			stopDragging();
			
			_towersSeted = new Vector.<BaseTower>();
			
			_tilesMarksLayer.removeChildren();
			_draggingTowerLayer.removeChildren();
			_gameObjectsLayer.removeChildren();
		}
		
		public function get tilesMarksLayer():Sprite 
		{
			return _tilesMarksLayer;
		}
		
		public function get gameObjectsLayer():Sprite 
		{
			return _gameObjectsLayer;
		}
		
	}

}