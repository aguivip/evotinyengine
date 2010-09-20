package evoTinyEngine.sound {
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class SoundPlayer extends Sound
	{
		public function SoundPlayer(url:String = null)
		{
			this.load(new URLRequest(url));
		}
	}
}