package evoTinyEngine
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.canvas.AbstractCanvas;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.event.TinyEngineEvent;
	import evoTinyEngine.link.LinkedListModifier;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.IModifier;
	import evoTinyEngine.modifier.ModifierType;
	import evoTinyEngine.sound.sync.SoundSynchroniser;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;

	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public class TinyEngine extends AbstractCanvas implements ITinyEngine
	{
		public static const Infinite:int = int.MAX_VALUE;
		
		private var assets:AbstractAssets;
		private var inOrder:Boolean = false;
		private var sound:Sound
		private var channel:SoundChannel;
		private var seek:int = 0;
		private var rect:Rectangle;
		
		private var link_effects:LinkedListModifier;
		private var link_pstprcss:LinkedListModifier;
		private var link_preprcss:LinkedListModifier;
		private var link_overlay:LinkedListModifier;
		private var all:Vector.<AbstractModifier>;
		
		private var renderData:RenderData;
		
		private var starttime:int = 0;
		private var lasttime:int = 0;
		private var tickTime:Number = 0;
		private var tickCount:int = 0;
		private var offset:int;
		private var framesplit:int = 0;
		private var frameRate:int = 60;
		
		private var initializeList:Array;
		private var disposeList:Array;
		
		public function TinyEngine(assets:AbstractAssets, bpm:Number = 100, offset:int = 0, pixelSnapping:String = "auto", smoothing:Boolean = false)
		{
			super(assets.bitmapdata, pixelSnapping, smoothing);
			
			assets.tinyengine = this;
			this.assets = assets;
			this.sound = assets.sound;
			this.channel = assets.channel;
			this.rect = assets.bitmapdata.rect;
			this.renderData = new RenderData();
			
			this.soundSynchroniser = new SoundSynchroniser();
			
			
			all = new Vector.<AbstractModifier>();
			
			link_effects = new LinkedListModifier();
			link_preprcss = new LinkedListModifier();
			link_pstprcss = new LinkedListModifier();
			link_overlay = new LinkedListModifier();
			
			link_preprcss.next = link_effects;
			link_effects.next = link_pstprcss;
			link_pstprcss.next = link_overlay;
			
			initializeList = new Array();
			disposeList = new Array();
			
			this.tickTime = assets.tickTime = 60000 / (bpm * 4);
			
			this.offset = offset;
		}
		
		public function addModifier(modifier:IModifier, start16thNote:int, end16thNote:int):IModifier
		{
			if(start16thNote > end16thNote) throw('--#AbstractScript[addModifier]:: value end16thNote must be greater then start16thNote. Try to be more logical.');
			
			all.push(modifier);
			
			modifier.start16thNote = start16thNote;
			modifier.end16thNote = end16thNote;
			modifier.duration = end16thNote - start16thNote;
			modifier.endTime = end16thNote * tickTime
			modifier.durationTime = modifier.duration * tickTime;
			modifier.tickTime = tickTime;
			modifier.startTime = start16thNote*tickTime;
			
			inOrder = false;
			
			return modifier;
		}
		
		public function play(start16thNote:int = 0, loops:int = 0):void
		{
			if(start16thNote < renderData.tickCount) inOrder = false;
			
			if(!inOrder) order();
			
			this.seek = int(start16thNote * tickTime) || 1;
			if(sound) 
			{
				if(channel) channel.stop();
				channel = assets.channel = sound.play(this.seek, loops);
			}
			else
			{
				starttime = getTimer();
			}
			
			this.addEventListener(Event.ENTER_FRAME, render);
		}
		
		private var paused:Boolean = true;
		public function pause():void
		{
			this.removeEventListener(Event.ENTER_FRAME, render);
		}
		
		
		public function get tick():int
		{
			return renderData.tickCount;
		}
		public function set tick(v:int):void
		{
			play(v);
		}
		
		
		private var _volume:Number = 1;
		public function get volume():Number
		{
			if(this.channel) _volume = this.channel.soundTransform.volume;
			return _volume;
		}
		public function set volume(v:Number):void
		{
			if(this.channel) this.channel.soundTransform = new SoundTransform(v);
			_volume = v;
		}
		
		
		/**
		 * Sound Synchroniser
		*/
		public var soundSynchroniser:SoundSynchroniser;
		
		
		/**
		 * RENDERING
		 */
		private var _time : Number;		
		private var _prevFrameTime : Number;
		private var _secondTime : Number;
		private var _prevSecondTime : Number;
		private var _frames : Number;
		
		private function render(event:Event):void
		{
			_time = getTimer();
			
			// CORRECT FRAME
			_secondTime = _time - _prevSecondTime;
			
			if(_secondTime >= 1000) 
			{
				frameRate = _frames;
				_frames = 0;
				_prevSecondTime = _time;
			} else {
				_frames++;
			}
			_prevFrameTime = _time;		
			
			framesplit = frameRate >> 1;
			
			
			// RENDER DATA
			if(channel)
			{
				this.renderData.time = int(channel.position + framesplit + offset);
			}
			else
			{
				this.renderData.time = int(seek + _time - starttime + framesplit + offset);
			}
			this.renderData.deltatime = this.renderData.time - lasttime;
			this.renderData.tickCount = int(this.renderData.time / tickTime);
			
			this.lasttime = this.renderData.time;
			
			// RENDER
			initializeList.length = 0;
			disposeList.length = 0;
			
			var c:int = 0;
			
			var mo:AbstractModifier;
			var play:LinkedListModifier = link_preprcss;
			var sndHit:SoundHitEvent;
			bitmapData.lock();
			while(play)
			{
				if(play.first) // LAYER
				{
					mo = play.first;
					
					while(mo) // MODIFIER
					{
						c++
						if(this.renderData.tickCount >= mo.start16thNote)
						{
							if(this.renderData.tickCount < mo.end16thNote)
							{
								if(!mo.initialized) initializeList.push(mo.initialize(this.renderData));
								
								this.renderData.lifeTime = 1 - (mo.endTime - this.renderData.time) / mo.durationTime;
								
								if((sndHit = this.soundSynchroniser.getHit(renderData.tickCount, mo.type))) mo.soundHit(sndHit);
								
								mo.render(this.renderData);
							}
							else
							{
								if(mo.initialized) disposeList.push(mo.dispose());
								
								if(mo == play.first)
								{
									mo = play.first = mo.next;
								}else
								{
									mo = mo.next;
								}
								continue;
							}
						}
						else
						{
							break;
						}
						
						mo = mo.next;
					}
				}
				play = play.next;
			}
			
			bitmapData.unlock(rect);
			
			if(initializeList.length) this.dispatchEvent(new TinyEngineEvent(initializeList, TinyEngineEvent.EVENT_INITIALIZED));
			if(disposeList.length) this.dispatchEvent(new TinyEngineEvent(disposeList, TinyEngineEvent.EVENT_DISPOSED));
		}
		
		private function order():void
		{
			link_effects.dispose();
			link_pstprcss.dispose();
			link_preprcss.dispose();
			link_overlay.dispose();
			
			all.sort(sort);
			
			var mo:AbstractModifier;
			var l:int = all.length;
			for(var i:int = 0; i < l; i++)
			{
				mo = all[i];
				
				if(mo.type == ModifierType.EFFECT)
				{
					link_effects.push(mo);
				}
				else if(mo.type == ModifierType.POSTPROCESS)
				{
					link_pstprcss.push(mo);
				}
				else if(mo.type == ModifierType.PREPROCESS)
				{
					link_preprcss.push(mo);
				}
				else if(mo.type == ModifierType.OVERLAY)
				{
					link_overlay.push(mo);
				}
			}
			
			
			inOrder = true;
		}
		
		private function sort(a:IModifier, b:IModifier):Number
		{
			if(a.start16thNote < b.start16thNote)
			{
				return -1;
			}
			else if(a.start16thNote == b.start16thNote)
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
			else
			{
				return 1;
			}
		}
		
		public function reset():void
		{
			pause();
			
			var l:int = all.length;
			for(var i:int = 0; i < l; i++)
			{
				all[i].remove();
			}
			all.length = 0;
			all = new Vector.<AbstractModifier>();
			
			initializeList.length = 0;
			disposeList.length = 0;
			
			inOrder = false;
		}
		
		
		public function remove():void
		{
			pause();
			
			var l:int = all.length;
			for(var i:int = 0; i < l; i++)
			{
				all[i].remove();
			}
			all.length = 0;
			all = null;
			
			initializeList = null;
			disposeList = null;
			
			this.link_effects.remove();
			this.link_preprcss.remove();
			this.link_pstprcss.remove();
			this.assets = null;
			
			sound = null;
			channel = null;
		}
		
	}
}