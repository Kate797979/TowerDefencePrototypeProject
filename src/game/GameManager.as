package game 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import game.data.creeps.CreepInfo;
	import game.data.levels.Levels;
	import game.data.Player;
	import game.data.TowerInfo;
	import starling.utils.formatString;
	import utils.TextLoaderUtil;
	/**
	 * ...
	 * @author K
	 */
	public class GameManager 
	{
		private static var _showMapField:Boolean = false;
		
		private static var _player:Player = new Player();
		private static var _towers:Array = new Array();
		private static var _towersDict:Dictionary = new Dictionary();
		private static var _levels:Levels = new Levels();
		private static var _creepsInfos:Dictionary = new Dictionary();
		
		public function GameManager() 
		{
			
		}
		
		public static var gameWidth:Number = 800;
		public static var gameHeight:Number = 583;
		
		public static function init(onComplete:Function):void
		{
			TextLoaderUtil.loadJson("config.json", function (data:Object):void
			{
				//////Показывать ли условную сетку тайлов
				if (data.hasOwnProperty("showMapField"))
				{
					_showMapField = data["showMapField"] as Boolean;
				}
				/////////////////////////
				
				//////////Загружаем информацию о крипах (параметры для визуализации)
				if (data.hasOwnProperty("creeps"))
				{
					var creepsArr:Array = data["creeps"] as Array;
					if (creepsArr)
					{
						var creepInfo:CreepInfo;
						for each (var creepObj:Object in creepsArr)
						{
							creepInfo = new CreepInfo();
							creepInfo.load(creepObj);
							
							_creepsInfos[creepInfo.type] = creepInfo;
						}
					}
				}
				/////////////////////////
				
				/////Загружаем информацию о башнях
				var towersArr:Object = data["towers"];
				if (towersArr == null)
				{
					Log.add(formatString("{0}:: Error! Information about towers not found", getQualifiedClassName(this)));
				}
				else
				{
					for each (var towerObj:Object in towersArr)
					{
						var tInfo:TowerInfo = new TowerInfo();
						tInfo.load(towerObj);
						
						_towers.push(tInfo);
						_towersDict[tInfo.type] = tInfo;
					}
				}
				////////////////////////////
				
				////////Загружаем информацию об уровнях
				var levelsObj:Object = data["levels"];
				if (levelsObj == null)
				{
					Log.add(formatString("{0}:: Error! Information about levels not found", getQualifiedClassName(this)));
				}
				else
				{
					_levels.load(levelsObj);
				}
				//////////////////////////////
				
				////////Загружаем информацию игрока 
				var playerObj:Object = data["playerInitialData"];
				if (playerObj == null)
				{
					Log.add(formatString("{0}:: Error! Information about player not found", getQualifiedClassName(this)));
				}
				else
				{
					_player.load(playerObj);
				}
				///////////////////////////////////
				
				if (onComplete != null)
					onComplete();
			});
		}
		
		static public function get player():Player 
		{
			return _player;
		}
		
		static public function get levels():Levels 
		{
			return _levels;
		}
		
		static public function get towers():Array 
		{
			return _towers;
		}
		
		static public function get showMapField():Boolean 
		{
			return _showMapField;
		}
		
		static public function get creepsInfos():Dictionary 
		{
			return _creepsInfos;
		}
		
		static public function resetGame():void
		{
			_player.reset();
			_levels.currentLevel.reset();
		}
		
	}

}