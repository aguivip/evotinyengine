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
	public class ModifierPostBloom extends AbstractModifier
	{
		private var bloomer:BlurFilter;
		private var t:BitmapData;
		private var blooms:int = 2;
		private var bloomAmount:int = 32;
		
		private var _assets:Assets;
		public function ModifierPostBloom(bloomAmount:int = 32, blooms:int = 2, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			this.bloomAmount = bloomAmount;
			this.blooms = blooms;
			this.bloomer = new BlurFilter(bloomAmount, bloomAmount, 1);
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
			t.applyFilter(bit, rect, pt, bloomer);
			t.unlock();
			
			for(var i:int = 0; i < blooms; i++)
			{
				t.lock();
				t.applyFilter(t, rect, pt, bloomer);
				t.unlock();
				bit.draw(t, null, null, BlendMode.ADD);
			}
			
		}
		
	}
}