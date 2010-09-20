package project.command
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class CDelayedDispatch
	{
		private var target:EventDispatcher;
		private var event_type:String;
		private var timer:Timer;
		public function CDelayedDispatch(target:EventDispatcher, event_type:String, delay:Number)
		{
			this.target = target;
			this.event_type = event_type;
			
			timer = new Timer(delay*1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, complete);
			timer.start();
		}
		private function complete(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, complete);
			timer = null;
			target.dispatchEvent(new Event(this.event_type));
		}
	}
}