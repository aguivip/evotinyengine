package evoTinyEngine.modifier
{
	/**
	 * @author EvoFlash (evo.bombsquad.org) / jac (jac@bombsquad.org)
	 */
	public class ModifierType
	{
		/**
		 * ONLY INITIALIZE AND DISPOSE ARE CALLED. BEFORE ALL.
		 **/
		public static const SETUP			:int = 0x0;
		
		/**
		 * FIRST INITIALIZED, RENDERED AND DISPOSED. AFTER SETUP, BEFORE EFFECT.
		 **/
		public static const PREPROCESS		:int = 0x1;
		
		/**
		 * SECOND INITIALIZED, RENDERED AND DISPOSED. AFTER PREPROCESS, BEFORE POSTPROCESS.
		 **/
		public static const EFFECT			:int = 0x2;
		
		/**
		 * THIRD INITIALIZED, RENDERED AND DISPOSED. AFTER EFFECT, BEFORE OVERLAY.
		 **/
		public static const POSTPROCESS		:int = 0x3;
		
		/**
		 * FOURTH INITIALIZED, RENDERED AND DISPOSED. AFTER ALL.
		 **/
		public static const OVERLAY			:int = 0x4;
	}
}