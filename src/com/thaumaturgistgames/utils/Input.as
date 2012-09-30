package com.thaumaturgistgames.utils 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import com.thaumaturgistgames.flakit.Engine;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	
	public class Input 
	{
		private static var _keyStates:Vector.<Boolean>;
		private static var _mousePressed:Boolean;
		private static var _mouseReleased:Boolean;
		private static var _elapsed:Number;
		private static var _engine:Engine;
		
		public function Input() {}
		
		/**
		 * Called by engine
		 */
		public static function init(engine:Engine):void
		{
			_keyStates = new Vector.<Boolean>;
			
			for (var i:uint = 0; i < 255; i++)
			{
				_keyStates.push(false);
			}
			
			_keyStates.fixed = true;
			
			_engine = engine;
			
			engine.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			engine.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			engine.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			engine.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		private static function keyUp(e:KeyboardEvent):void 
		{
			_keyStates[e.keyCode] = false;
		}
		
		private static function keyDown(e:KeyboardEvent):void 
		{
			_keyStates[e.keyCode] = true;
		}
		
		private static function mouseDown(e:MouseEvent):void
		{
			_mousePressed = true;
		}
		
		private static function mouseUp(e:MouseEvent):void
		{
			_mousePressed = false;
		}
		
		public static function get isMouseDown():Boolean
		{
			return _mousePressed;
		}
		
		/**
		 * Returns the current X position of the mouse
		 */
		public static function get mouseX():Number
		{
			return _engine.mouseX;
		}
		
		/**
		 * Returns the current Y position of the mouse
		 */
		public static function get mouseY():Number
		{
			return _engine.mouseY;
		}
		
		
		public static function isKeyDown(key:int):Boolean
		{
			return _keyStates[key];
		}
		
		public static const LEFT:int = 37;
		public static const UP:int = 38;
		public static const RIGHT:int = 39;
		public static const DOWN:int = 40;
		
		public static const ENTER:int = 13;
		public static const CONTROL:int = 17;
		public static const SPACE:int = 32;
		public static const SHIFT:int = 16;
		public static const BACKSPACE:int = 8;
		public static const CAPS_LOCK:int = 20;
		public static const DELETE:int = 46;
		public static const END:int = 35;
		public static const ESCAPE:int = 27;
		public static const HOME:int = 36;
		public static const INSERT:int = 45;
		public static const TAB:int = 9;
		public static const PAGE_DOWN:int = 34;
		public static const PAGE_UP:int = 33;
		public static const LEFT_SQUARE_BRACKET:int = 219;
		public static const RIGHT_SQUARE_BRACKET:int = 221;
		
		public static const A:int = 65;
		public static const B:int = 66;
		public static const C:int = 67;
		public static const D:int = 68;
		public static const E:int = 69;
		public static const F:int = 70;
		public static const G:int = 71;
		public static const H:int = 72;
		public static const I:int = 73;
		public static const J:int = 74;
		public static const K:int = 75;
		public static const L:int = 76;
		public static const M:int = 77;
		public static const N:int = 78;
		public static const O:int = 79;
		public static const P:int = 80;
		public static const Q:int = 81;
		public static const R:int = 82;
		public static const S:int = 83;
		public static const T:int = 84;
		public static const U:int = 85;
		public static const V:int = 86;
		public static const W:int = 87;
		public static const X:int = 88;
		public static const Y:int = 89;
		public static const Z:int = 90;
		
		public static const F1:int = 112;
		public static const F2:int = 113;
		public static const F3:int = 114;
		public static const F4:int = 115;
		public static const F5:int = 116;
		public static const F6:int = 117;
		public static const F7:int = 118;
		public static const F8:int = 119;
		public static const F9:int = 120;
		public static const F10:int = 121;
		public static const F11:int = 122;
		public static const F12:int = 123;
		public static const F13:int = 124;
		public static const F14:int = 125;
		public static const F15:int = 126;
		
		public static const DIGIT_0:int = 48;
		public static const DIGIT_1:int = 49;
		public static const DIGIT_2:int = 50;
		public static const DIGIT_3:int = 51;
		public static const DIGIT_4:int = 52;
		public static const DIGIT_5:int = 53;
		public static const DIGIT_6:int = 54;
		public static const DIGIT_7:int = 55;
		public static const DIGIT_8:int = 56;
		public static const DIGIT_9:int = 57;
		
		public static const NUMPAD_0:int = 96;
		public static const NUMPAD_1:int = 97;
		public static const NUMPAD_2:int = 98;
		public static const NUMPAD_3:int = 99;
		public static const NUMPAD_4:int = 100;
		public static const NUMPAD_5:int = 101;
		public static const NUMPAD_6:int = 102;
		public static const NUMPAD_7:int = 103;
		public static const NUMPAD_8:int = 104;
		public static const NUMPAD_9:int = 105;
		public static const NUMPAD_ADD:int = 107;
		public static const NUMPAD_DECIMAL:int = 110;
		public static const NUMPAD_DIVIDE:int = 111;
		public static const NUMPAD_ENTER:int = 108;
		public static const NUMPAD_MULTIPLY:int = 106;
		public static const NUMPAD_SUBTRACT:int = 109;
		
	}

}