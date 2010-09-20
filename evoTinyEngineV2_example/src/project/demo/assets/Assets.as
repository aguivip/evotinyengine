package project.demo.assets
{
	import evoTinyEngine.assets.AbstractAssets;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	
	public class Assets extends AbstractAssets
	{
		
		public function Assets(width:int, height:int)
		{
			super(width, height);
		}
		
		// SYNC DATA
		//[Embed(source="/../ext/spiraloutsync",mimeType="application/octet-stream")]
		//private var _syncdata:Class;
		//public var syncdata:String = new String(new _syncdata());
		
		
		public var stage:Stage;
		
		
		// FONTS
		public var font_helvetica_neue:HelveticaNeue = new HelveticaNeue();
		
		
		// PIXEL BENDER KERNELS
		//[Embed(source="../../../../src/project/pb/pbj/TransWarp.pbj",mimeType="application/octet-stream")]
		//private var _shader0:Class;
		//public var shaderTransWarp:Shader = new Shader(new _shader0());
		
		
		// GFX from library.fla
		//public var bg0:BG0 = new BG0();
		
		
		/**
		 * HELPERS
		 **/
		
		public function drawGradient(color0:uint, color1:uint, width:int, height:int, rotation:Number = 90, alpha0:Number = 1, alpha1:Number = 1):BitmapData
		{
			var colorfield:BitmapData = new BitmapData(width, height, true, 0);
			
			var field:Sprite = new Sprite();
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [color0, color1];
			var alphas:Array = [alpha0, alpha1];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(width, height, (Math.PI / 180) * rotation, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			
			field.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			field.graphics.drawRect(0,0, width, height);
			field.graphics.endFill();
			
			colorfield.draw(field);
			
			return colorfield;
		}
		
	}
}