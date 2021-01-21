package game.data 
{
	import game.core.BaseObject;
	import game.visual.creep.Creep;
	/**
	 * ...
	 * @author ...
	 */
	public class Wave extends BaseObject
	{
		
		public function Wave() 
		{
			
		}
		
		/**
		 * Количество крипов в волне
		 */
		public var creepsCount:int = 5;
		
		/**
		 * Количество очков жизни крипа
		 */
		public var creepHP:int = 10;
		
		/**
		 * Скорость перемещения крипа (в тайлах)
		 */
		public var creepSpeed:Number = 2;
		
		/**
		 * Расстояние между крипами (в тайлах) 
		 */
		public var creepDistance:Number = 2;
		
		/**
		 * Награда за крипа
		 */
		public var creepReward:int = 0;
		
		/**
		 * Тип крипа (для визуализации)
		 */
		public var creepType:String = "ork";
		
		/**
		 * Временной интервал в секундах, через который запускается волна, после запуска предыдущей волны
		 */
		public var previousWaveInterval:int = 10;
		
		private var _creeps:Vector.<Creep> = new Vector.<Creep>();
		public function get creeps():Vector.<Creep> 
		{
			return _creeps;
		}
		
	}

}