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
	public class ModifierPostGlow extends AbstractModifier
	{
		private var bloomer:BlurFilter;
		private var t:BitmapData;
		private var strong:ColorTransform = new ColorTransform();
		private var _assets:Assets;
		private var threshold:int;
		
		private var scaleUp:Matrix
		private var scaleDown:Matrix;
		private var scaleRatio:int;
		private var blendmode:String;
		
		private var redValue:Number;
		private var greenValue:Number;
		private var blueValue:Number;
		
		public function ModifierPostGlow(assets:AbstractAssets, bloomAmount:int = 32, scaleRatio:int = 4, strong:Number = 0.4, redValue:Number = 0.3, greenValue:Number = 0.4, blueValue:Number = 0.5, blendmode:String = BlendMode.ADD, id:String = "")
		{
			super(assets, id);
			this.type = ModifierType.POSTPROCESS;
			this._assets = assets as Assets;
			
			this.bloomer = new BlurFilter(bloomAmount, bloomAmount, 1);
			this.strong.alphaMultiplier = strong;
			this.blendmode = blendmode;
			this.scaleRatio = scaleRatio;
			
			this.redValue = redValue;
			this.blueValue = blueValue;
			this.greenValue = greenValue;
			
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
			
			t.unlock();
			
			var val:Number = _assets.channel.leftPeak;
			strong.redMultiplier = 1 + val * redValue;
			strong.greenMultiplier = 1 + val * greenValue;
			strong.blueMultiplier = 1 + val * blueValue;
			
			bit.draw(t, scaleUp, strong, blendmode);
			
		}
	}
}