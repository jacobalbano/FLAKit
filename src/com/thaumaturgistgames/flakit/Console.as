package com.thaumaturgistgames.flakit 
{
	import com.thaumaturgistgames.slang.SlangInterpreter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	 * In-game console class
	 * @author Jake Albano
	 */
	public class Console extends Sprite 
	{
		private var engine:SlangInterpreter;
		
		private var inputField:TextField;
		private var outputField:TextField;
		private var fadingIn:Boolean;
		private var juice:int;
		private var historyIndex:int;
		private var history:Array;
		
		public function Console() 
		{
			engine = new SlangInterpreter();
			
			historyIndex = 0;
			history = [];
			
			inputField = new TextField();
			outputField = new TextField();
			
			juice = 0;
			fadingIn = false;
			
			addEventListener(Event.ADDED, added);
		}
		
		public function get slang():SlangInterpreter
		{
			return engine;
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED, added);
			
			var consoleBG:Bitmap = new Bitmap(new BitmapData(stage.stageWidth - 20, 150, false, 0x0));
			
			addChild(consoleBG);
			
			var inputBG:Bitmap = new Bitmap(new BitmapData(width - 10, 20, false, 0xffffff));
			var outputBG:Bitmap = new Bitmap(new BitmapData(width - 30, height - 35, false, 0xffffff));
			
			inputBG.x = 5;
			inputBG.y = height - inputBG.height - 5;
			
			outputBG.x = 5;
			outputBG.y = 5;
			
			inputField.border = true;
			inputField.borderColor = 0x737373;
			inputField.width = width - 10;
			inputField.height = 20;
			inputField.x = 5;
			inputField.y = height - inputField.height - 5;
			inputField.type = "input";
			inputField.addEventListener(KeyboardEvent.KEY_DOWN, inputHandler);
			
			outputField.border = true;
			outputField.borderColor = 0x737373;
			outputField.width = outputBG.width;
			outputField.height = height - 35;
			
			outputField.x = 5;
			outputField.y = 5;
			
			var upButton:Sprite = new Sprite();
			upButton.graphics.beginFill(0xffffff, 1);
			upButton.graphics.lineStyle(1, 0x0);
			upButton.graphics.moveTo(9, 0);
			upButton.graphics.lineTo(18, 18);
			upButton.graphics.lineTo(0, 18);
			upButton.graphics.endFill();
			upButton.x = outputField.x + outputField.width + 3;
			upButton.y = outputField.y;
			
			var downButton:Sprite = new Sprite();
			downButton.graphics.beginFill(0xffffff, 1);
			downButton.graphics.lineStyle(1, 0x0);
			downButton.graphics.moveTo(9, 18);
			downButton.graphics.lineTo(0, 0);
			downButton.graphics.lineTo(18, 0);
			downButton.graphics.endFill();
			downButton.x = outputField.x + outputField.width + 3;
			downButton.y = outputField.y + outputField.height - downButton.height;
			
			downButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void
			{
				outputField.scrollV++;
			});
			
			upButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void
			{
				outputField.scrollV--;
			});
			
			inputBG.alpha = 0.6;
			outputBG.alpha = 0.6;
			consoleBG.alpha = 0.4;
			upButton.alpha = 0.6;
			downButton.alpha = 0.6;
			
			addChild(inputBG);
			addChild(outputBG);
			addChild(inputField);
			addChild(outputField);
			addChild(upButton);
			addChild(downButton);
			
			y = -height;
			x = 10;
			
			engine.errorHandler = function (message:String):void
			{
				trace(message);
			};
			
			Engine.game.addEventListener(KeyboardEvent.KEY_UP, function(event:KeyboardEvent):void
			{
				if (event.keyCode == Keyboard.F11 || event.keyCode == 192 /* tilde */)
				{
					juice = 0;
				   fadingIn = !fadingIn;
				}
			});
			
			inputField.addEventListener(Event.CHANGE, function(event:Event):void
			{
				//	If the tilde or grave character is entered into the console, remove it
				if (event.target.text.indexOf("`") >= 0 || event.target.text.indexOf("~") >= 0)
				{
					event.target.text = event.target.text.split("`").join("").split("~").join("");
				}
			});
			
			addEventListener(Event.ENTER_FRAME, function(e:Event):void
			{
				++juice;
				const factor:int = 2;
				
				if (fadingIn)
				{
					if (y < 0)
					{
						y += factor * juice;
					}
					
					stage.focus = inputField;
				}
				else
				{
					if ( y > -height)
					{
						y -= factor * juice;
					}
					stage.focus = outputField;
				}
				
				if (e.target.parent)
				{
					e.target.parent.setChildIndex(e.target, e.target.parent.numChildren - 1);
				}
			});
		}
		
		private function inputHandler(event:KeyboardEvent):void
		{
		   if (event.keyCode == Keyboard.ENTER)
		   {
			   outputField.scrollV = outputField.maxScrollV;
			   var command:String = event.target.text;
			   event.target.text = "";
			   engine.doLine(command);
			   history.push(command);
			   historyIndex = history.length;
		   }
		   else if (event.keyCode == Keyboard.UP)
		   {
			   historyIndex--;
			   if (historyIndex <= 0)
			   {
				   historyIndex = 0;
			   }
			   if (history.length > 0)
			   {
				   inputField.text = history[historyIndex];
			   }
		   }
		   else if (event.keyCode == Keyboard.DOWN)
		   {
			   historyIndex++;
			   if (historyIndex >= history.length)
			   {
				   historyIndex = history.length - 1;
			   }
			   if (history.length > 0)
			   {
				   inputField.text = history[historyIndex];
			   }
		   }
		}
		
		/**
		 * Behaves the same as flash's built in trace method, but outputs via the defined callback
		 * @param	...rest
		 */
		public function trace(...rest):void
		{
			outputField.text = outputField.text.concat(rest.join(" "), "\n");
			outputField.scrollV = outputField.maxScrollV;
		}
		
	}

}