package game.visual.creep 
{
	import game.core.animation.BaseMovieClipAnimation;
	import game.data.creeps.CreepInfo;
	import game.visual.VisualManager;
	import starling.utils.formatString;
	/**
	 * ...
	 * @author K
	 */
	public class CreepAnimation extends BaseMovieClipAnimation
	{
		private var _creepInfo:CreepInfo;
		
		public function CreepAnimation(creepInfo:CreepInfo, x:Number = 0, y:Number = 0, scale:Number = 1, fps:Number = 12)
		{
			super(x, y, scale, fps);
			
			_creepInfo = creepInfo;
		}
		
		override public function setState(key:String, onComplete:Function = null, ...params):void 
		{
			if (_currentState != key)
			{
				releaseMovieClip();
				
				super.setState(key, onComplete);
				
				_mClip = VisualManager.gerCreepAnimation(_creepInfo.type, key, _fps, false, false, true, _scale);
				
				_mClip.pivotX = _creepInfo.pivotX;
				_mClip.pivotY = _creepInfo.pivotY;
				
				addChild(_mClip);
				
				play();
			}
			
		}
		
	}

}