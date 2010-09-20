package project.demo.modifier.overlay
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
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
		public static const FIX_LEFT		:String = "fix_left";
		public static const FIX_RIGHT		:String = "fix_right";
		public static const FIX_CENTER		:String = "fix_center";
		
		private var matrix:Matrix = new Matrix(1, 0, 0, 1, 200, 200);
		private var t:Number;
		private var firstPass:Boolean = false;
		private var ct:ColorTransform;
		private const alphaTime:int = 1000;
		private var copy:String;
		private var fontSize:int;
		private var margin:int;
		
		private var fadeIn:Number;
		private var fadeOut:Number;
		
		private var tfBit:BitmapData;
		private var color:uint;
		
		private var effect:BitmapData;
		
		private var displacement:DisplacementMapFilter;
		
		private var xPos:int, yPos:int;
		//private var alignRight:Boolean = false;
		private var fix:String = FIX_CENTER;
		
		private var _assets:Assets;
		public function ModifierOverlayText(copy:String, fontSize:Number, xPos:int, yPos:int, color:uint = 0x000000, margin:int = 10, fix:String = "left", id:String = "")
		{
			super(id);
			this.type = ModifierType.OVERLAY;
			
			//if(fix == FIX_RIGHT) alignRight = true;
			this.fix = fix;
			this.xPos = xPos;
			this.yPos = yPos;
			
			this.color = color;
			this.margin = margin;
			ct = new ColorTransform();
			this.copy = copy;
			this.fontSize = fontSize;
			
			var mapPoint:Point       = pt;
			var channels:uint        = BitmapDataChannel.RED;
			var componentX:uint      = channels;
			var componentY:uint      = channels;
			var scaleX:Number        = 10;
			var scaleY:Number        = 0;
			var mode:String          = DisplacementMapFilterMode.CLAMP;
			var color:uint           = 0;
			var alpha:Number         = 0;
			displacement = new DisplacementMapFilter(	null,
				mapPoint,
				componentX,
				componentY,
				scaleX,
				scaleY,
				mode,
				color,
				alpha);
			
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
			
			var textfield:TextField = new TextField();
			
			var format:TextFormat = new TextFormat();
			format.font = _assets.font_helvetica_neue.fontName;
			format.size = fontSize
			format.color = color;
			format.letterSpacing = 1.5;
			format.rightMargin = 10;
			format.leftMargin = 10;
			
			//textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.defaultTextFormat = format;
			
			textfield.antiAliasType = AntiAliasType.ADVANCED;
			textfield.thickness = -60;
			textfield.sharpness = 0;
			textfield.selectable = false;
			
			
			textfield.embedFonts = true;
			textfield.htmlText = copy;
			textfield.height = 60;
			textfield.width = w;
			
			//textfield.filters = [new DropShadowFilter(0, 45, 0x000000, 0.2, 6, 6, 2), new GlowFilter(0xFFFFFF, 0.2, 6, 6, 2, 3)];
			textfield.filters = [new GlowFilter(0xFFFFFF, 0.2, 6, 6, 2, 3)];
			
			
			tfBit = new BitmapData(textfield.textWidth + (margin << 1)+20, textfield.textHeight + (margin << 1)+10, true, 0);
			tfBit.draw(textfield, new Matrix(1, 0, 0, 1, margin, margin));
			
			textfield.filters = null;
			textfield = null;
			
			t = data.time;
			fadeIn = t+alphaTime;
			fadeOut = endTime-alphaTime;
			
			effect = tfBit.clone();
			//effect.noise(1, 0, 255, 1, true);
			effect.perlinNoise(100, 4, 1, 1, true, true, 1, true, offset);
			displacement.mapBitmap = effect;
			
			if(fix == FIX_RIGHT)
			{
				matrix.tx = w - tfBit.width - xPos - margin;
			}
			else if(fix == FIX_LEFT)
			{
				matrix.tx = xPos + margin;
			}
			else
			{
				matrix.tx = ws - (tfBit.width >> 1);//xPos + margin;
			}
			
			matrix.ty = yPos - margin;
			
		}
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this._assets = null;
			
			tfBit.dispose();
			effect.dispose();
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
		private var offset:Array = new Array(new Point());
		private var val:Number;
		override public function render(data:RenderData):void
		{
			if(data.time < fadeIn)
			{
				ct.alphaMultiplier = (data.time-t)/alphaTime;
			} 
			else if(data.time > fadeOut)
			{
				ct.alphaMultiplier = (endTime-data.time)/alphaTime;
			}
			else
			{
				ct.alphaMultiplier = 1;
			}
			
			bit.draw(tfBit, matrix, ct);//, BlendMode.INVERT);
			
		}
	}
}