package game.map 
{
	/**
	 * ...
	 * @author ...
	 */
	public class TileType 
	{
		/**
		 * Пустой тайл
		 */
		public static const EMPTY:int = 0;
		
		/**
		 * Тайл, с которого начинается дорожка, по которой идут орки
		 */
		public static const START_PATH:int = 1;
		
		/**
		 * Тайл, по которому идут орки (часть дорожки)
		 */
		public static const PATH:int = 2;
		
		/**
		 * Последний тайл (конец дорожки)
		 */
		public static const END_PATH:int = 3;
		
		/**
		 * Тайл, который занят каким-то объектом (не башней), т.е. в него нельзя поместить башню
		 */
		public static const FILLED:int = 4;
		
		/**
		 * Тайл, занятый башней (частью башни, т.к. башня занимает несколько тайлов)
		 */
		public static const FILLED_BY_TOWER:int = 5;
		
	}

}