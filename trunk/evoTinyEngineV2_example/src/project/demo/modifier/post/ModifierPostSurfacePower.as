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
	public class ModifierPostSurfacePower extends AbstractModifier
	{
		private var amount:int;
		private var blendmode:String;
		private var bloomer:BlurFilter;
		private var t:BitmapData;
		private var blooms:int = 2;
		private var bloomAmount:int = 32;
		private var ct:ColorTransform = new ColorTransform();
		private var strong:ColorTransform = new ColorTransform();
		private var _assets:Assets;
		
		private var colormatrixfilter:ColorMatrixFilter;
		
		public function ModifierPostSurfacePower(bloomAmount:int = 32, blooms:int = 2, alpha:Number = 0.4, strong:Number = 0.4, amount:int = 32, blendmode:String = BlendMode.HARDLIGHT, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			this.amount = amount;
			this.blendmode = blendmode;
			this.bloomAmount = bloomAmount;
			this.blooms = blooms;
			this.bloomer = new BlurFilter(bloomAmount, bloomAmount, 1);
			this.ct.alphaMultiplier = alpha;
			this.strong.alphaMultiplier = strong;
			
			colormatrixfilter = getTint(0xf3d40a, .5);
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
			
			t = new BitmapData(bit.width, bit.height, true, 0);
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
			
			bit.draw(t, null, null, BlendMode.ADD);
			for(var i:int = 0; i < blooms; i++)
			{
				t.lock();
				t.applyFilter(bit, rect, pt, bloomer);
				t.applyFilter(t, rect, pt, colormatrixfilter);
				t.threshold(t, rect, pt, "<", ( 0 | amount << 16 | 0 | 0 ), 0x00000000, 0x00FF0000, false);
				t.unlock();
				bit.draw(t, null, strong, blendmode);
			}
			
		}
		
		private static var r_lum:Number = 0.212671;
		private static var g_lum:Number = 0.715160;
		private static var b_lum:Number = 0.072169;
		private function getTint(rgb:Number, amount:Number):ColorMatrixFilter 
		{
			var r:Number = ( ( rgb >> 16 ) & 0xff ) / 255;
			var g:Number = ( ( rgb >> 8  ) & 0xff ) / 255;
			var b:Number = (   rgb         & 0xff ) / 255;
			
			if (!amount) amount = 1;
			var inv_amount:Number = 1 - amount;
			
			
			var colorMatrix:Array =  new Array( 	inv_amount + amount*r*r_lum, amount*r*g_lum,  amount*r*b_lum, 0, 0,
													amount*g*r_lum, inv_amount + amount*g*g_lum, amount*g*b_lum, 0, 0,
													amount*b*r_lum,amount*b*g_lum, inv_amount + amount*b*b_lum, 0, 0,
													0 , 0 , 0 , 1, 0 );
			return new ColorMatrixFilter(colorMatrix);
		}
	}
}