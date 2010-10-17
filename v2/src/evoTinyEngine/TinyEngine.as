package evoTinyEngine
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.data.SequenceData;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.IModifier;
	import evoTinyEngine.modifier.ModifierType;
	import evoTinyEngine.render.AbstractRender;
	import evoTinyEngine.sound.sync.SoundSynchroniser;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;

	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public class TinyEngine extends Sprite implements ITinyEngine
	{
		public static const Infinite:int = 9999;
		
		private var assets			:AbstractAssets;
		private var inOrder			:Boolean = false;
		private var sound			:Sound
		private var tickTime		:Number = 0;
		private var renderer		:AbstractRender;
		private var start16thNote	:int = 0;
		private var loops			:int;
		private var modifierList	:Vector.<int>;
		
		public function TinyEngine(assets:AbstractAssets, renderer:AbstractRender, bpm:Number = 100)
		{
			assets.tinyengine = this;
			this.assets = assets;
			this.sound = assets.sound;
			
			this.tickTime = assets.tickTime = 60000 / (bpm * 4);
			
			this.renderer = renderer;
			this.render = renderer.render;
			this.renderer.channel = assets.channel;
			
			this.soundSynchroniser = new SoundSynchroniser();
			
			modifierList = new Vector.<int>();
		}
		
		public function addModifier(modifier:IModifier, start16thNote:int, end16thNote:int):IModifier
		{
			if(start16thNote > end16thNote) throw('--#AbstractScript[addModifier]:: value end16thNote must be greater then start16thNote. Try to be more logical.');
			
			if(!renderer.sequenceData.sequenceStart[start16thNote])
			{
				renderer.sequenceData.sequenceStart[start16thNote] = new Vector.<IModifier>();
				renderer.sequenceData.sequenceStartCount[start16thNote] = 0;
			}
			modifierList.push(start16thNote);
			renderer.sequenceData.sequenceStart[start16thNote][renderer.sequenceData.sequenceStartCount[start16thNote]] = modifier;
			renderer.sequenceData.sequenceStartCount[start16thNote]++;
			
			if(!renderer.sequenceData.sequenceEnd[end16thNote])
			{
				renderer.sequenceData.sequenceEnd[end16thNote] = new Vector.<IModifier>();
				renderer.sequenceData.sequenceEndCount[end16thNote] = 0;
			}
			renderer.sequenceData.sequenceEnd[end16thNote][renderer.sequenceData.sequenceEndCount[end16thNote]] = modifier;
			renderer.sequenceData.sequenceEndCount[end16thNote]++;
				
			modifier.start16thNote = start16thNote;
			modifier.end16thNote = end16thNote;
			modifier.duration = end16thNote - start16thNote;
			modifier.endTime = end16thNote * tickTime
			modifier.durationTime = modifier.duration * tickTime;
			modifier.tickTime = tickTime;
			modifier.startTime = start16thNote*tickTime;
			
			modifier.setup(assets, renderer.bitmapData);
			
			inOrder = false;
			
			return modifier;
		}
		
		private function waitAndPlay(event:Event):void
		{
			assets.removeEventListener(AbstractAssets.EVENT_ASSETS_INITIALIZED, waitAndPlay);
			assets.initialized = true;
			play(this.start16thNote, this.loops);
		}
		
		public function play(start16thNote:int = 0, loops:int = 0):void
		{
			this.start16thNote = start16thNote;
			this.loops = loops;
			
			if(!assets.initialized)
			{
				assets.addEventListener(AbstractAssets.EVENT_ASSETS_INITIALIZED, waitAndPlay);
				assets.initializeAssets();
			}
			else
			{
				if(!inOrder) order();
				
				this.renderer.seek = int(start16thNote * tickTime) || 1;
				
				if(sound) 
				{
					if(renderer.channel) renderer.channel.stop();
					renderer.channel = assets.channel = sound.play(this.renderer.seek, loops);
					this.volume = _volume;
				}
				else
				{
					this.renderer.starttime = getTimer();
				}
				
				this.renderer.init(sound ? true : false, tickTime, this.renderer.seek);
				
				this.addEventListener(Event.ENTER_FRAME, render);
			}
		}
		
		private var paused:Boolean = true;
		public function pause():void
		{
			this.removeEventListener(Event.ENTER_FRAME, render);
		}
		
		
		public function get tick():int
		{
			return renderer.tickCount;
		}
		public function set tick(v:int):void
		{
			play(v);
		}
		
		
		private var _volume:Number = 1;
		public function get volume():Number
		{
			if(this.renderer.channel) _volume = this.renderer.channel.soundTransform.volume;
			return _volume;
		}
		public function set volume(v:Number):void
		{
			if(this.renderer.channel) this.renderer.channel.soundTransform = new SoundTransform(v);
			_volume = v;
		}
		
		
		/**
		 * Sound Synchroniser
		 */
		public function get soundSynchroniser():SoundSynchroniser
		{
			return this.renderer.soundSynchroniser;
		}
		
		public function set soundSynchroniser(value:SoundSynchroniser):void
		{
			this.renderer.soundSynchroniser = value;
		}
		
		
		
		/**
		 * RENDERING
		 */
		private var render:Function;
		
		
		
		private function order():void
		{
			var mod:IModifier;
			var list:Vector.<IModifier>;
			var sequenceData:SequenceData;
			var k:int, j:int, l:int = modifierList.length;
			for(var i:int = 0; i < l; i++)
			{
				list = renderer.sequenceData.sequenceStart[modifierList[i]];
				if(modifierList[i] < start16thNote)
				{
					k = list.length;
					sequenceData = renderer.sequenceData
					for(j = 0; j < k; j++)
					{
						mod = list[j];
						if(mod.start16thNote < start16thNote && mod.end16thNote > start16thNote)
						{
							if(!sequenceData.sequenceStart[start16thNote])
							{
								sequenceData.sequenceStart[start16thNote] = new Vector.<IModifier>();
								sequenceData.sequenceStartCount[start16thNote] = 0;
							}
							sequenceData.sequenceStart[start16thNote][sequenceData.sequenceStartCount[start16thNote]] = mod;
							sequenceData.sequenceStartCount[start16thNote]++;
						}
					}
				}
				else
				{
					list.sort(sort);
				}
			}
			inOrder = true;
		}
		
		private function sort(a:IModifier, b:IModifier):Number
		{
			if(a.type < b.type)
			{
				return -1;
			}
			else if(a.type == b.type)
			{
				if(a.layer < b.layer)
				{
					return -1;
				}
				else if(a.layer > b.layer)
				{
					return 1;
				}
				else
				{
					if(a.end16thNote < b.end16thNote)
					{
						return -1;
					}
					else
					{
						return 1;
					}
				}
			}
			else
			{
				return 1;
			}
		}
		
		public function reset():void
		{
			pause();
			
			inOrder = false;
		}
		
		
		public function remove():void
		{
			pause();
			
			this.assets = null;
			
			sound = null;
		}
		
	}
}