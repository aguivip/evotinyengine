package evoTinyEngine.modifier
{
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.event.SoundHitEvent;
	
	import flash.display.BitmapData;

	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public interface IModifier
	{
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
		function get id():String;
		function get type():String;
		function get initialized():Boolean;
		function initialize(data:RenderData, bit:BitmapData = null):IModifier
		function dispose():IModifier;
		function render(data:RenderData):void;
		function soundHit(event:SoundHitEvent):void;
		function remove():void;
		function toString():String
	}
}