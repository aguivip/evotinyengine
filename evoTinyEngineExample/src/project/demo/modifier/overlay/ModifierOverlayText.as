package project.demo.modifier.overlay
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
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
	public class ModifierOverlayText extends AbstractModifier
	{
		private var matrix:Matrix = new Matrix(1, 0, 0, 1, 200, 200);
		private var t:Number;
		private var firstPass:Boolean = false;
		private var ct:ColorTransform;
		private const alphaTime:int = 500;
		private var copy:String;
		private var fontSize:int;
		private var margin:int;
		
		private var tfBit:BitmapData;
		private var color:uint;
		
		private var _assets:Assets;
		public function ModifierOverlayText(assets:AbstractAssets, copy:String, fontSize:Number, xPos:int, yPos:int, color:uint = 0xFFFFFF, margin:int = 10, id:String = "")
		{
			super(assets, id);
			this.type = ModifierType.OVERLAY;
			this._assets = assets as Assets;
			
			this.color = color;
			this.margin = margin;
			ct = new ColorTransform();
			matrix.tx = xPos - margin;
			matrix.ty = yPos - margin;
			this.copy = copy;
			this.fontSize = fontSize;
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			var textfield:TextField = new TextField();
			
			var format:TextFormat = new TextFormat();
			format.size = fontSize
			format.color = this.color;
			format.letterSpacing = 1;
			
			textfield.textColor = color;
			
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.defaultTextFormat = format;
			
			textfield.antiAliasType = AntiAliasType.ADVANCED;
			textfield.selectable = false;
			
			textfield.htmlText = copy;
			
			textfield.filters = [new DropShadowFilter(0, 45, 0x000000, 0.4, 6, 6, 3)];
			
			
			tfBit = new BitmapData(textfield.textWidth + (margin << 1), textfield.textHeight + (margin << 1), true, 0);
			tfBit.draw(textfield, new Matrix(1, 0, 0, 1, margin, margin));
			
			textfield.filters = null;
			textfield = null;
			
			t = data.time;
		}
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this._assets = null;
			tfBit.dispose();
		}
		
		/**
		 * Handle soundEvents
		 */
		override public function soundHit(event:SoundHitEvent):void
		{
			
		}
		
		/**
		 * Render this modifier.
		 * data contains usefull variables:
		 * time:int 		// passed time from beginning
		 * deltatime:int	// deltatime, time from last render
		 * sndValue:int 	// sound hit value
		 * lifeTime:Number  // 0-1 lifetime
		 * 
		 * @param data RenderData
		 */
		override public function render(data:RenderData):void
		{
			if(data.time < t+alphaTime){
				ct.alphaMultiplier = (data.time-t)/alphaTime;
			} else if(data.time > endTime-alphaTime){
				ct.alphaMultiplier = (endTime-data.time)/alphaTime;
			}
			
			bit.draw(tfBit, matrix, ct);
		}
	}
}