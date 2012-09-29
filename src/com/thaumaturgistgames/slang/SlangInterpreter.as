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
		
		public function SlangInterpreter() 
		{
			callback = defaultErrorHandler;
			functions = [];
			addFunction("help", help, [], this, "Displays this help screen");
			errorHandler = defaultErrorHandler;
		}
		
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
			return 0.1;
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
			
			functions.push([declaration, func, argTypes, thisObj, documentation]);
		}
		
		/**
		 * Executes a command or semicolon-separated series of commands
		 * @param	script The script to run
		 */
		public function doLine(script:String):void
		{
			try
			{
				doScript(script.split(";"));
			}
			catch (e:Error)
			{
				write(e.message);
			}
		}
		
		/**
		 * Executes an array of commands or semicolon-separated series of commands
		 * @param	script	The array to run
		 */
		public function doScript(script:Array):void
		{
			try
			{
				executeScript(script);
			}
			catch (e:Error)
			{
				write(e.message);
			}
		}
		
		private function executeScript(script:Array):void
		{
			//	Read the script line by line
			for (var line:int = 0; line < script.length; ++line)
			{
				var thisObj:Object = null;
				var fn:String = "";
				var args:String = "";
				var argv:Array = null;
				var funcID:int = -1;
				var funcRange:int = -1;
				
				//	Strip out all the whitespace
				script[line] = replaceChar(script[line], " ", "");
				
				//	Find the end of the function name, if it exists
				funcRange = script[line].indexOf("[");
				
				if (funcRange >= 0)
				{
					fn = script[line].substr(0, funcRange);					
					args = script[line].substr(funcRange, script[line].length - 1);
				}
				else
				{
					fn = script[line];
				}
				
				//	Find the function declaration in binds
				for (var findFunc:int = 0; findFunc < functions.length; ++findFunc)
				{
					if (functions[findFunc][DECLARATION] == fn)
					{
						funcID = findFunc;
						break;
					}
				}
				
				if (funcID < 0)
				{
					throw new Error("Line " + (line + 1) + ": Couldn't resolve '" + fn + "' as a function.");
				}
				
				thisObj = functions[funcID][THIS_OBJ];
				
				//	Check if we have arguments to pass
				if (functions[funcID][ARG_TYPES].length == 0)
				{
					argv = [];
				}
				else
				{
					if (args == "")
					{
						throw new Error("Line " + (line + 1) + ": " + functions[funcID][DECLARATION] + " cannot be called without a parameter list");
					}
				}
				
				if (args.charAt(0) == "[" && args.charAt(args.length - 1) == "]")
				{
					//	Cut the braces off of the parameter list
					args = args.substr(1, args.length - 2);
					
					argv = args.split(",");
					
					if (argv.length != functions[funcID][ARG_TYPES].length)
					{
						throw new Error("Line " + (line + 1) + ": " + functions[funcID][DECLARATION] + " expects " + functions[funcID][ARG_TYPES].length + " parameters, but " + argv.length + " was passed");
					}
					
					for (var i:int = 0; i < argv.length; ++i)
					{
						if (functions[funcID][ARG_TYPES][i] == Boolean)
						{
							argv[i] = getBoolean(argv[i]);
						}
						else
						{
							argv[i] = new functions[funcID][ARG_TYPES][i](argv[i]);
						}
					}
				}
				
				//	Call the function
				functions[funcID][FUNCTION].apply(thisObj, argv);
			}
		}
		
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
					argTypes = "[" + argTypes + "]";
				}
				
				if (functions[command][DOC] != "")
				{
					doc = "\n\t-- " + functions[command][DOC];
				}
				
				callback("\t" + functions[command][DECLARATION] + " " + argTypes + doc);
			}
		}
		
		private function getBoolean(string:String):Boolean
		{
			return (string.search("true") >= 0 || string.search("1") >= 0);
		}
		
		private function replaceChar(s:String, a:String, b:String):String
		{
			var ar:Array = s.split(a);
			s = "";
			for(var i:Number = 0; i < ar.length; i++) s += i < ar.length-1 ? ar[i]+b : ar[i];
			return s;
		}
		
		private function write(...rest):void
		{
			callback(rest.join(" "));
		}
		
		private function defaultErrorHandler(message:String):void 
		{
			trace(message);
		}
		
	}

}