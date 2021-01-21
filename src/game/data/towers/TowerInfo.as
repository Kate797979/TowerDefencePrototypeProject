package game.data.towers 
{
	import game.core.BaseObject;
	/**
	 * ...
	 * @author 
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
		 * Радиус атаки
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
		 * Ссылка на класс, обеспечивающий работу данной башни.
		 */
		public var towerClass:String = "Tower_1";
		
		public var texturePivotX:Number = 0;
		
		public var texturePivotY:Number = 0;

	}

}