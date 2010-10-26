package evoTinyEngine
{
	import evoTinyEngine.modifier.IModifier;

	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public interface ITinyEngine
	{
		function addModifier(modifier:IModifier, start16thNote:int, end16thNote:int):IModifier;
		function precalculate():void;
		function play(start16thNote:int = 0, loops:int = 0):void;
		function pause():void;
		function get tick():int;
		function set tick(v:int):void;
		function get volume():Number;
		function set volume(v:Number):void;
		function reset():void;
		function remove():void;
	}
}