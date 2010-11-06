package evoTinyEngine.sound {
	import flash.display.Loader;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class SoundPlayer extends Sound
	{
		public var stream:Boolean = false;
		
		public function SoundPlayer(url:String = null, stream:Boolean = false)
		{
			this.stream = stream;
			
			if(!stream) 
			{
				this.load(new URLRequest(url));
			}
			else
			{
				super(new URLRequest(url), new SoundLoaderContext(5000, true));
			}
		}
	}
}