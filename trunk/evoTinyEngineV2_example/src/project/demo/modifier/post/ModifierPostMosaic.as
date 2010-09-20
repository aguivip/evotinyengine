package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
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
	public class ModifierPostMosaic extends AbstractModifier
	{
		private var strong:ColorTransform;
		private var scaleRatio:int;;
		private var scaleDown:Matrix;
		private var scaleUp:Matrix;
		private var blendMode:String;
		
		private var t:BitmapData;
		
		private var _assets:Assets;
		public function ModifierPostMosaic(scaleRatio:int, strong:Number, blendMode:String, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			this.strong = new ColorTransform(1, 1, 1, strong);
			this.scaleRatio = scaleRatio;
			
			this.scaleUp = new Matrix();
			this.scaleUp.scale(scaleRatio, scaleRatio);
			
			this.scaleDown = new Matrix();
			this.scaleDown.scale(1 / scaleRatio, 1 / scaleRatio);
			
			this.blendMode = blendMode;
			
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
			t.draw(bit, scaleDown, strong);
			bit.draw(t, scaleUp, strong, blendMode);
		}
		
	}
}