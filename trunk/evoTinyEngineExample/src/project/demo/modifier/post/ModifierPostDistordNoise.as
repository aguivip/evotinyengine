package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
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
	public class ModifierPostDistordNoise extends AbstractModifier
	{
		public var amount:Number;
		private var amountGoal:Number;
		
		private var increase:Boolean;
		private var dur:Number;
		private var start:int;
		private var displMap:BitmapData;
		private var disp:BitmapData;
		private var scaleMatrix:Matrix = new Matrix();
		private var quality:int;
		
		private var mat:Matrix = new Matrix();
		private var filter:DisplacementMapFilter;	
		private var bytes:ByteArray = new ByteArray();
		private var blendMode:String;
		private var rc:Rectangle;
		
		private var blur:BlurFilter;
		private var blurValue:int;
		
		private var _assets:Assets;
		public function ModifierPostDistordNoise(assets:AbstractAssets, amount:int = 100, quality:int = 2, blur:int = 0, increase:Boolean = false, id:String = "")
		{
			super(assets, id);
			this.type = ModifierType.POSTPROCESS;
			this._assets = assets as Assets;
			
			this.increase = increase;
			this.amountGoal = amount;
			this.amount = 0;
			
			this.quality = quality;
			this.blurValue = blur;
			this.blur = new BlurFilter(blurValue, blurValue, 1);
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			displMap = new BitmapData(w, h, false, 0);
			disp = new BitmapData(w >> quality, h >> quality, false, 0);
			
			scaleMatrix.scale(w / disp.width, h / disp.height);
			
			filter = new DisplacementMapFilter(displMap, pt, BitmapDataChannel.RED, BitmapDataChannel.BLUE, amount,0,DisplacementMapFilterMode.CLAMP,0x000000,0);
			rc = new Rectangle(0,0,w,h/128);
			
			if(!increase)
			{
				this.amount = amountGoal;
			}else
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
			displMap.dispose();
			disp.dispose();
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
			if(increase) amount = amountGoal * (((getTimer() - start) * .001) / dur);
			
			filter.scaleX = amount * _assets.channel.leftPeak;
			filter.scaleY = amount * _assets.channel.rightPeak;
			
			disp.noise(data.tickCount, 0, 255, 5, false);
			if(blurValue) disp.applyFilter(disp, disp.rect, pt, blur);
			displMap.draw(disp, scaleMatrix);
			bit.applyFilter(bit, rect, pt, filter);
			
			//bit.draw(displMap);
		}
	}
}