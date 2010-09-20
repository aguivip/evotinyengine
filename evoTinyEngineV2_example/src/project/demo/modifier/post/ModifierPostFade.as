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
	import flash.display.Shape;
	import flash.display.SpreadMethod;
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
	public class ModifierPostFade extends AbstractModifier
	{
		public static const FADE_OUT	:String = "fade_out";
		public static const FADE_IN		:String = "fade_in";
		
		private var fade:String;
		
		private var color:BitmapData;
		private var _color:int;
		private var ct:ColorTransform = new ColorTransform();
		
		private var grap:Shape = new Shape();
		private var gfx:Graphics = grap.graphics;
		
		private var _assets:Assets;
		public function ModifierPostFade(color:int, fade:String = ModifierPostFade.FADE_IN, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			this._color = color;
			this.fade = fade;
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
			
			this.color = bit.clone();
			this.color.fillRect(rect, _color);
			
		}
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this._assets = null;
			color.dispose();
			
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
			if(fade == FADE_IN)
			{
				ct.alphaMultiplier = data.lifeTime;
			}
			else
			{
				ct.alphaMultiplier = 1-data.lifeTime;
			}
			
			this.bit.draw(this.color, null, ct);
			
		}
		
		
	}
}