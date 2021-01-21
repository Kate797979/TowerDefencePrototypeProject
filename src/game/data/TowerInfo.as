package game.data 
{
	import flash.utils.getDefinitionByName;
	import game.core.BaseObject;
	import game.visual.tower.Tower_1;
	import game.visual.tower.Tower_2;
	import game.visual.tower.Tower_3;
	/**
	 * ...
	 * @author K
	 */
	public class TowerInfo extends BaseObject
	{
		
		public function TowerInfo() 
		{
			
		}
		
		public var type:String = "tower_1";
		
		public var name:String = "Tower 1";
		
		/**
		 * Урон (в том числе, и в скорости)
		 */
		public var damage:Number = 4;
		
		/**
		 * Время действия урона в секундах (0 - навсегда)
		 */
		public var damageTime:Number = 0;
		
		/**
		 * Тип урона (например, HP - урон в очках жизни, Speed (%) - замедление скорости врага)
		 */
		public var damageType:String = "HP";
		
		/**
		 * Радиус атаки (в тайлах)
		 */
		public var range:Number = 4;
		
		/**
		 * Скорострельность (выстрелв в секунду)
		 */
		public var fireRate:Number = 1.5;
		
		/**
		 * Стоимость
		 */
		public var cost:Number = 100;
		
		/**
		 * Имя класса, обеспечивающего работу данной башни.
		 */
		public var towerClassName:String = "Tower_1";
		
		private var _towerClass:Class;
		
		override public function load(data:Object):void 
		{
			super.load(data);
			
			_towerClass = getDefinitionByName("game.visual.tower::" + towerClassName) as Class;
		}
		
		public function get towerClass():Class 
		{
			return _towerClass;
		}
		
		private function initClasses():void
		{
			Tower_1;
			Tower_2;
			Tower_3;
		}

	}

}