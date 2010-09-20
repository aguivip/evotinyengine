package evoTinyEngine.sound.sync
{
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class SoundSynchroniser
	{
		public var hasSync:Boolean = false;
		public var loading:Boolean = false;
		
		private var list:Vector.<SoundHitEvent> = new Vector.<SoundHitEvent>(1000000);
		private var typeDictionary:Dictionary = new Dictionary();
		private var event:SoundHitEvent = new SoundHitEvent(-1);
		
		private var loader:URLLoader;
		
		public function SoundSynchroniser()
		{
			typeDictionary[ModifierType.PREPROCESS] = 0;
			typeDictionary[ModifierType.EFFECT] = 0;
			typeDictionary[ModifierType.POSTPROCESS] = 0;
		}
		
		/**
		 * add syncdata from file url
		 **/
		public function addFileFromUrl(url:String):void
		{
			loading = true;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, complete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, error);
			loader.load(new URLRequest(url));
		}
		private function complete(event:Event):void
		{
			this.addHitPairPosValue(String(loader.data).split(","));
			loading = false;
		}
		private function error(event:IOErrorEvent):void
		{
			trace("ERROR :: "+event);
		}
		
		/**
		 * add embedded string
		 **/
		public function addString(data:String):void
		{
			this.addHitPairPosValue(data.split(","));
		}
		
			
		/**
		 * add single hit
		 **/
		public function addHit(hit:SoundSyncHit):void
		{
			if(hit.position16thNote > this.list.length)
			{
				var offset:Vector.<SoundHitEvent> = new Vector.<SoundHitEvent>();
				offset = offset.concat(this.list);
				
				this.list = new Vector.<SoundHitEvent>(hit.position16thNote + 1000);
				this.list = this.list.concat(offset);
			}
			
			this.list[hit.position16thNote] = hit.event;
			hasSync = true;
		}
		
		/**
		 * add list of hits
		 **/
		public function addHitList(list:Vector.<SoundSyncHit>):void
		{
			var hit:SoundSyncHit
			var l:int = list.length;
			for(var i:int = 0; i < l; i++)
			{
				this.addHit(list[i]);
			}
		}
		
		/**
		 * add list of position + a-value pairs (position, value, position, value...)
		 **/
		public function addHitPairPosValue(list:Array):void
		{
			var l:int = list.length;
			for(var i:int = 0; i < l; i+=2)
			{
				if(list[i] > this.list.length)
				{
					var offset:Vector.<SoundHitEvent> = new Vector.<SoundHitEvent>();
					offset = offset.concat(this.list);
					
					this.list = new Vector.<SoundHitEvent>(list[i] + 1000);
					this.list = this.list.concat(offset);
				}
				
				this.list[list[i]] = new SoundHitEvent(list[int(i+1)]);
			}
			hasSync = true;
		}
		
		/**
		 * add list of position + SoundHitEvent class pairs (position, SoundHitEvent, position, SoundHitEvent...)
		 **/
		public function addHitPairPosSndHit(list:Array):void
		{
			var l:int = list.length;
			for(var i:int = 0; i < l; i+=2)
			{
				if(list[i] > this.list.length)
				{
					var offset:Vector.<SoundHitEvent> = new Vector.<SoundHitEvent>();
					offset = offset.concat(this.list);
					
					this.list = new Vector.<SoundHitEvent>(list[i] + 1000);
					this.list = this.list.concat(offset);
				}
				
				this.list[list[i]] = list[int(i+1)];
			}
			hasSync = true;
		}
		
		/**
		 * GET SoundHitEvent for tick
		 **/
		private var returnCount:int = 0;
		public function getHit(tick:int, type:String):SoundHitEvent
		{
			if(!hasSync) return null;
			if(typeDictionary[type] != tick)
			{
				return list[typeDictionary[type] = tick];
			}
			return null;
		}
	}
}