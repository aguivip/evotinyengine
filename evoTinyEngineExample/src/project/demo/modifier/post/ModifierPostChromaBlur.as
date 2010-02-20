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
	public class ModifierPostChromaBlur extends AbstractModifier
	{
		private var clipMatrix:Matrix;
		public var offsetScale:Number = 5;
		private var blurColor1:ColorTransform;
		private var blurColor2:ColorTransform;
		private var blurColor3:ColorTransform;
		private var blurFilter:BlurFilter;
		public var mode:String;
		private	var mat:Matrix = new Matrix();
		private var input:BitmapData;
		
		private var _assets:Assets;
		public function ModifierPostChromaBlur(assets:AbstractAssets, offsetScale:Number = 5, blurColor1:ColorTransform = null, blurColor2:ColorTransform = null, blurColor3:ColorTransform = null, id:String = "")
		{
			super(assets, id);
			this.type = ModifierType.POSTPROCESS;
			this._assets = assets as Assets;
			
			this.offsetScale = offsetScale;
			
			this.blurColor1 = blurColor1 || new ColorTransform(.75,.25,0,1,0,0,0,0);
			this.blurColor2 = blurColor2 || new ColorTransform(.25,0.50,.25,1,0,0,0,0);
			this.blurColor3 = blurColor3 || new ColorTransform(0,.25,.75,1,0,0,0,0);
			this.mode = BlendMode.ADD;
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			input = new BitmapData(bit.width, bit.height, true, 0);
		}
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this._assets = null;
			input.dispose();
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
			var peak:Number = _assets.channel.leftPeak;
			if(peak > 0.80)
				offsetScale = offsetScale * 0.9 + peak*20 * 0.1;
			else
				offsetScale = offsetScale * 0.9;
					
			input.copyPixels(bit, rect, pt);
			
			mat.identity();
			mat.tx = -offsetScale*0.7;
			bit.draw(input,mat,blurColor1,mode);
			mat.tx = 0;
			mat.ty = +offsetScale;			
			bit.draw(input,mat,blurColor2,mode);
			mat.tx = +offsetScale*0.7;
			mat.ty = 0;
			bit.draw(input,mat,blurColor3,mode);
		}
	}
}