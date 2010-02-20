package evoTinyEngine.assets
{
	import evoTinyEngine.ITinyEngine;
	
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public class AbstractAssets
	{
		public function AbstractAssets(width:int, height:int, transparent:Boolean = true, color:uint = 0x00000000)
		{
			this.width = width;
			this.height = height;
			this.bitmapdata = new BitmapData(width, height, transparent, color);
		}
		
		public var tinyengine:ITinyEngine;
		public var width:int;
		public var height:int;
		public var bitmapdata:BitmapData;
		public var tickTime:Number;
		public var sound:Sound;
		public var channel:SoundChannel;
		
	}
}