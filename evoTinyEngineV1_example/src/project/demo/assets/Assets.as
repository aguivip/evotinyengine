package project.demo.assets
{
	import evoTinyEngine.assets.AbstractAssets;
	
	import flash.display.Stage;

	public class Assets extends AbstractAssets
	{
		
		public function Assets(width:int, height:int, transparent:Boolean = true, color:uint = 0x00000000)
		{
			super(width, height, transparent, color);
			
			
		}
		
		public var stage:Stage;
		
		public const COLOR_RED		:uint = 0xFF0000;
		public const COLOR_RED32	:uint = 0xFFFF0000;
		
	}
}