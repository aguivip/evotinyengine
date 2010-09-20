package evoTinyEngine.event
{
	import evoTinyEngine.data.RenderData;
	
	import flash.events.Event;

	public class RenderDataEvent extends Event
	{
		public static const EVENT_RENDERED		:String = "event_rendered";
		
		public var data:RenderData;
		public function RenderDataEvent(data:RenderData, type:String, bubles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubles, cancelable);
			this.data = data;
		}
	}
}
