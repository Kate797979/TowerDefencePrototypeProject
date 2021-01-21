package game.core.animation 
{
	
	/**
	 * ...
	 * @author K
	 */
	public interface IBaseAnimation 
	{
		function play(onComplete:Function = null):void;
		function stop():void
		function pause():void;
		function resume():void;
		function setState(key:String, onComplete:Function = null, ... params):void;
		function get currentState():String;
		function get playing():Boolean;
		function get paused():Boolean;
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function release():void;
		function update(dt:Number = 0):void;
	}
	
}