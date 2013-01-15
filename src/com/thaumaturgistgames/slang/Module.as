package com.thaumaturgistgames.slang 
{
	/**
	 * @author Jacob Albano
	 */
	public class Module 
	{
		protected var slang:SlangInterpreter;
		
		public function Module() 
		{
		}
		
		/**
		 * Override this
		 * @param	slang	A reference to the interpreter
		 */
		public function bind(slang:SlangInterpreter):void
		{
			this.slang = slang;
		}
		
	}

}