package project.utils {
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;

	public class FPSCounter extends Sprite {
		
		private var _time : Number;		
		private var _prevFrameTime : Number;
		private var _secondTime : Number;
		private var _prevSecondTime : Number;
		private var _frames : Number;
		
		private var _fps : Number;
		private var _frameTime : Number;	
		
		private var tf:TextField;
		
		public function get frameTime() : Number {			
			return _frameTime;
		}
		
		public function get fps() : Number {
			return _fps;	
		}	
		
		/**
		 * constructor for singleton, uses lock class
		 * 
		 * @param lock Class
		 */
		public function FPSCounter() 
		{
			_prevFrameTime = getTimer();
			_prevSecondTime = getTimer();
			_frames = 0;
			_secondTime = 0;
			_frameTime = 0;			
			_fps = -1;
			
			tf = new TextField();
			tf.textColor = 0xFFFFFF;
			tf.blendMode = BlendMode.INVERT;
			tf.selectable = false;
			this.addChild(tf);
			
			start();
		}	
		
		/**
		 * solves framerate
		 * 
		 * @param pEvent Event
		 */
		protected function solve(pEvent : Event) : void {
			_time = getTimer();
			
			_frameTime = _time - _prevFrameTime;
			_secondTime = _time - _prevSecondTime;
			
			if(_secondTime >= 1000) {
				_fps = _frames;
				_frames = 0;
				_prevSecondTime = _time;
			} else {
				_frames++;
			}
			tf.text = "fps: "+_fps+"  ms: "+_frameTime;
			_prevFrameTime = _time;			
		}
		
		/**
		 * starts FPS counter
		 */
		public function start():void {
			this.addEventListener(Event.ENTER_FRAME, solve);
		}
		
		/**
		 * stops FPS counter
		 */
		public function pause():void {
			this.removeEventListener(Event.ENTER_FRAME, solve);
		}
	}	
}

class SingletonLock {
}