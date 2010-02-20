package evoTinyEngine.event
{
	import flash.events.Event;

	public class TinyEngineEvent extends Event
	{
		public static const EVENT_DISPOSED		:String = "event_disposed";
		public static const EVENT_INITIALIZED	:String = "event_initialized";
		
		public var modifierList:Array;
		public function TinyEngineEvent(modifierList:Array, type:String, bubles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubles, cancelable);
			this.modifierList = modifierList;
		}
	}
}