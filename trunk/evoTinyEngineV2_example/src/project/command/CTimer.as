package project.command
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class CTimer
	{
		private var timer:Timer;
		private var callback:Function;
		private var param:*;
		public function CTimer(delay:Number, callback:Function, param:* = null)
		{
			this.callback = callback;
			this.param = param;
			timer = new Timer(delay*1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, complete);
			timer.start();
		}
		private function complete(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, complete);
			timer = null;
			this.param ? callback(param) : callback();
			callback = null;
		}
	}
}