package com.thaumaturgistgames.slang 
{
	import flash.utils.Dictionary;
	
	/**
	 * @author Jacob Albano
	 */
	public class Memory extends Module 
	{
		private var vars:Dictionary;
		
		public function Memory() 
		{
			super();
			vars = new Dictionary;
		}
		
		override public function bind(slang:SlangInterpreter):void 
		{
			super.bind(slang);
			
			slang.addFunction("remember", remember, [String, Object], this, "Store a value in memory");
			slang.addFunction("forget", forget, [String], this, "Remove a value from memory");
			slang.addFunction("var", getVar, [String], this, "Retrive a value from memory");
			
		}
		
		private function remember(s:String, o:Object):Object 
		{
			vars[s] = o;
			return o;
		}
		
		private function forget(s:String):Object 
		{
			var o:Object = vars[s];
			delete vars[s];
			return o;
		}
		
		private function getVar(s:String):Object
		{
			return vars[s];
		}
		
		
	}

}