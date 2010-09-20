package
{
	import evoTinyEngine.TinyEngine;
	import evoTinyEngine.sound.SoundPlayer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import project.demo.assets.Assets;
	import project.demo.modifier.ModifierSample;
	import project.demo.modifier.overlay.ModifierOverlayText;
	import project.demo.modifier.post.ModifierPostTint;
	
	[SWF(backgroundColor="#000000", frameRate="60", quality="high", width="720", height="406")]
	public class evoTinyEngineExample extends Sprite
	{
		private var assets:Assets;
		private var engine:TinyEngine;
		private var soundPlayer:SoundPlayer;
		
		private var startBeat:int = 0;
		private var volume:Number = 1;
		
		public function evoTinyEngineExample()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, setup);
		}  
		
		private function setup(event:Event = null):void
		{
			// ASSETS
			assets = new Assets(stage.stageWidth, stage.stageHeight, false, 0x000000);
			assets.stage = this.stage;
			
			// ADD TUNE
			//assets.sound = new SoundPlayer("yoursongurl.mp3");
			
			// ENGINE
			engine = new TinyEngine(assets, 100, 0, "auto", false);
			
			/** add modifiers **/
			// PRE PROCESS
			
			
			// EFFECTS
			engine.addModifier(new ModifierSample(assets, 0xFFFFFF, "sample0"), 0, 32);
			engine.addModifier(new ModifierSample(assets, 0xFF0000, "sample1"), 32, 64);
			engine.addModifier(new ModifierSample(assets, 0x00FF00, "sample2"), 48, 72);
			engine.addModifier(new ModifierSample(assets, 0x0000FF, "sample3"), 72, 96);
			
			
			// POST PROCESS
			engine.addModifier(new ModifierPostTint(assets, 0xFF00FF, .5, "post_tint"), 72, 96);
			
			
			// OVERLAY
			engine.addModifier(new ModifierOverlayText(assets, "Foobar", 28, 100, 100, 0xFFFFFF, 10, "text"), 16, 72);
			
			
			// SYNCHRONISER
			engine.soundSynchroniser.addHitPairPosValue([8,1, 16,1, 32,1, 48,1, 64,1]);
			
			
			// ADD TO DISPLAYLIST
			this.addChildAt(engine, 0);
			
			
			if(assets.sound as SoundPlayer)
			{
				//assets.sound.addEventListener(ProgressEvent.PROGRESS, progressListener);
				assets.sound.addEventListener(Event.COMPLETE, start);
			}
			else
			{
				start(null);
			}
			
			
		}
		
		private function start(event:Event = null):void
		{
			if(assets.sound as SoundPlayer)
			{
				//assets.sound.removeEventListener(ProgressEvent.PROGRESS, progressListener);
				assets.sound.removeEventListener(Event.COMPLETE, start);
			}
			
			engine.play(startBeat);
			engine.volume = volume;
		}
		
	}
}