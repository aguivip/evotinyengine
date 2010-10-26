package evoTinyEngine.render
{
	import evoTinyEngine.TinyEngine;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.data.SequenceData;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.IModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class RenderBitmap extends AbstractRender
	{
		private var _framesplit				:int = 0;
		private var _frameRate				:int = 60;
		private var _lasttime				:int = 0;
		private var _time					:int;
		
		private var _prevFrameTime			:Number;
		private var _secondTime 			:Number;
		private var _prevSecondTime 		:Number;
		private var _frames 				:Number;
		
		private var _timeFromSound			:Boolean = false;
		private var _tickTime				:Number;
		private var _bitmapData				:BitmapData;
		private var _rect					:Rectangle;
		
		private var _renderData				:RenderData;
		private var _sequenceStart			:Vector.<Vector.<IModifier>>;
		private var _sequenceEnd			:Vector.<Vector.<IModifier>>;
		private var _sequenceStartCount		:Vector.<int>;
		private var _sequenceEndCount		:Vector.<int>;
		private var _playList				:Vector.<IModifier>;
		
		public function RenderBitmap(bitmapData:BitmapData)
		{
			this._bitmapData = this.bitmapData = bitmapData;
			this._rect = bitmapData.rect;
			this._renderData = new RenderData();
			
			sequenceData = new SequenceData();
			_sequenceStart = sequenceData.sequenceStart;
			_sequenceStartCount = sequenceData.sequenceStartCount;
			_sequenceEnd = sequenceData.sequenceEnd;
			_sequenceEndCount = sequenceData.sequenceEndCount;
			
			_playList = new Vector.<IModifier>();
		}
		
		
		override public function init(timeFromSound:Boolean, tickTime:Number, startTime:int):void
		{
			this._timeFromSound = timeFromSound;
			this._tickTime = tickTime;
			this._lasttime = startTime;
		}
		
		
		override public function render(event:Event):void
		{
			_time = getTimer();
			
			// CORRECT FRAME
			_secondTime = _time - _prevSecondTime;
			
			if(_secondTime >= 1000) 
			{
				_frameRate = _frames;
				_frames = 0;
				_prevSecondTime = _time;
			} else {
				_frames++;
			}
			_prevFrameTime = _time;		
			
			_framesplit = _frameRate >> 1;
			
			
			// RENDER DATA
			this._renderData.time = int(seek + _time - starttime + _framesplit);
			
			if(_timeFromSound)
			{
				this._renderData.sequenceTime = int(channel.position + _framesplit);
			} else {
				this._renderData.sequenceTime = this._renderData.time;
			}
			this._renderData.deltatime = (this._renderData.deltatime = this._renderData.time - _lasttime) < 100 ? this._renderData.deltatime : 50;
			this.tickCount = this._renderData.tickCount = int(this._renderData.sequenceTime / _tickTime);
			this._lasttime = this._renderData.time;
			
			
			// RENDER
			var sndHit:SoundHitEvent;
			var mod:IModifier;
			var i:int, j:int, k:int, l:int = _sequenceStartCount[tickCount];
			for(i = 0; i < l; i++)
			{
				mod = _sequenceStart[tickCount][i];
				if(!mod.active)
				{
					if(mod.type != ModifierType.SETUP) 
					{
						mod.position = int(_playList.push(mod)-1);
					}
					mod.active = true;
					mod.initialize(this._renderData);
				}
			}
			l = _sequenceEndCount[tickCount];
			for(i = 0; i < l; i++)
			{
				mod = _sequenceEnd[tickCount][i];
				if(mod.active)
				{
					mod.dispose();
					if(mod.type != ModifierType.SETUP) 
					{
						j = mod.position;
						_playList.splice(j, 1);
						k = _playList.length;
						for(j; j < k; j++)
						{
							_playList[j].position--;
						}
					}
					mod.active = false;
				}
			}
			
			l = _playList.length;
			_bitmapData.lock();
			for(i = 0; i < l; i++)
			{
				mod = _playList[i];
				this._renderData.lifeTime = 1 - (mod.endTime - this._renderData.time) / mod.durationTime;
				if((sndHit = this.soundSynchroniser.getHit(_renderData.tickCount))) mod.soundHit(sndHit);
				mod.render(this._renderData);
			}
			_bitmapData.unlock(_rect);
			
		}
		
		override protected function dispose():void
		{
			_bitmapData = null;
			_rect = null;
			_renderData = null;
			_sequenceStart = null;
			_sequenceEnd = null;
			_sequenceStartCount = null;
			_sequenceEndCount = null;
			_playList = null;
		}
		
	}
}