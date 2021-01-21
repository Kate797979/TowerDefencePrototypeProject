package game.data 
{
	import flash.utils.getQualifiedClassName;
	import game.core.BaseObject;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author ...
	 */
	public class Levels extends BaseObject
	{
		private var _levels:Vector.<Level> = new Vector.<Level>();
		
		private var _currentLevel:Level;
		
		public function Levels() 
		{
			
		}
		
		override public function load(data:Object):void 
		{
			var levelsArr:Array = data as Array;
			if (levelsArr == null)
			{
				Log.add(formatString("{0}:: Error load data.", getQualifiedClassName(this)));
				return;
			}
			
			for (var i:int = 0; i < levelsArr.length; i++)
			{
				var levelObj:Object = levelsArr[i];
				
				var level:Level = new Level();
				level.load(levelObj);
				level.id = i + 1;
				
				_levels.push(level);
			}

		}
		
		public function getNextLevel(level:Level = null):Level
		{
			if (level == null)
			{
				if (_levels.length > 0)
					return _levels[0];
			}
			else
			{
				var lIndex:int = _levels.indexOf(level);
				if (lIndex >= 0 && lIndex < _levels.length - 1)
					return _levels[lIndex + 1];
			}
			
			return null;
		}
		
		public function get currentLevel():Level 
		{
			return _currentLevel;
		}
		
		public function set currentLevel(value:Level):void 
		{
			_currentLevel = value;
		}
	}

}