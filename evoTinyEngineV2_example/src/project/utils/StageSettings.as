package project.utils {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;

	/**
	 * Set all stage settings here.
	 * 
	 * @author Simo Santavirta
	 */
	public class StageSettings extends Sprite {

		public function StageSettings(stage : Stage, quality:String = StageQuality.HIGH) {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = quality;
		}
	}
}