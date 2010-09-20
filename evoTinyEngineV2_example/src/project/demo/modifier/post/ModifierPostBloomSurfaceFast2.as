package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
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
	public class ModifierPostBloomSurfaceFast2 extends AbstractModifier
	{
		private var bloomer:BlurFilter;
		private var soft:BlurFilter;
		private var t:BitmapData;
		private var strong:ColorTransform = new ColorTransform();
		private var _assets:Assets;
		private var threshold:int;
		
		private var scaleUp:Matrix
		private var scaleDown:Matrix;
		private var scaleRatio:int;
		private var blendmode:String;
		
		public function ModifierPostBloomSurfaceFast2(bloomAmount:int = 32, softAmount:int = 16, scaleRatio:int = 4, threshold:int = 32, strong:Number = 0.4, blendmode:String = BlendMode.ADD, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			this.bloomer = new BlurFilter(bloomAmount, bloomAmount, 1);
			this.soft = new BlurFilter(softAmount, softAmount, 3);
			this.strong.alphaMultiplier = strong;
			this.blendmode = blendmode;
			this.scaleRatio = scaleRatio;
			
			this.threshold = ( 0 | threshold << 16 | 0 | 0 );
			
			scaleUp = new Matrix();
			scaleUp.scale(scaleRatio, scaleRatio);
			
			scaleDown = new Matrix();
			scaleDown.scale(1 / scaleRatio, 1 / scaleRatio);
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
			
			t = new BitmapData(bit.width / scaleRatio, bit.height / scaleRatio, true, 0);
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
			bit.draw(t, scaleUp, strong, blendmode);
			
			
			t.lock();
			t.draw(bit, scaleDown);
			t.applyFilter(t, rect, pt, bloomer);
			
			if(threshold) t.threshold(t, rect, pt, "<", threshold, 0x00000000, 0x00FF0000, false);
			if(soft) t.applyFilter(t, rect, pt, soft);
			
			t.unlock();
			
			bit.draw(t, scaleUp, strong, blendmode);
			
		}
	}
}