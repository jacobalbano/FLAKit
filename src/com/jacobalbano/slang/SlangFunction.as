package com.jacobalbano.slang
{
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class SlangFunction 
	{
		private var func:Function;
		private var _doc:String;
		private var _params:uint;
		private var _name:String;
		private var _self:Object;
		
		public function toString():String
		{
			return "[Function] " + name + " (" + (params || "") + ") ";
		}
		
		public function SlangFunction(name:String, func:Function)
		{
			this.func = func;
			_name = name;
			_params = 0;
			_doc = "";
		}
		
		public function paramCount(count:uint):SlangFunction
		{
			_params = count;
			return this;
		}
		
		public function documentation(string:String):SlangFunction
		{
			_doc = string;
			return this;
		}
		
		public function self(obj:Object):SlangFunction
		{
			_self = obj;
			return this;
		}
		
		public function call(args:Array):*
		{
			return func.apply(_self, args);
		}
		
		//{ region accessors
		public function get name():String 
		{
			return _name;
		}
		
		public function get params():uint 
		{
			return _params;
		}
		
		public function get doc():String 
		{
			return _doc;
		}
		//} endregion
	}

}