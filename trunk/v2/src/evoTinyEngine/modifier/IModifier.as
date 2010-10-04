package evoTinyEngine.modifier
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.event.SoundHitEvent;
	
	import flash.display.BitmapData;

	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public interface IModifier
	{
		function setup(assets:AbstractAssets, bit:BitmapData = null):void;
		function get end16thNote():int;
		function set end16thNote(v:int):void;
		function get start16thNote():int;
		function set start16thNote(v:int):void;
		function get duration():int;
		function set duration(v:int):void;
		function get durationTime():Number;
		function set durationTime(v:Number):void;
		function get startTime():Number;
		function set startTime(v:Number):void;
		function get endTime():Number;
		function set endTime(v:Number):void;
		function get tickTime():Number;
		function set tickTime(v:Number):void;
		function get id():String;
		function get type():int;
		function get layer():int;
		function set layer(v:int):void;
		function get initialized():Boolean;
		function set position(v:int):void;
		function get position():int;
		function set active(v:Boolean):void;
		function get active():Boolean;
		function initialize(data:RenderData):void
		function dispose():void;
		function render(data:RenderData):void;
		function soundHit(event:SoundHitEvent):void;
		function remove():void;
		function toString():String
	}
}