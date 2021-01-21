package game.data 
{
	import game.core.BaseObject;
	/**
	 * ...
	 * @author K
	 */
	public class WaveInfo extends BaseObject
	{
		
		public function WaveInfo() 
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
		 * Скорость перемещения крипа (тайлов в секунду)
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
		
	}

}