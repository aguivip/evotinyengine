package project.utils
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	import project.command.CDelayedDispatch;

	public class Fullscreen extends Sprite
	{
		public static const EVENT_SELECTED:String = "event_selected";
		
		private var gfx:WindowSelection;
		
		private var _stage:Stage;
		private var w:int;
		private var h:int;
		
		public function Fullscreen(stage:Stage, width:int = 0, height:int = 0)
		{
			this._stage = stage;
			this._stage.addEventListener(KeyboardEvent.KEY_UP, fullscreen);
			
			this.w = width;
			this.h = height;
			
			gfx = new WindowSelection();
			gfx.btn_f.stop();
			gfx.btn_w.stop();
			gfx.x = int((stage.stageWidth >> 1) - (gfx.width >> 1));
			gfx.y = int((stage.stageHeight >> 1) - (gfx.height >> 1));
			this.addChild(gfx);
			
			gfx.btn_f.addEventListener(MouseEvent.MOUSE_OVER, mouseover);
			gfx.btn_f.addEventListener(MouseEvent.MOUSE_OUT, mouseout);
			gfx.btn_f.addEventListener(MouseEvent.MOUSE_DOWN, mousedown);
			gfx.btn_f.addEventListener(MouseEvent.MOUSE_UP, mouseup);
			
			gfx.btn_w.addEventListener(MouseEvent.MOUSE_OVER, mouseover);
			gfx.btn_w.addEventListener(MouseEvent.MOUSE_OUT, mouseout);
			gfx.btn_w.addEventListener(MouseEvent.MOUSE_DOWN, mousedown);
			gfx.btn_w.addEventListener(MouseEvent.MOUSE_UP, mouseup);
			
			gfx.btn_f.buttonMode = true;
			gfx.btn_w.buttonMode = true;
			
		}
		
		private function mouseover(event:MouseEvent):void
		{
			(event.currentTarget as MovieClip).gotoAndStop(2);
		}
		
		private function mouseout(event:MouseEvent):void
		{
			(event.currentTarget as MovieClip).gotoAndStop(1);
		}
		
		private function mousedown(event:MouseEvent):void
		{
			(event.currentTarget as MovieClip).gotoAndStop(3);
		}
		
		private function mouseup(event:MouseEvent):void
		{
			(event.currentTarget as MovieClip).gotoAndStop(2);
			if(event.currentTarget == gfx.btn_f)
			{
				this.selectFullscreen();
			}
			else
			{
				this.selectWindow();
			}
			
			this.dispose();
		}
		
		
		private function fullscreen(event:KeyboardEvent):void
		{
			if(event.keyCode != 27 && event.keyCode == 70)
			{
				setFullScreen();
			}
			else if(event.keyCode == 27)
			{
				Mouse.show();
			}
		}
		
		private function selectFullscreen(event:Event = null):void
		{
			setFullScreen();
			new CDelayedDispatch(this, EVENT_SELECTED, .1);
		}
		
		private function selectWindow(event:Event = null):void
		{
			new CDelayedDispatch(this, EVENT_SELECTED, .1);
		}
		
		private function setFullScreen(event:Event = null):void
		{
			if(!w)
			{
				w = this._stage.stageWidth;
			}
			if(!h)
			{
				h = this._stage.stageHeight;
			}
			this._stage.fullScreenSourceRect = new Rectangle(0, 0, w, h);
			this._stage.displayState = FullScreenEvent.FULL_SCREEN;
			Mouse.hide();
		}
		
		public function dispose():void
		{
			gfx.btn_f.removeEventListener(MouseEvent.MOUSE_OVER, mouseover);
			gfx.btn_f.removeEventListener(MouseEvent.MOUSE_OUT, mouseout);
			gfx.btn_f.removeEventListener(MouseEvent.MOUSE_DOWN, mousedown);
			gfx.btn_f.removeEventListener(MouseEvent.MOUSE_UP, mouseup);
			
			gfx.btn_w.removeEventListener(MouseEvent.MOUSE_OVER, mouseover);
			gfx.btn_w.removeEventListener(MouseEvent.MOUSE_OUT, mouseout);
			gfx.btn_w.removeEventListener(MouseEvent.MOUSE_DOWN, mousedown);
			gfx.btn_w.removeEventListener(MouseEvent.MOUSE_UP, mouseup);
			
			this.removeChild(gfx);
			this.gfx = null;
			
			this.parent.removeChild(this);
		}
		
	}
}