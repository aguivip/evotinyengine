package evoTinyEngine.event
{
	public class SoundHitEvent
	{
		public var a:int;
		public var b:Number, c:Number, d:Number;
		public function SoundHitEvent(a:int = 0, b:Number = 0, c:Number = 0, d:Number = 0)
		{
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
		}
	}
}