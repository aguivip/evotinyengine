package project.utils.color
{
	public class ColorWheelMath
	{
		public function ColorWheelMath() {}
		private static const HEX_RANGE:Number = Math.PI / 3;
		/**
		 * Returns a 24-bit colour from an angle in radians.  The brightness
		 * value is just a multiplier that can darken the final colour as the
		 * value of brightness aproaches 0.
		 */
		public static function angle_to_colour(angle:Number, brightness:Number = 1):uint {
			
			var r:Number, g:Number, b:Number;
			var hex_area:uint = Math.floor(angle / HEX_RANGE);
			
			switch (hex_area) {
				case 0: r = 1; b = 0; break;
				case 1: g = 1; b = 0; break;
				case 2: r = 0; g = 1; break;
				case 3: r = 0; b = 1; break;
				case 4: g = 0; b = 1; break;
				case 5: r = 1; g = 0; break;
			}
			
			if (isNaN(r)) r = magnitude_from_hex_area(angle, hex_area);
			else if (isNaN(g)) g = magnitude_from_hex_area(angle, hex_area);
			else if (isNaN(b)) b = magnitude_from_hex_area(angle, hex_area);
			
			return ((r * brightness * 255) << 16) | ((g * brightness * 255) << 8) | (b * brightness * 255);
			
		}
		/**
		 * Returns a value 0..1 indicating the magnitude of the location.
		 */
		private static function magnitude_from_hex_area(angle:Number, hex_area:uint):Number {
			angle -= (hex_area * HEX_RANGE);
			if ((hex_area % 2) != 0) angle = HEX_RANGE - angle;// odd hex areas need their slope inverted
			return (angle / HEX_RANGE);
		}

	}
}