package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
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
	public class ModifierPostDistord extends AbstractModifier
	{
		public var amount:Number;
		private var amountGoal:Number;
		
		private var increase:Boolean;
		private var inandout:Boolean;
		private var displMap:BitmapData;
		private var mat:Matrix = new Matrix();
		private var filter:DisplacementMapFilter;	
		private var bytes:ByteArray = new ByteArray();
		private var blendMode:String;
		private var rc:Rectangle;
		
		private var _assets:Assets;
		public function ModifierPostDistord(amount:int = 100, increase:Boolean = false, inandout:Boolean = false, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			this.increase = increase;
			this.inandout = inandout;
			this.amountGoal = amount;
			this.amount = 0;
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
			
			displMap = new BitmapData(w,h,false,0);
			filter = new DisplacementMapFilter(displMap, pt, BitmapDataChannel.BLUE, 0, amount,0,DisplacementMapFilterMode.CLAMP,0x000000,0);
			rc = new Rectangle(0,0,w,h/128);
			
			this.amount = amountGoal;
		}
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this._assets = null;
			displMap.dispose();
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
			if(increase) amount = amountGoal * data.lifeTime;
			
			if(inandout) amount = amountGoal * Math.sin( Math.PI + data.lifeTime * Math.PI*2);
			
			filter.scaleX = amount * _assets.channel.leftPeak;
			
			SoundMixer.computeSpectrum(bytes, true, 4);
			if(bytes.length != 2048) return;
			
			var value:Number;
			var i:int = 0;
			var smooth:Number;
			var j:Number = 0;
			while(i<128)
			{
				value = bytes.readFloat();
				i++;
			}
			i=0;
			
			while(i<128)
			{
				value = bytes.readFloat();
				if( i == 0 ) smooth = value;
				else smooth += ( value - smooth ) / 8;
				i++;
				rc.y = j;
				value = (smooth*2 * 0x60 + 0xa0); 
				displMap.fillRect(rc, value);
				j+=(h/128);
			}
			
			bit.applyFilter(bit, rect, pt, filter);
			
		}
	}
}