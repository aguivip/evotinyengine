package evoTinyEngine.sound.sync
{
	import evoTinyEngine.event.SoundHitEvent;

	public class SoundSyncHit
	{
		public var position16thNote:int;
		public var event:SoundHitEvent;
		public function SoundSyncHit(position16thNote:int, event:SoundHitEvent)
		{
			this.position16thNote = position16thNote;
			this.event = event;
		}
	}
}