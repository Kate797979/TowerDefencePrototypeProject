package game.visual.tower 
{
	/**
	 * Визуальные состояния башни
	 * @author  K
	 */
	public class TowerStates 
	{
		/**
		 * Обычное состояние башни
		 */
		public static const DEFAULT:String = "default";
		
		/**
		 * Состояние, когда курсор с башней находится над позицией, куда башню ставить нельзя
		 */
		public static const WRONG_PLACE:String = "wrong_place";
		
		/**
		 * Состояние, когда курсор с башней находится над позицией, куда башню ставить можно
		 */
		public static const FIT_PLACE:String = "fit_place";
	}

}