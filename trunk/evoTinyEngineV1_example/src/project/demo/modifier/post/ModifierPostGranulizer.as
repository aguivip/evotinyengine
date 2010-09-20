package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
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
	public class ModifierPostGranulizer extends AbstractModifier
	{
		private var mat:Matrix = new Matrix();
		private var cuts:int = 1;
		private var blur:BlurFilter = new BlurFilter(2,2,1);
		private var noiseMap:BitmapData;
		
		private var _assets:Assets;
		public function ModifierPostGranulizer(assets:AbstractAssets, id:String = "")
		{
			super(assets, id);
			this.type = ModifierType.POSTPROCESS;
			this._assets = assets as Assets;
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			noiseMap = new BitmapData(w, h, true, 0);
		}
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this._assets = null;
			noiseMap.dispose();
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
			noiseMap.lock();						
			noiseMap.noise(data.deltatime, 255-_assets.channel.leftPeak*128,255, BitmapDataChannel.ALPHA,true);
			noiseMap.applyFilter(noiseMap,rect,pt,blur);
			noiseMap.unlock();		
			bit.draw(noiseMap, mat, null, BlendMode.MULTIPLY);
		}
	}
}