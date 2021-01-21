package game.data 
{
	import game.core.BaseObject;
	/**
	 * ...
	 * @author ...
	 */
	public class Creep extends BaseObject
	{
		public static const ORK:String = "ork";
		public static const GNOME:String = "gnome";
		
		public function Creep(type:String) 
		{
			_type = type;
		}
		
		private var _type:String = "gnome";
		public function get type():String 
		{
			return _type;
		}
		
	}

}