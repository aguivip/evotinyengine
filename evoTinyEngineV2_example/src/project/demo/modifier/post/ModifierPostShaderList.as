package project.demo.modifier.post
{
	import evoTinyEngine.assets.AbstractAssets;
	import evoTinyEngine.data.RenderData;
	import evoTinyEngine.event.SoundHitEvent;
	import evoTinyEngine.modifier.AbstractModifier;
	import evoTinyEngine.modifier.ModifierType;
	
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.events.MouseEvent;
	
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
	public class ModifierPostShaderList extends AbstractModifier
	{
		private var shaders:Vector.<Shader>;
		private var input:BitmapData;
		private var length:int;
		
		private var _assets:Assets;
		public function ModifierPostShaderList(shaders:Array, id:String = "")
		{
			super(id);
			this.type = ModifierType.POSTPROCESS;
			
			length = shaders.length;
			this.shaders = new Vector.<Shader>(length, true);
			for(var i:int = 0; i < length; i++)
			{
				this.shaders[i] = shaders[i];
			}
		}
		
		/**
		 * Initialize this modifier.
		 * Called ones when added to playlist.
		 */
		override protected function initializeModifier(data:RenderData):void
		{
			this._assets = this.assets as Assets;
			
			for(var i:int = 0; i < length; i++)
			{
				this.shaders[i].data.source.input = input = bit.clone();
			}
		}
		
		
		/**
		 * Dispose this modifier.
		 * Called ones after time is up.
		 */
		override protected function disposeModifier():void
		{
			this._assets = null;
			for(var i:int = 0; i < length; i++)
			{
				this.shaders[i].data.source.input.dispose();
				this.shaders[i] = null;
			}
			this.shaders = null;
			this.input.dispose();
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
			for(var i:int = 0; i < length; i++)
			{
				input.copyPixels(bit, rect, pt);
				new ShaderJob(shaders[i], bit).start(true);
			}
		}
	}
}