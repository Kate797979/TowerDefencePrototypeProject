package game.visual.tower 
{
	import game.data.levels.Level;
	import game.data.TowerInfo;
	import game.visual.creep.Creep;
	/**
	 * Атакует одну цель, выбирает находящуюся ближе всего к выходу.
	 * @author  K
	 */
	public class Tower_1 extends BaseTower
	{
		
		public function Tower_1(towerInfo:TowerInfo, level:Level) 
		{
			super(towerInfo, level);
		}
		
		override protected function apply():void 
		{
			var creepsInFireRange:Vector.<Creep> = getCreepsInFireRange();
			var forwardCreep:Creep = getForwardCreep(creepsInFireRange);
			if (forwardCreep)
			{
				fire(forwardCreep, function (forwardCreep:Creep):void
				{
					forwardCreep.HP -= _towerInfo.damage;
				});
			}
		}
		
	}

}