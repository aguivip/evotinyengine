package
{
	import evoTinyEngine.TinyEngine;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.ModifierType;
	import evoTinyEngine.render.RenderBitmap;
	import evoTinyEngine.render.RenderUniversal;
	import evoTinyEngine.sound.SoundPlayer;
	import evoTinyEngine.sound.sync.SoundSyncHit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import project.demo.assets.Assets;
	import project.demo.modifier.ModifierEmpty;
	import project.demo.modifier.overlay.ModifierOverlayText;
	import project.demo.modifier.post.ModifierPostBloomSurfaceFast2;
	import project.utils.Color;
	import project.utils.FPSCounter;
	import project.utils.Fullscreen;
	import project.utils.LoadingScreen;
	import project.utils.StageSettings;
	
	[SWF(backgroundColor=0x000000, width=1024, height=576, frameRate=60)]
	public class Main extends StageSettings
	{
		private var assets:Assets;
		private var engine:TinyEngine;
		private var bitmap:Bitmap;
		private var soundPlayer:SoundPlayer;
		private var fps:FPSCounter;
		private var fullscreen:Fullscreen;
		private var loading:LoadingScreen;
		
		private var startBeat:int = 0;
		private var volume:Number = 0.6;
		
		private var window:Bitmap;
		
		private var timer:Timer;
		
		public function Main()
		{
			Security.allowDomain("*");
			if(this.stage)
			{
				super(this.stage, StageQuality.HIGH);
				this.initialize(this.stage);
			}
		}
		
		public function initialize(stage:Stage):void
		{	
			this.addEventListener(Event.ADDED_TO_STAGE, setScreen);
		}
		
		private function setScreen(event:Event):void
		{
			fullscreen = new Fullscreen(stage, stage.stageWidth, stage.stageHeight);
			fullscreen.addEventListener(Fullscreen.EVENT_SELECTED, setupAssets);
			this.addChild(fullscreen);
			
			if(Capabilities.playerType == "StandAlone")
			{
				setupAssets(); 
				fullscreen.dispose();
			}
		}
		
		
		private function setupAssets(event:Event = null):void
		{
			// ASSETS
			assets = new Assets(stage.stageWidth, stage.stageHeight);
			assets.stage = this.stage;
			
			timer = new Timer(stage.frameRate, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, setupEngine);
			timer.start();
		}
		
		private function setupEngine(event:Event = null):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, setupEngine);
			
			// LOADER
			loading = new LoadingScreen(stage.stageWidth, stage.stageHeight);
			loading.addEventListener(Event.COMPLETE, start);
			this.addChild(loading);
			
			// SOUND
			//assets.sound = new SoundPlayer("../ext/asm10_evojac.mp3");
			
			// VIEW
			var bitmap:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0));
			this.addChild(bitmap);
			
			// ENGINE
			engine = new TinyEngine(assets, new RenderBitmap(bitmap.bitmapData), 120);
			//engine = new TinyEngine(assets, new RenderUniversal(), 120);
			
			startBeat = 0;
			volume = 0.6;
			
			// PRE PROCESS
			
			// EFFECTS
			engine.addModifier(new ModifierEmpty(), 0, TinyEngine.Infinite);
			
			// POST PROCESS
			engine.addModifier(new ModifierPostBloomSurfaceFast2(32, 16, 2, 0, 1.0, BlendMode.ADD), 0, TinyEngine.Infinite);
			
			// OVERLAY
			engine.addModifier(new ModifierOverlayText("foobar", 48, 20, 20, 0xFFFFFF, 10, ModifierOverlayText.FIX_CENTER), 16, TinyEngine.Infinite);
			
			// SYNC
			//engine.soundSynchroniser.addString(assets.syncdata);
			
			
			// FPS
			fps = new FPSCounter();
			this.addChild(fps);
			
			if(assets.sound as SoundPlayer)
			{
				assets.sound.addEventListener(ProgressEvent.PROGRESS, loading.progress);
				assets.sound.addEventListener(Event.COMPLETE, ready);
			}
			else
			{
				ready(null);
			}
			
		}
		
		private function ready(event:Event = null):void
		{
			timer = new Timer(500, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, start);
			timer.start();
		}
		
		private function start(event:Event = null):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, start);
			
			if(assets.sound as SoundPlayer)
			{
				assets.sound.removeEventListener(ProgressEvent.PROGRESS, loading.progress);
				assets.sound.removeEventListener(Event.COMPLETE, start);
			}
			
			loading.removeEventListener(Event.COMPLETE, start);
			this.removeChild(loading);
			loading = null;
			
			engine.play(startBeat, 0);
			engine.volume = volume;
			
			// FPS TO FRONT
			this.addChild(fps);	
		}
	}
}