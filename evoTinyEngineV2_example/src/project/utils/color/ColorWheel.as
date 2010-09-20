/**
 *
 * ColorWheel
 * 	Draws a vector and bitmap colorwheel that contains 16.7million colors
 * 
 * @author Simo Santavirta - http://www.simppa.fi
 * @version 1.0
 * 
 * based on code of Paul Coyle
 * and Ryan Taylor
 * 
 */
package project.utils.color
{
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class ColorWheel extends ColorWheelMath
	{
		
		public var initialized		:Boolean = false;
		
		private var wheel			:Sprite;
		private var bitmapdata		:BitmapData;
		
		public function ColorWheel(radius:int = 100, brightness:Number = 1, init:Boolean = true) {
			
			wheel = new Sprite();
			
			this.radius = radius;
			
			this.brightness = brightness;
			
			if(init) create(radius,brightness);
			
		}
		
		public var radius			:int = 100;
		public var brightness		:Number = 1;
		public var marginal			:int = 8; // Safety for not getting bad results from outter radius of a circle with getPixel(); //You may consider this bad coding. :)
		
		public function get vectorWheel():Sprite {
			return wheel;
		}
		
		public function get bitmapwheel():BitmapData {
			return bitmapdata;
		}
		
		public function create(radius:int = 0,brightness:Number = 0):void {
			
			if(radius) {
				this.radius = radius;
			}else{
				radius = this.radius;
			}
			
			if(brightness) {
				this.brightness = brightness;
			}else{
				brightness = this.brightness;
			}
			
			var angle   	:Number;
			var color     	:int;
			var matrix  	:Matrix; 
			var x         	:Number;
			var y         	:Number;
			var thickness 	:Number = 1 + radius / 50;
			
			this.wheel.graphics.clear();
			
			for(var i:int = 0; i < 360; i++) {
				
				// Convert the degree to radians.
				angle = i * (Math.PI / 180);
				
				// Get Color from ColorMath.angle_to_colour
				color = angle_to_colour(angle,brightness);
				
				// Calculate the coordinate in which the line should be drawn to.
				x = (radius+marginal) * Math.cos(angle);
				y = (radius+marginal) * Math.sin(angle);
				
				// Create a matrix for the lines gradient color.
				matrix = new Matrix();
				matrix.createGradientBox(radius * 2, radius * 2, angle, -radius, -radius);
				
				// Create and drawn the line.
				this.wheel.graphics.lineStyle(thickness, 0, 1, false, LineScaleMode.NONE, CapsStyle.NONE);
				this.wheel.graphics.lineGradientStyle(GradientType.LINEAR, [0xFFFFFF, color], [1, 1], [127, 255], matrix);
				this.wheel.graphics.moveTo(0, 0);
				this.wheel.graphics.lineTo(x, y);
				
			}
			
			// Draw wheel into bitmapdata
			matrix = new Matrix();
			matrix.tx = radius+marginal;
			matrix.ty = radius+marginal;
			bitmapdata = new BitmapData(this.wheel.width+marginal, this.wheel.height+marginal, false, 0);
			bitmapdata.draw(this.wheel,matrix);
			
			initialized = true;
			
		}
	}
}