package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
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
	public class ModifierPostRadial extends AbstractModifier
	{
		private var layers:int;
		private var zoom:Number;
		private var alphaFade:Number;
		private var ct:ColorTransform = new ColorTransform();
		private var scaleMatrix:Matrix;
		private var blendMode:String = null;
		
		private var _assets:Assets;
		public function ModifierPostRadial(assets:AbstractAssets, layers:int = 5, zoom:Number = 0.1, alphaFade:Number = 0.2, blendMode:String = BlendMode.LIGHTEN, id:String = "")
		{
			super(assets, id);
			this.type = ModifierType.POSTPROCESS;
			this._assets = assets as Assets;
			
			this.layers = layers;
			this.zoom = zoom;
			this.alphaFade = alphaFade;
			this.blendMode = blendMode;
			
			scaleMatrix = new Matrix();
			ct.alphaMultiplier = alphaFade;
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
		}
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this._assets = null;
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
			var zoomRatio:Number;
			for(var i:int = i; i < layers; i++)
			{
				zoomRatio = zoom*i;
				scaleMatrix.d = scaleMatrix.a = 1+zoomRatio;
				scaleMatrix.tx = -w * zoomRatio*0.5;
				scaleMatrix.ty = -h * zoomRatio*0.5;
				bit.draw(bit, scaleMatrix, ct, this.blendMode, rect, false);
			}
		}
	}
}