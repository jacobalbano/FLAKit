package com.thaumaturgistgames.slang 
{
	import flash.utils.Dictionary;
	/**
	 * @author Jacob Albano
	 */
	public class Stdlib extends Module 
	{
		private var macros:Dictionary;
		
		public function Stdlib() 
		{
			macros = new Dictionary;
		}
		
		override public function bind(slang:SlangInterpreter):void 
		{
			super.bind(slang);
			slang.addFunction("print", print, [String], null, "Print a string to the console");
			slang.addFunction("equals", equals, [Object, Object], null, "Tests two objects for equality");
		}
		
		private function print(s:String):void
		{
			slang.write(s);
		}
		
		private function equals(o1:Object, o2:Object):Boolean
		{
			return o1 == o2;
		}
	}

}