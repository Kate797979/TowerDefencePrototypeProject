package game.visual.tower 
{
	import game.data.levels.Level;
	import game.data.TowerInfo;
	import game.visual.creep.Creep;
	/**
	 * ...
	 * @author  K
	 */
	public class Tower_3 extends BaseTower
	{
		
		public function Tower_3(towerInfo:TowerInfo, level:Level) 
		{
			super(towerInfo, level);
		}
		
		override protected function apply():void 
		{
			var creepsInFireRange:Vector.<Creep> = getCreepsInFireRange();
			var notFrozenCreeps:Vector.<Creep> = new Vector.<Creep>();
			for each (var creep:Creep in creepsInFireRange)
			{
				if (!creep.frozen)
					notFrozenCreeps.push(creep);
			}
			var forwardCreep:Creep = getForwardCreep(notFrozenCreeps);
			if (forwardCreep)
			{
				fire(forwardCreep, function (forwardCreep:Creep):void
				{
					forwardCreep.freez(_towerInfo.damage, _towerInfo.damageTime);
				});
			}
		}
	}

}