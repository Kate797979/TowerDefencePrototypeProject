package game.data.towers 
{
	import game.data.BaseObject;
	import game.data.Creep;
	/**
	 * ...
	 * @author ...
	 */
	public class BaseTower
	{
		private var _params:TowerInfo;
		
		public function BaseTower(params:TowerInfo) 
		{
			_params = params;
		}
		
		public function params():TowerInfo
		{
			get { return _params; }
		}
		
		public function apply(creep:Creep):void
		{
			
		}
	}

}