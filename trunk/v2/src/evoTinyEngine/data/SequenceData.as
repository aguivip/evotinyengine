package evoTinyEngine.data
{
	import evoTinyEngine.modifier.IModifier;

	public class SequenceData
	{
		public const sequencesMax			:int = 100000;
		public var sequenceStart			:Vector.<Vector.<IModifier>>;
		public var sequenceEnd				:Vector.<Vector.<IModifier>>;
		public var sequenceStartCount		:Vector.<int>;
		public var sequenceEndCount			:Vector.<int>;
		public function SequenceData()
		{
			sequenceStart = new Vector.<Vector.<IModifier>>(sequencesMax, true);
			sequenceEnd = new Vector.<Vector.<IModifier>>(sequencesMax, true);
			sequenceStartCount = new Vector.<int>(sequencesMax, true);
			sequenceEndCount = new Vector.<int>(sequencesMax, true);
		}
	}
}