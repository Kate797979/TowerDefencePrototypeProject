package game.visual.tower 
{
	import game.data.levels.Level;
	import game.data.TowerInfo;
	import game.visual.creep.Creep;
	/**
	 * Наносит одинаковый урон всем целям в радиусе атаки
	 * @author K
	 */
	public class Tower_2 extends BaseTower
	{
		
		public function Tower_2(towerInfo:TowerInfo, level:Level) 
		{
			super(towerInfo, level);
		}

		override protected function apply():void 
		{
			var creepsInFireRange:Vector.<Creep> = getCreepsInFireRange();
			if (creepsInFireRange.length > 0)
			{
				for each (var creep:Creep in creepsInFireRange)
				{
					fire(creep, function (blownCreep:Creep):void
					{
						blownCreep.HP -= _towerInfo.damage;
					});
				}
			}
		}
		
		
		
	}

}