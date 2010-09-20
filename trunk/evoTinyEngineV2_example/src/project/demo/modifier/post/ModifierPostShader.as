package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.events.MouseEvent;
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
	public class ModifierPostShader extends AbstractModifier
	{
		private var shader:Shader;
		
		private var _assets:Assets;
		public function ModifierPostShader(shader:Shader, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			this.shader = shader;
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
			
			this.shader.data.source.input = bit;
		}
		
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this.shader.data.source.input.dispose();
			this.shader = null;
		}
		
		/**
		 * Handle mouseevents
		 */
		override public function mouseHit(event:MouseEvent):void
		{
			
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
		 * 
		 * @param data RenderData
		 */
		override public function render(data:RenderData):void
		{
			new ShaderJob(shader, bit).start(true);
		}
	}
}