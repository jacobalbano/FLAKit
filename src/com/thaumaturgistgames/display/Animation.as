package com.thaumaturgistgames.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class Animation extends Sprite
	{
		public var clipRect:Rectangle = new Rectangle(0, 0, 100, 100);
		public var frame:uint = 0;
		
		private var storage:BitmapData;
		public var buffer:BitmapData;
		private var frameDelay:uint = 0;
		private var animation:Anim;
		private var animations:Vector.<Anim> = new Vector.<Anim>;
		private var frameWidth:Number;
		private var frameHeight:Number;
		private var _playing:String;
		
		/**
		 * 
		 * @param	DATA 	The embedded image to assign to the animation
		 * @param	width	Width of one animation frame
		 * @param	height	Height of one animation frame
		 */
		public function Animation(DATA:*, width:Number, height:Number) 
		{
			super();
			
			//	Since the DATA parameter is untyped, we need to check what type it is before we can make use of it
			//	We can do this with the 'is' keyword
			if (DATA is Class)
			{
				this.storage = (new DATA).bitmapData;
			}
			else if (DATA is Sprite || DATA is MovieClip)
			{
				this.storage = new BitmapData(DATA.width, DATA.height, true, 0);
				this.storage.draw(DATA);
			}
			else if (DATA is Bitmap)
			{
				this.storage = DATA.bitmapData;
			}
			else if (DATA is BitmapData)
			{
				this.storage = DATA;
			}
			else
			{
				//	The type of DATA is incompatible, so end the program and throw an error
				throw new Error("Invalid image source! Valid types are Class, Bitmap, BitmapData, Sprite and MovieClip.");
			}
			
			//	Make both bitmapData objects the same
			this.buffer = this.storage.clone();
			
			//	Assign the default frame to the object
			this.graphics.beginBitmapFill(storage, null, false, true);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			
			this.frameWidth = width;
			this.frameHeight = height;
			
			this.addEventListener("enterFrame", update);
		}
		
		/**
		 * Add a new animation
		 * @param	name		The animation's identifier
		 * @param	array		An arbitrary array denoting frames, i.e. [0, 2, 3]
		 * @param	framerate	How many times per second the animation should update
		 * @param	loop		Whether the animation should restart when it reaches the end
		 * @param	hold		Whether the animation should stop on the last frame
		 */
		public function add(name:String, array:Array, framerate:uint, loop:Boolean, hold:Boolean = false):void
		{
			//	Animation names must be unique, so throw an error if an animation is added again
			for each (var item:Anim in this.animations) 
			{
				if (item.name == name)
				{
					throw new Error("An animation with the name '" + name  +"' already exists.");
					return;
				}
			}
			
			this.animations.push(new Anim(name, framerate, array, loop, hold) );
		}
		
		/**
		 * Return the currently playing animation's name
		 */
		public function get playing():String
		{
			if (this.animation)	return this.animation.name;
			return "No animation is currently playing.";
		}
		
		/**
		 * Start an animation by name
		 * @param	name	The name of the animation to play
		 * @param	restart	Whether the named animation should restart from the beginning
		 */
		public function play(name:String, restart:Boolean = false):void
		{
			for each (var item:Anim in this.animations) 
			{
				if (item.name == name)
				{
					if (item == this.animation)
					{
						if (restart) this.frame = 0;
						break;
					}
					else
					{
						this.animation = item;
						this.frame = 0;
						break;
					}
					
					return;
				}
			}
		}
		
		protected function update(e:Event):void 
		{
			if (animation)
			{
				if (frameDelay >=  30 / animation.framerate)
				{
					if (this.frame == animation.frames.length - 1)
					{
						if (this.animation.hold)	return;
						
						if (this.animation.loop)  this.frame = 0;
						else
						{
							this.animation = null;
							return;
						}
					}
					else
					{
						frame++;
					}
					
					frameDelay = 0;
				}
				
				setRect();
				frameDelay++;
			}			
		}
	
		/**
		 * Internal function to update the buffer
		 */
		private function setRect():void 
		{
			var rx:uint = this.animation.frames[this.frame] * this.frameWidth;			
			var ry:uint = uint(rx / this.storage.width) * this.frameHeight;
			rx %= this.storage.width;
			
			this.buffer.copyPixels(storage, new Rectangle(rx, ry, this.frameWidth, this.frameHeight), new Point);
			this.graphics.clear();
			
			this.graphics.beginBitmapFill(buffer, null, false, false);
			this.graphics.drawRect(0, 0, this.frameWidth, this.frameHeight);
			this.graphics.endFill();
		}
		
	}
}