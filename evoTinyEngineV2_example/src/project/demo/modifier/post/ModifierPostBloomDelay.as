package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	
	import project.demo.assets.Assets;

	/**
	 * Inherited usefull variables:
	 * 
	 * assets:AbstractAssets 	// reference to demo's Assets class
	 * bit:BitmapData 			// main bitmapData ("Canvas") 
	 * rect:Rectangle			// Rectangle of "Canvas"
	 * w:int					// width of "Canvas"
	 * h:int					// height of "Canvas"
	 * ws:int					// devided width of "Canvas"
	 * hs:int					// devided height of "Canvas"
	 * start:int				// start time of this Modifier
	 * end:int					// end time of this Modifier
	 * duration:int				// duration of this Modiefier
	 * 
	 * @author EvoFlash (evo.bombsquad.org)
	 */
	public class ModifierPostBloomDelay extends AbstractModifier
	{
		public static const FADE_NONE	:String = "fade_none";
		public static const FADE_OUT	:String = "fade_out";
		public static const FADE_IN		:String = "fade_in";
		
		private var fade:String;
		private var value:Number = 1;
		private var dur:Number;
		private var start:int;
		
		private var bloomer:BlurFilter;
		private var t:BitmapData;
		private var blooms:int = 2;
		private var bloomAmount:int = 32;
		private var ct:ColorTransform = new ColorTransform();
		private var strong:ColorTransform = new ColorTransform();
		private var alpha:ColorTransform = new ColorTransform();
		private var _strong:Number;
		private var _assets:Assets;
		private var colormatrixfilter:ColorMatrixFilter;
		public function ModifierPostBloomDelay(bloomAmount:int = 32, blooms:int = 2, alpha:Number = 0.4, strong:Number = 0.6, color:uint = 0, colorAmount:Number = 0, fade:String = ModifierPostBloomDelay.FADE_NONE, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			this.fade = fade;
			
			this.bloomAmount = bloomAmount;
			this.blooms = blooms;
			this.bloomer = new BlurFilter(bloomAmount, bloomAmount, 1);
			this.ct.alphaMultiplier = alpha;
			this._strong = this.strong.alphaMultiplier = strong;
			
			if(colorAmount)
			{
				var r:Number = ( ( color >> 16 ) & 0xff ) / 255;
				var g:Number = ( ( color >> 8  ) & 0xff ) / 255;
				var b:Number = (   color         & 0xff ) / 255;
				
				var inv_amount:Number = 1 - colorAmount;
				
				
				var colorMatrix:Array =  new Array( 	inv_amount + colorAmount*r*r_lum, colorAmount*r*g_lum,  colorAmount*r*b_lum, 0, 0,
														colorAmount*g*r_lum, inv_amount + colorAmount*g*g_lum, colorAmount*g*b_lum, 0, 0,
														colorAmount*b*r_lum,colorAmount*b*g_lum, inv_amount + colorAmount*b*b_lum, 0, 0,
														0 , 0 , 0 , 1, 0 );
				colormatrixfilter = new ColorMatrixFilter(colorMatrix);
			}
		}
		
		private static var r_lum:Number = 0.212671;
		private static var g_lum:Number = 0.715160;
		private static var b_lum:Number = 0.072169;
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
			
			t = new BitmapData(bit.width, bit.height, true, 0);
			
			if(fade != FADE_NONE)
			{
				this.dur = this.duration * _assets.tickTime * .001;
				this.start = getTimer();
			}
		}
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this._assets = null;
			this.t.dispose();
		}
		
		/**
		 * Render this modifier.
		 * data contains usefull variables:
		 * time:int 		// passed time from beginning
		 * deltatime:int	// deltatime, time from last render
		 * sndValue:int 	// sound hit value
		 * 
		 * @param data RenderData
		 */
		override public function render(data:RenderData):void
		{
			t.lock();
			t.colorTransform(t.rect, ct);
			t.unlock();
			if(fade != FADE_NONE)
			{
				var time:int = getTimer();
				var factor:Number;
				if(fade == FADE_OUT)
				{
					factor = (1-((time - start) * .001) / dur);
				}
				else
				{
					factor = (((time - start) * .001) / dur);
				}
				
				strong.alphaMultiplier = _strong * factor;
				alpha.alphaMultiplier = factor;
			}
			bit.draw(t, null, alpha, BlendMode.ADD);
			for(var i:int = 0; i < blooms; i++)
			{
				t.lock();
				t.applyFilter(bit, rect, pt, bloomer);
				if(colormatrixfilter) t.applyFilter(t, rect, pt, colormatrixfilter);
				t.unlock();
				bit.draw(t, null, strong, BlendMode.ADD);
			}
		}
	}
}