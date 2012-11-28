package com.thaumaturgistgames.slang 
{
	/**
	 * Interpreter for the Slang scripting language
	 * @author Jake Albano
	 */
	public class SlangInterpreter 
	{
		static private const DECLARATION:uint = 0;	//	The name of the function in string form
		static private const FUNCTION:uint = 1;		//	The function or method closure
		static private const ARG_TYPES:uint = 2;	//	An array of types for argument casting
		static private const THIS_OBJ:uint = 3;		//	The object to use as the 'this' reference in a function call
		static private const DOC:uint = 4;			//	The object to use as the 'this' reference in a function call
		
		private var functions:Array;
		private var callback:Function;
		private var errors:Array;
		private var executing:Boolean;
		
		public function SlangInterpreter() 
		{
			callback = defaultErrorHandler;
			functions = [];
			errors = [];
			executing = false;
			addFunction("help", help, [], this, "Displays this help screen");
			addFunction("if", opIf, [Boolean], null, "Abort execution if a false value is recieved");
			addFunction("not", opNot, [Boolean], null, "Return the inverse of a boolean value");
		}
		
		/**
		 * Evaluates a parameter, and aborts execution if it is false
		 * @param	val	The conditional parameter
		 */
		private function opIf(val:Boolean):void 
		{
			executing = val;
		}
		
		/**
		 * Invert a boolean variable
		 * @param	val	The variable to invert
		 * @return	The inverted parameter
		 */
		private function opNot(val:Boolean):Boolean
		{
			return !val;
		}
		
		public function importModule(module:Module):void
		{
			module.bind(this);
		}
		
		/**
		 * Set the callback for text output
		 */
		public function set errorHandler(handler:Function):void
		{
			if (handler == null)
			{
				callback = defaultErrorHandler;
				return;
			}
			
			try
			{
				handler("FLAKit console with Slang v" + getVersion() + "\nType help for a list of commands");
			}
			catch (e:ArgumentError)
			{
				callback = defaultErrorHandler;
				return;
			}
			
			callback = handler;
		}
		
		/**
		 * Get the version of the slang interpreter
		 * @return	The version as a number
		 */
		public function getVersion():Number 
		{
			return 0.5;
		}
		
		/**
		 * Adds a new function to the script interpreter
		 * @param	declaration	The string to be used when calling the function
		 * @param	func	The function or method closure to be used
		 * @param	argTypes	An array of types to cast arguments (can be empty or null)
		 * @param	thisObj	The object to use as the 'this' reference in the function call
		 * @param	documentation	An optional string to be displayed when the help command is called
		 */
		public function addFunction(declaration:String, func:Function, argTypes:Array = null, thisObj:Object = null, documentation:String = ""):void
		{
			if (!argTypes)
			{
				argTypes = [];
			}
			
			for each (var item:Array in functions)
			{
				if (item[DECLARATION] == declaration)
				{
					write("Failed to bind function '" + declaration + "': a function by that name already exists");
					return;
				}
			}
			
			functions.push([declaration, func, argTypes, thisObj, documentation]);
		}
		
		/**
		 * Executes a command or semicolon-separated series of commands
		 * @param	script The script to run
		 */
		public function doLine(script:String):void
		{
			doScript(script.split(";"));
		}
		
		/**
		 * Executes an array of commands or semicolon-separated series of commands
		 * @param	script	The array to run
		 */
		public function doScript(script:Array):void
		{
			for each (var line:String in script) 
			{
				executeLine(line);
				
				errors.reverse();
				while (errors.length > 0)
				{
					callback(errors.pop());
				}
			}
		}
		
		/**
		 * Execute a single line of Slang code
		 * @param	line	The line to execute
		 */
		private function executeLine(line:String):void
		{
			executing = true;
			var stack:Array = separate(line);
			
			var callstack:Array = [];
			var argstack:Array = [];
			var bytecode:Array = [];
			
			function pushArg(arg:*):void
			{
				argstack.push(arg);
				checkCall();
			}
			
			function pushCall(funcID:int):void
			{
				callstack.push(funcID);
				checkCall();
			}
			
			function checkCall():void
			{
				if (callstack.length > 0)
				{
					var definition:Array = functions[callstack[callstack.length - 1]];
					var types:Array = definition[ARG_TYPES];
					var paramCount:int = types.length;
					
					if (argstack.length >= paramCount)
					{
						var result:* = executeCall(callstack.pop(), argstack);
						
						while (paramCount >= 0)
						{
							paramCount--;
							argstack.pop();
						}
						
						if (result != undefined)
						{
							pushArg(result);
						}
					}
				}
			}
			
			for each (var word:String in stack) 
			{
				if (!executing)
				{
					return;
				}
				
				var funcIndex:int = findFunction(word);
				
				if (funcIndex < 0)
				{
					//Function not found, so assume it's a value, like a single-word string
					if (callstack.length != 0)
					{
						pushArg(word);
					}
				}
				else
				{
					pushCall(funcIndex);
				}
				
			}
			
			checkCall();
		}
		
		/**
		 * Execute a script function and return the result
		 * @param	funcID	The ID of the function to execute
		 * @param	argstack	The argument stack from which to pull parameters
		 * @return	The return value of the executing function, if any
		 */
		private function executeCall(funcID:int, argstack:Array):* 
		{
			var thisObj:Object = functions[funcID][THIS_OBJ];
			var func:Function = functions[funcID][FUNCTION];
			var paramCount:int = functions[funcID][ARG_TYPES].length;
			var params:Array = [];
			
			for (var i:int = 0; i < paramCount; ++i)
			{
				params.push(param_cast(funcID, i, argstack[i]));
			}
			
			//	Call the function
			try
			{
				return func.apply(thisObj, params);
			}
			catch (e:Error)
			{
				raiseError(e.getStackTrace().split("\n")[0]);
				return;
			}
		}
		
		/**
		 * Cast a value to the appropriate type to be used in a function
		 * @param	funcID	The function to be called
		 * @param	param	The index of the parameter type
		 * @param	value	The generic value to be converted
		 * @return	The value as the correct type
		 */
		private function param_cast(funcID:int, param:int, value:*):*
		{
			if (functions[funcID][ARG_TYPES][param] == Boolean)
			{
				if (value is String)
				{
					var string:String = value as String;
					return (string.search("true") >= 0 || string.search("1") >= 0);
				}
				else
				{
					return value as Boolean;
				}
				
				return false;
			}
			else if (functions[funcID][ARG_TYPES][param] == String)
			{
				var slice:String = value;
				if (slice.charAt(0) == "'" && slice.charAt(slice.length - 1) == "'")
				{
					return slice.slice(1, slice.length - 1);
				}
				
				return slice;
			}
			else
			{
				var type:Class = functions[funcID][ARG_TYPES][param];
				return new type(value);
			}
			
			return null;	//	Shouldn't happen
		}
		
		/**
		 * Search for a registered function by name and return its index, or -1 if it doesn't exist
		 * @param	fn	The function declaration
		 * @return	The function index or -1 on failure
		 */
		private function findFunction(fn:String):int
		{
			for (var findFunc:int = 0; findFunc < functions.length; ++findFunc)
			{
				if (functions[findFunc][DECLARATION] == fn)
				{
					return findFunc;
				}
			}
			
			return -1;
		}
		
		/**
		 * Separate a string into chunks at the spaces, keeping text surrounded by quotation marks contiguous
		 * @param	str	The string to separate
		 * @return	An array containing the chunks
		 */
		private function separate(str:String):Array 
		{
			var inString:Boolean = false;
			var builder:String = "";
			var result:Array = [];
			
			for (var i:int = 0; i < str.length; ++i)
			{
				switch (str.charAt(i))
				{
					case " ":
					case "\n":
					case "\t":
						if (inString)
						{
							builder += str.charAt(i);
						}
						else
						{
							if (builder.length > 0)
							{
								result.push(builder);
								builder = "";
							}
						}
						break;
					case "\"":
						inString = !inString
						builder += "'";
						if (!inString)
						{
							result.push(builder);
							builder = "";
						}
						break;
					default:
						builder += str.charAt(i);
						break;
				}
			}
			
			if (builder != " ")
			{
				result.push(builder);
			}
			
			return result;
		}
		
		/**
		 * Raise an error to be reported on execution end
		 * @param	message	The error message
		 * @return	The error message
		 */
		private function raiseError(message:String):String
		{
			errors.push(message);
			return message;
		}
		
		/**
		 * List the registered functions in the console
		 */
		public function help():void
		{
			callback("Commands:");
			
			for (var command:int = 0; command < functions.length; ++command)
			{
				var argTypes:String = "";
				var doc:String = "";
				
				if (functions[command][ARG_TYPES].length > 0)
				{
					argTypes = new String(functions[command][ARG_TYPES]);
					argTypes = replaceChar(argTypes, "[class ", "");
					argTypes = replaceChar(argTypes, "]", "");
					argTypes = replaceChar(argTypes, ",", ", ");
				}
				
				if (functions[command][DOC] != "")
				{
					doc = "\n\t-- " + functions[command][DOC];
				}
				
				callback("\t" + functions[command][DECLARATION] + " " + argTypes + doc);
			}
		}
		
		/**
		 * Replace patterns in a string
		 * @param	s	The in string
		 * @param	a	The pattern to replace
		 * @param	b	The string with which to replace
		 * @return	The in string with the specified pattern replaced
		 */
		private function replaceChar(s:String, a:String, b:String):String
		{
			var ar:Array = s.split(a);
			s = "";
			for(var i:Number = 0; i < ar.length; i++) s += i < ar.length-1 ? ar[i]+b : ar[i];
			return s;
		}
		
		/**
		 * Print a message to the callback
		 * @param	...rest	Variable parameters
		 */
		public function write(...rest):void
		{
			callback(rest.join(" "));
		}
		
		/**
		 * Used as the fallback when an invalid function is set as the error handler
		 * @param	message
		 */
		private function defaultErrorHandler(message:String):void 
		{
			trace(message);
		}
		
	}

}