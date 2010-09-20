package evoTinyEngine.canvas
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public class AbstractCanvas extends Bitmap implements ICanvas
	{
		public function AbstractCanvas(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		public function dispose():void
		{
			this.bitmapData.dispose();
		}
	}
}