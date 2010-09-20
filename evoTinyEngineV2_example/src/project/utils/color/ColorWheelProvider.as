/**
 *
 * ColorWheelProvider:
 * 	provides lists of colors from colorwheel
 * 
 * METHODS:
 * 
 * ColorRulesSets:
 * 	getAnalogous
 * 	getContrary
 * 	getCurve
 * 	getGradient
 * 	getRandom
 * 	getTriad
 * 
 * Colorwheel Manipulation:
 * 	adjustColor
 * 	adjustBrightness
 * 	adjustContrast
 * 	adjustSaturation
 * 	adjustHue
 * 
 * @author Simo Santavirta - http://www.simppa.fi
 * @version 1.0
 * 
 */
package project.utils.color
{
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	
	public class ColorWheelProvider 
	{
		
		private var colorwheel:ColorWheel;
		private var bitmapdatawheel:BitmapData;
		private var orginal:BitmapData;
		private var colormatrix:ColorMatrix;
		
		
		public function ColorWheelProvider(quality:int = 256, brightness:Number = 1) {
			
			this.quality = quality;
			
			colorwheel = new ColorWheel(quality,brightness);
			
			this.center = quality+colorwheel.marginal;
			
			bitmapwheel = colorwheel.bitmapwheel;
			
			colormatrix = new ColorMatrix();
			
		}
		
		private var quality:int;
		private var center:int;
		
		private var radian:Number = Math.PI/180;
		private function circle(degree:Number,radial:Number):Array {
			
			var x:Number = Math.sin(degree*this.radian)*radial;
			var y:Number = Math.cos(degree*this.radian)*radial;
			
			return new Array(x,y);
				
		}
		
		// PUBLIC
		
		public var coordinates:Array;
		
		
		public function set bitmapwheel(bit:BitmapData):void {
			bitmapdatawheel = bit;
			orginal = bitmapdatawheel.clone();
		}
		public function get bitmapwheel():BitmapData {
			return bitmapdatawheel;
		}
		
		
		// WHEELCOLOR MANIPULATION
		
		public function adjustColor(brightness:Number = 0,contrast:Number = 0,saturation:Number = 0,hue:Number = 0):void {
			colormatrix.reset();
			colormatrix.adjustColor(brightness,contrast,saturation,hue);
			execute();
		}
		
		public function adjustBrightness(val:Number = 0):void {
			colormatrix.reset();
			colormatrix.adjustBrightness(val);
			execute();
		}
		public function adjustContrast(val:Number = 0):void {
			colormatrix.reset();
			colormatrix.adjustContrast(val);
			execute();
		}
		public function adjustSaturation(val:Number = 0):void {
			colormatrix.reset();
			colormatrix.adjustSaturation(val);
			execute();
		}
		public function adjustHue(val:Number = 0):void {
			colormatrix.reset();
			colormatrix.adjustHue(val);
			execute();
		}
		
		private function execute():void {
			bitmapwheel.draw(orginal);
			bitmapwheel.applyFilter(bitmapwheel, bitmapwheel.rect, new Point(0,0), new ColorMatrixFilter(colormatrix));
		}
		
		public function reset():void {
			bitmapwheel.draw(orginal);
		}
			
		
		// COLOR SETS
		
		// ONLY SUPPORT FOR 10 COLORS, AFTER THAT THINGS GET BAD...
		public function getAnalogous(startDegree:Number = 0, count:int = 5, range:Number = 12, colorCount:int = 10, start:Number = 0, end:Number = 1):Array {
				
				if(colorCount > 10) colorCount = 10;
				
				coordinates = new Array();
				
				var d:Number = end-start;
				
				start *= quality;
				end *= quality;
				
				var colors:Array = new Array();
				
				var p:Array;
				
				var scale:Number = ((quality/count)*colorCount)*d;
				
				var m0:int = count/colorCount;
				
				var v:int = 0;
				
				for(var i:int = 0; i < count; i++) {
					
					if(i >= (count/colorCount)*(v+1)) v++;
					
					p = circle(startDegree+(range*(v-Math.floor(colorCount/2))), start+scale*(i-m0*v));
					
					colors[i] = bitmapwheel.getPixel(center+p[0],center+p[1]);
					
					coordinates[i] = [center+p[0],center+p[1]];
					
				}
				
				return colors;
				
		}
		
		
		public function getTriad(startDegree:Number = 0, count:int = 5, start0:Number = 0, end0:Number = 1, start1:Number = 0, end1:Number = 1, start2:Number = 0, end2:Number = 1):Array {
				
				coordinates = new Array();
				
				start0 *= quality;
				end0 *= quality;
				var d0:int = end0-start0;
				
				start1 *= quality;
				end1 *= quality;
				var d1:int = end1-start1;
				
				start2 *= quality;
				end2 *= quality;
				var d2:int = end2-start2;
				
				var colors:Array = new Array();
				var p:Array;
				var start:Array = new Array(start0,start1,start2);
				var scale:Array = new Array(d0/(count/3),d1/(count/3),d1/(count/3));
				var dir:Array = new Array(0,120,-120);
				
				var m0:int = count/3;
				var v:int = 0;
				
				for(var i:int = 0; i < count; i++) {
					
					if(i >= (count/3)*(v+1)) v++;
					
					p = circle(startDegree+dir[v], start[v]+scale[v]*(i-m0*v));
					
					colors[i] = bitmapwheel.getPixel(center+p[0],center+p[1]);
					
					coordinates[i] = [center+p[0],center+p[1]];
					
				}
				
				return colors;
				
				
		}
		
		
		public function getGradient(startDegree:Number = 0, count:int = 5, start:Number = 0, end:Number = 1):Array {
				
				coordinates = new Array();
				
				start *= quality;
				end *= quality;
				
				var d:int = end-start;
				
				var colors:Array = new Array();
				var scale:Number = d/count;
				var p:Array;
				
				for(var i:int = 0; i < count; i++) {
					
					p = circle(startDegree, start+scale*i);
					colors[i] = bitmapwheel.getPixel(center+p[0],center+p[1]);
					coordinates[i] = [center+p[0],center+p[1]];
					
				}
				
				return colors;
			
		}
		
		
		public function getContrary(startDegree:Number = 0, count:int = 5, start0:Number = 0, end0:Number = 1, start1:Number = 0, end1:Number = 1):Array {
				
				coordinates = new Array();
				
				start0 *= quality;
				end0 *= quality;
				var d0:int = end0-start0;
				
				start1 *= quality;
				end1 *= quality;
				var d1:int = end1-start1;
				
				var colors:Array = new Array();
				
				var p:Array;
				
				var scale0:Number = d0/(count/2);
				var scale1:Number = d1/(count/2);
				
				var m1:int = count/2;
				
				for(var i:int = 0; i < count; i++) {
					
					if(i < m1) {
						p = circle(startDegree, start0+scale0*i);
					}else{
						p = circle(startDegree+180, start1+scale1*(i-m1));
					}
					
					colors[i] = bitmapwheel.getPixel(center+p[0],center+p[1]);
					
					coordinates[i] = [center+p[0],center+p[1]];
					
				}
				
				return colors;
				
		}
		
		
		
		public function getRandom(count:int):Array {
				
				coordinates = new Array();
				
				var colors:Array = new Array();
				
				var radial:Number = quality;
				
				var p:Array;
				for(var i:int = 0; i < count; i++) {
					
					p = circle(Math.random()*360, Math.random()*radial);
					colors[i] = bitmapwheel.getPixel(center+p[0],center+p[1]);
					coordinates[i] = [center+p[0],center+p[1]];
					
				}
				
				return colors;
				
		}
		
		
		public function getCurve(startDegree:Number = 0, count:int = 5, curve:Number = 1, start:Number = 0, end:Number = 1):Array {
				
				coordinates = new Array();
				
				start *= quality;
				end *= quality;
				
				var d:int = end-start;
				
				var colors:Array = new Array();
				var scale:Number = d/count;
				
				var radial:Number = quality;
				
				var p:Array;
				for(var i:int = 0; i < count; i++) {
					
					p = circle(startDegree+i*curve, start+scale*i);
					
					colors[i] = bitmapwheel.getPixel(center+p[0],center+p[1]);
					coordinates[i] = [center+p[0],center+p[1]];
					
				}
				
				return colors;
				
		}
		
		
	}
}