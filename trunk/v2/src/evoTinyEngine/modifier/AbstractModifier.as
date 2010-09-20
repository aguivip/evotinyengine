package evoTinyEngine.modifier
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.event.SoundHitEvent;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public class AbstractModifier implements IModifier
	{
		public var next:AbstractModifier;
		public var prev:AbstractModifier;
		
		public var bit:BitmapData;
		protected var assets:AbstractAssets;
		protected var rect:Rectangle;
		protected var pt:Point = new Point();
		protected var w:int;
		protected var h:int;
		protected var ws:int;
		protected var hs:int;
		
		private var _id:String = "";
		private var _start:int;
		private var _end:int;
		private var _duration:int;
		private var _totalFrames:int;
		private var _durationTime:Number;
		private var _startTime:Number;
		private var _endTime:Number;
		private var _tickTime:Number
		
		public function AbstractModifier(id:String = "")
		{
			this.id = id;
		}
		
		public function setup(assets:AbstractAssets, bit:BitmapData = null):void
		{
			this.bit = bit;
			this.rect = bit ? bit.rect : null;
			this.assets = assets;
			this.w = assets.width;
			this.h = assets.height;
			this.ws = w >> 1;
			this.hs = h >> 1;
		}
		
		public function get duration():int
		{
			return _duration;
		}
		
		public function set duration(v:int):void
		{
			_duration = v;
		}
		
		public function get end16thNote():int
		{
			return _end;
		}
		
		public function set end16thNote(v:int):void
		{
			_end = v;
		}
		
		public function get start16thNote():int
		{
			return _start;
		}
		
		public function set start16thNote(v:int):void
		{
			_start = v;
		}
		
		public function get durationTime():Number
		{
			return _durationTime;
		}
		
		public function set durationTime(v:Number):void
		{
			_durationTime = v;
		}
		
		public function get startTime():Number
		{
			return _startTime;
		}
		public function set startTime(v:Number):void
		{
			_startTime = v;
		}
		
		public function get endTime():Number
		{
			return _endTime;
		}
		public function set endTime(v:Number):void
		{
			_endTime = v;
		}
		
		public function get tickTime():Number
		{
			return _tickTime;
		}
		public function set tickTime(v:Number):void
		{
			_tickTime = v;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(v:String):void
		{
			_id = v;
		}
		
		private var _type:int = ModifierType.EFFECT;
		public function get type():int
		{
			return _type;
		}
		
		public function set type(v:int):void
		{
			_type = v;
		}
		
		private var _initialized:Boolean = false;
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		public function set initialized(v:Boolean):void
		{
			_initialized = v;
		}
		
		private var _position:int = 0;
		public function get position():int
		{
			return _position;
		}
		
		public function set position(v:int):void
		{
			_position = v;
		}
		
		private var _active:Boolean = false;
		public function set active(v:Boolean):void
		{
			_active = v;
		}
		public function get active():Boolean
		{
			return _active;
		}
		
		
		public function initialize(data:RenderData):void
		{
			initializeModifier(data);
			this.initialized = true;
		}
		
		protected function initializeModifier(data:RenderData):void
		{
			throw('--#AbstractModifier[initializeModifier]:: this method[initializeModifier] must be overridden in implementation.');
		}
		
		public function dispose():void
		{
			disposeModifier();
			this.initialized = false;
		}
		
		protected function disposeModifier():void
		{
			throw('--#AbstractModifier[disposeModifier]:: this method[disposeModifier] must be overridden in implementation.');
		}
		
		public function render(data:RenderData):void
		{
			throw('--#AbstractModifier[render]:: this method[render] must be overridden in implementation.');
		}
		
		public function soundHit(event:SoundHitEvent):void
		{
			
		}
		
		public function endMe():void
		{
			this.end16thNote = 0;
		}
		
		public function remove():void
		{
			this.assets = null;
			this.next = null;
			this.prev = null;
			this.bit = null;
			this.rect = null;
		}
		
		public function toString() : String
		{
			return getQualifiedClassName(this).split("::")[1];
		}
		
	}
}