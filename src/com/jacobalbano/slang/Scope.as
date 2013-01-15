package com.jacobalbano.slang
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Scope 
	{
		static private const VERSION:Number = 2.0;
		
		static private const BOOL_TYPE:int = 0x1;
		static private const NUMBER_TYPE:int = 0x2;
		static private const STRING_TYPE:int = 0x3;
		static private const SCOPE:int = 0x4;
		static private const FUNCTION:int = 0x5;
		
		private var funcs:Dictionary;
		private var parent:Scope;
		private var _bytecode:Array;
		private var _source:String;
		
		/**
		 * Constructs a new scope
		 * @param	parent
		 */
		public function Scope(parent:Scope = null)
		{
			funcs = new Dictionary;
			_bytecode = [];
			this.parent = parent;
			
			if (parent == null)
			{
				addFunction(new SlangFunction("if", SlangSTD.sIf).paramCount(2).documentation("If the supplied bool value is true, execute the supplied scope"));
				addFunction(new SlangFunction("ifelse", SlangSTD.sIfElse).paramCount(3).documentation("If the supplied bool value is true, execute the first supplied scope; otherwise execute the second"));
				addFunction(new SlangFunction("!", SlangSTD.sNot).paramCount(1).documentation("Returns the inverse of a bool value"));
				addFunction(new SlangFunction("both", SlangSTD.sAnd).paramCount(2).documentation("Returns true if either parameter is true"));
				addFunction(new SlangFunction("either", SlangSTD.sOr).paramCount(2).documentation("Returns true if both parameters are true"));
			}
		}
		
		public function addFunction(func:SlangFunction):void
		{
			funcs[func.name] = func;
		}
		
		public function toString():String
		{
			var result:String = (parent) ? "[Scope]{\n" : "[Global scope]\n";
			
			for each (var item:Array in bytecode) 
			{
				result += item[1] + "\n";
			}
			
			if (parent)
			{
				result += "}";
			}
			
			return result;
		}
		
		/**
		 * Execute a compiled scope
		 */
		public function execute():void
		{
			assert(bytecode.length > 0, "Attempted to execute scope prior to compilation");
			
			var stack:Array = [];
			trace(stack.join("\n"));
			
			function push(val:*):void
			{
				stack.push(val);
				checkCall();
			}
			
			function checkCall():void
			{
				if (stack.length > 0)
				{
					var func:SlangFunction = null;
					var i:int = stack.length;
					var count:uint = 0;	//	how many values are on the stack after the last function
					
					//	find the last function to be pushed onto the stack
					while (i --> 0)
					{
						if (stack[i] is SlangFunction)
						{
							func = stack[i];
							break;
						}
						
						++count;
					}
					
					//if (func == null)
					//{
						//return;
					//}
					
					if (func.params == count)
					{
						var ret:* = func.call(stack.slice(stack.length - func.params, stack.length));
						while (count --> 0)
						{
							//	pop values consumed as parameters
							stack.pop();
						}
						
						//	pop the function off the stack
						stack.pop();
						
						if (ret != undefined)
						{
							push(ret);
							checkCall();
						}
						
					}
				}
			}
			
			for each (var item:Array in bytecode) 
			{
				switch(item[0])
				{
					case BOOL_TYPE:
					case NUMBER_TYPE:
					case STRING_TYPE:
					case SCOPE:
					{
						if (stack.length > 0)
						{
							push(item[1]);
						}
						break;
					}
					case FUNCTION:
					{
						push(item[1]);
					}
				}
			}
			
			assert(stack.length == 0, "Unresolved values left on stack");
		}
		
		/**
		 * Compile a string into bytecode. Once a scope has been compiled, you can execute it with execute()
		 * @param	str
		 * @return
		 */
		public function compile(str:String):Scope 
		{
			_bytecode = [];
			var inString:Boolean = false;
			var builder:String = "";
			
			function resolveVal(value:String):void
			{
				var type:int = getType(value);
				op(type, cast(type, value));
			}
			
			for (var i:int = 0; i < str.length; ++i)
			{
				switch (str.charAt(i))
				{
					case "{":
						var result:Array = compileScopeContents(str.substring(i + 1));
						i += result[0];
						op(SCOPE, result[1]);
						break;
					case "}":
						break;
					case " ":
					case "\n":
					case "\t":
					case "\r":
						if (inString)
						{
							builder += str.charAt(i);
						}
						else
						{
							if (builder.length > 0)
							{
								resolveVal(builder);
								builder = "";
							}
						}
						break;
					case "\"":
						inString = !inString
						if (!inString)
						{
							op(STRING_TYPE, builder);
							builder = "";
						}
						break;
					default:
						builder += str.charAt(i);
						break;
				}
			}
			
			if (builder != "" && builder != " ")
			{
				resolveVal(builder);
			}
			
			_source = str;
			return this;
		}
		
		/**
		 * Compiles a string until all scopes have been resolved, then returns
		 * This compilation will often resolve before the end of the  source string is reached
		 * @param	string	The string to compile
		 * @return	A scope containing bytecode generated from the source
		 */
		private function compileScopeContents(string:String):Array 
		{
			var scope:Scope = new Scope(this);
			var open:int = 1, close:int = 0;
			var length:int = 0;
			
			for (var i:int = 0; i < string.length; ++i)
			{
				if (string.charAt(i) == "{")
				{
					++open;
				}
				else if (string.charAt(i) == "}")
				{
					++close;
					if (close == open)
					{
						length = i;
						scope.compile(string.substr(0, i));
						break;
					}
				}
			}
			
			assert(!(close < open), "Scope was opened but not closed");
			assert(!(close > open), "Too many scope close tokens");
			
			return [length, scope];
		}
		
		/**
		 * Push a bytecode operation
		 * @param	opcode	The instruction to use
		 * @param	value	The value to push
		 */
		private function op(opcode:int, value:*):void
		{
			_bytecode.push([opcode, value]);
		}
		
		/**
		 * Determine the type of a value represented by a string
		 * @param	str
		 * @return	The type ID of the value. Will be one of the constants in Scope
		 */
		private function getType(str:String):int
		{
			if (getFunction(str) != null)
			{
				return FUNCTION;
			}
			else if (str == "true" || str == "false")
			{
				return BOOL_TYPE;
			}
			else
			{
				if (!isNaN(parseFloat(str)))
				{
					return NUMBER_TYPE;
				}
			}
			
			return STRING_TYPE;
		}
		
		/**
		 * Convert a string to a real value
		 * @param	type	The ID of the type to cast to
		 * @param	value	The string to be cast
		 * @return	The string cast as a value
		 */
		private function cast(type:int, value:String):*
		{
			switch (type) 
			{
				case BOOL_TYPE:
					return value == "true";
				case NUMBER_TYPE:
					return parseFloat(value);
				case STRING_TYPE:
					return value;
				case FUNCTION:
					return (getFunction(value) as SlangFunction);
				default:
					break;
			}
			
			throw new Error("This should never happen! Did you supply a bogus typeID?");
		}
		
		/**
		 * Find a function by name by searching this scope and its parent, recursively
		 * @param	name
		 * @return	The named function, or null if it doesn't exist
		 */
		private function getFunction(name:String):SlangFunction
		{
			var scope:Scope = this;
			while (scope != null)
			{
				var result:Object = scope.funcs[name];
				
				if (result)
				{
					return result as SlangFunction;
				}
				
				scope = scope.parent;
			}
			
			return null;
		}
		
		private function assert(truth:Boolean, message:String = ""):void
		{
			if (!truth)
			{
				throw new SyntaxError(message);
			}
		}
		
		//{ region accessors
		
		public function get bytecode():Array 
		{
			return _bytecode;
		}
		
		public function get source():String 
		{
			return _source;
		}
		
		//} endregion
	}

}