package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
	public class ModifierPostFishEye2 extends AbstractModifier
	{
		public var amount:Number;
		private var amountGoal:Number;
		
		private var increase:Boolean;
		private var dur:Number;
		private var start:int;
		private var displMap:BitmapData;
		private var scaleMatrix:Matrix = new Matrix();
		
		private var mat:Matrix = new Matrix();
		private var filter:DisplacementMapFilter;	
		
		private var dirXY:Point;
		private var radius:Number;
		
		private var frect:Rectangle;
		private var fpt:Point = new Point();
		
		private var _assets:Assets;
		public function ModifierPostFishEye2(amount:int = 100, radius:Number = 200, dirXY:Point = null, increase:Boolean = false, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			this.increase = increase;
			this.amountGoal = amount;
			this.amount = 0;
			
			this.radius = radius;
			this.dirXY = dirXY || new Point(1, 1);
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
			
			displMap = new BitmapData(w, h, false, 0x808080);
			var mtrx:Matrix = new Matrix();
			mtrx.translate(displMap.width >> 1, displMap.height >> 1);
			displMap.draw(createDisplacementMap(radius), mtrx);
			
			filter = new DisplacementMapFilter(displMap, pt, 1, 2, 0,0,DisplacementMapFilterMode.COLOR,0x000000,0);
			
			//frect = new Rectangle(200,0,400,400);
			
			//fpt.x = ws - (frect.width >> 1)
			//fpt.y = hs - (frect.height >> 1)
			//trace(fpt.x)
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
		private var offX:Number = 0;
		private var offY:Number = 0;
		override public function render(data:RenderData):void
		{
			if(increase) amount = amountGoal * (((getTimer() - start) * .001) / dur);
			
			var lp:Number = _assets.channel.leftPeak; 
			var rp:Number = _assets.channel.rightPeak;
			
			//if(lp < .1 && rp < .1) return
				
			offX = offX + (lp - offX) * .5;
			offY = offY + (rp - offY) * .5;
			
			filter.scaleX = 50 + amount * offX;
			filter.scaleY = 50 + amount * offY;
			bit.applyFilter(bit, rect, pt, filter);
		}
		
		
		private function createDisplacementMap(radius:Number) : Sprite 
		{
			var redShape:Sprite = new Sprite();
			var graphics:Graphics = redShape.graphics;
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR, [0xFF0000, 0x000000], [1, 1], [0, 255])
			graphics.drawCircle(0, 0, radius);	
			graphics.endFill();
			
			var greenShape:Sprite = new Sprite();
			graphics = greenShape.graphics;
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR, [0x00ff00,0x000000], [1,1],[0,255])
			graphics.drawCircle(0, 0, radius);	
			graphics.endFill();
			
			var gradientMatrix:Matrix  = new Matrix(1, 0, 0, 1, 1, 1);
			gradientMatrix.createGradientBox(radius*2,radius*2,0,-radius,-radius)
			var addShape:Sprite = new Sprite();
			graphics = addShape.graphics;
			graphics.clear();
			graphics.beginGradientFill(GradientType.RADIAL, [0x808080,0x808080], [0,1],[0,255],gradientMatrix)	
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
			
			var bgShape:Sprite = new Sprite();
			graphics = bgShape.graphics;
			graphics.clear();
			graphics.beginFill(0x808080);
			graphics.drawRect(-radius,-radius,radius*2,radius*2)
			graphics.endFill()
			
			bgShape.addChild(redShape);
			greenShape.rotation = 90;
			greenShape.blendMode = BlendMode.ADD;
			redShape.addChild(greenShape);
			redShape.addChild(addShape);
			return bgShape;
		}
	}
}