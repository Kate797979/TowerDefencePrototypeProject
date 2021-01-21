package game.data.creeps 
{
	import game.core.BaseObject;
	/**
	 * ...
	 * @author K
	 */
	public class CreepInfo extends BaseObject
	{
		public function CreepInfo() 
		{
			
		}
		
		/**
		 * Тип крипа (перечисление CreepTypes)
		 */
		public var type:String = "gnome";
		
		/**
		 * Пивот X для анимации
		 */
		public var pivotX:Number = 0;
		
		/**
		 * Пивот Y для анимации
		 */
		public var pivotY:Number = 0;
		
		/**
		 * Позиция X для текстового поля с информацией об HP крипа 
		 */
		public var textX:Number = 0;
		
		/**
		 * Позиция Y для текстового поля с информацией об HP крипа 
		 */
		public var textY:Number = 0;
		
	}

}