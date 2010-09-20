package project.utils
{
	import flash.display.Shape;
	import flash.events.ProgressEvent;
	
	public class LoadingScreen extends Shape
	{
		private var w:int;
		private var h:int;
		private var ws:int;
		private var hs:int;
		
		public function LoadingScreen(width:int, height:int)
		{
			this.w = width;
			this.h = height;
			this.ws = width >> 1;
			this.hs = height >> 1;
		}
		
		public function progress(event:ProgressEvent):void
		{
			graphics.clear();
			graphics.beginFill(0x333333, 1);
			graphics.drawRect(ws - 10, hs - 50, 20, 100-100*(event.bytesLoaded / event.bytesTotal));
			graphics.endFill();
		}
	}
}

