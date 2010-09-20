package project.demo.modifier
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
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
	public class ModifierEmpty extends AbstractModifier
	{
		
		private var _assets:Assets;
		public function ModifierEmpty(id:String = "")
		{
			super(id);
			this.type = ModifierType.EFFECT;
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
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
		 * Handle soundEvents
		 */
		override public function soundHit(event:SoundHitEvent):void
		{
			//trace(event.a);
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
			this.bit.fillRect(this.rect, 0xFFFF0000);
			
			var l:int = 2000;
			for(var i:int = 0; i < l; i++)
			{
				this.bit.setPixel(ws + 100*Math.sin(Math.PI*2*Math.random()), hs + 100*Math.cos(Math.PI*2*Math.random()), 0xFFFFFF);
			}
		}
	}
}