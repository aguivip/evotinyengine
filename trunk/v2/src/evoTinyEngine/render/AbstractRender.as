package evoTinyEngine.render
{
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.data.SequenceData;
	import evoTinyEngine.modifier.IModifier;
	import evoTinyEngine.sound.sync.SoundSynchroniser;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.media.SoundChannel;

	public class AbstractRender
	{
		public var sequenceData			:SequenceData;
		public var tickCount			:int;
		public var channel				:SoundChannel;
		public var starttime			:int = 0;
		public var seek					:int;
		public var soundSynchroniser	:SoundSynchroniser;
		public var bitmapData			:BitmapData;
		
		public function init(timeFromSound:Boolean, tickTime:Number):void{throw('--#AbstractRender[render]:: must be overridden.');}
		
		public function render(event:Event):void{throw('--#AbstractRender[render]:: must be overridden.');}
		
		public function disposeRender():void
		{
			sequenceData = null;
			channel = null;
			soundSynchroniser = null;
			bitmapData = null;
			dispose();
		}
		
		protected function dispose():void{throw('--#AbstractRender[dispose]:: must be overridden.');}
	}
}