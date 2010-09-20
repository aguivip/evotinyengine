package evoTinyEngine.render
{
	import evoTinyEngine.TinyEngine;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.data.SequenceData;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.IModifier;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class RenderUniversal extends AbstractRender
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
		
		private var _renderData				:RenderData;
		private var _sequenceStart			:Vector.<Vector.<IModifier>>;
		private var _sequenceEnd			:Vector.<Vector.<IModifier>>;
		private var _sequenceStartCount		:Vector.<int>;
		private var _sequenceEndCount		:Vector.<int>;
		private var _playList				:Vector.<IModifier>;
		
		public function RenderUniversal()
		{
			this._renderData = new RenderData();
			
			sequenceData = new SequenceData();
			_sequenceStart = sequenceData.sequenceStart;
			_sequenceStartCount = sequenceData.sequenceStartCount;
			_sequenceEnd = sequenceData.sequenceEnd;
			_sequenceEndCount = sequenceData.sequenceEndCount;
			
			_playList = new Vector.<IModifier>();
		}
		
		
		override public function init(timeFromSound:Boolean, tickTime:Number):void
		{
			this._timeFromSound = timeFromSound;
			this._tickTime = tickTime;
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
			if(_timeFromSound)
			{
				this._renderData.time = int(channel.position + _framesplit);
			}
			else
			{
				this._renderData.time = int(seek + _time - starttime + _framesplit);
			}
			this._renderData.deltatime = this._renderData.time - _lasttime;
			this.tickCount = this._renderData.tickCount = int(this._renderData.time / _tickTime);
			this._lasttime = this._renderData.time;
			
			// RENDER
			var sndHit:SoundHitEvent;
			var mod:IModifier;
			var i:int, l:int = _sequenceStartCount[tickCount];
			for(i = 0; i < l; i++)
			{
				mod = _sequenceStart[tickCount][i];
				if(!mod.active)
				{
					_playList.push(mod);
					mod.position = i;
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
					_playList.splice(mod.position, 1);
					mod.active = false;
				}
			}
			
			l = _playList.length;
			for(i = 0; i < l; i++)
			{
				mod = _playList[i];
				this._renderData.lifeTime = 1 - (mod.endTime - this._renderData.time) / mod.durationTime;
				if((sndHit = this.soundSynchroniser.getHit(_renderData.tickCount))) mod.soundHit(sndHit);
				mod.render(this._renderData);
			}
			
		}
		
		
		override protected function dispose():void
		{
			_renderData = null;
			_sequenceStart = null;
			_sequenceEnd = null;
			_sequenceStartCount = null;
			_sequenceEndCount = null;
			_playList = null;
		}
		
	}
}