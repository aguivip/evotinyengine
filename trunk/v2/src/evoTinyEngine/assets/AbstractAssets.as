package evoTinyEngine.assets
{
	import evoTinyEngine.ITinyEngine;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public class AbstractAssets extends EventDispatcher
	{
		public static const EVENT_ASSETS_INITIALIZED	:String = "event_assets_initialized";
		
		public var initialized:Boolean = false;
		
		public function AbstractAssets(width:int, height:int)
		{
			this.width = width;
			this.height = height;
		}
		
		public function initializeAssets():void
		{
			if(this.initialize()) this.dispatchEvent(new Event(EVENT_ASSETS_INITIALIZED));
		}
		
		public function initialize():Boolean
		{
			throw('--#AbstractAssets[initialize]:: this method[initialize] must be overridden in implementation.');
		}
		
		public var tinyengine:ITinyEngine;
		public var width:int;
		public var height:int;
		public var tickTime:Number;
		public var sound:Sound;
		public var channel:SoundChannel;
		
	}
}