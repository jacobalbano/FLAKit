package com.thaumaturgistgames.display
{
	import com.thaumaturgistgames.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.thaumaturgistgames.flakit.Engine;
	import com.thaumaturgistgames.flakit.Library;

	public class Animation extends Sprite
	{
		public var clipRect:Rectangle = new Rectangle(0, 0, 100, 100);
		public var frame:uint = 0;
		
		private var storage:BitmapData;
		private var canvas:BitmapData;
		private var frameDelay:uint = 0;
		private var animation:Anim;
		private var animations:Vector.<Anim>;
		private var frameWidth:Number;
		private var frameHeight:Number;
		private var _playing:String;
		
		/**
		 * @param	DATA 	The embedded image to assign to the animation
		 * @param	width	Width of one animation frame
		 * @param	height	Height of one animation frame
		 */
		public function Animation(DATA:*, width:Number, height:Number) 
		{	
			var bmp:Bitmap;
			var failed:Boolean = false;
			
			//	Since the DATA parameter is untyped, we need to check what type it is before we can make use of it
			if (DATA is Class)
			{
				bmp = new DATA;
			}
			else if (DATA is Bitmap)
			{
				bmp = DATA;
			}
			else if (DATA is BitmapData)
			{
				bmp = new Bitmap(DATA);
			}
			else if (DATA is String)
			{
				bmp = Library.getImage(DATA as String);
				filename = DATA as String;
			}
			else if (DATA is Sprite)
			{
				bmp = (DATA as Sprite).image;
				filename = (DATA as Sprite).filename;
			}
			else
			{
				//	The type of DATA is incompatible, so end the program and throw an error
				throw new Error("Invalid image source! Valid types are Class, Bitmap, BitmapData, and Sprite.");
			}
			
			storage = bmp.bitmapData.clone();
			
			this.frameWidth = width;
			this.frameHeight = height;
			
			this.canvas = new BitmapData(frameWidth, frameHeight, true, 0x0);
			var buffer:Bitmap = new Bitmap(canvas);
			addChild(buffer);
			
			this.animations = new Vector.<Anim>;
			
			this.addEventListener("enterFrame", update);
			Engine.engine.addEventListener("libraryLoaded", reloadEvent)
		}
		
		public static function fromXML(xml:XML):Animation
		{
			var result:Animation;
			
			var image:String = xml.@image;
			var width:int = new Number(xml.@width);
			var height:int = new Number(xml.@height);
			
			result = new Animation(image, width, height);
			
			for each (var animation:XML in xml.animations.animation as XMLList) 
			{
				var name:String = animation.@name;
				var frames:Array = [];
				var rate:Number = animation.@rate;
				var loop:Boolean = (animation.@loop == "true") ? true : false;
				var hold:Boolean = (animation.@hold == "true") ? true : false;
				
				for each (var frame:XML in animation.frames.frame as XMLList) 
				{
					frames.push(new uint(frame));
				}
				
				result.add(name, frames, rate, loop, hold);
			}
			
			return result;
		}
		
		override public function onReloaded():void 
		{
			if (filename.length == 0)
			{
				return;
			}
			
			canvas.lock();
			storage.dispose();
			storage = Library.getImage(filename).bitmapData;
			canvas.unlock();
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
			
			this.canvas.copyPixels(storage, new Rectangle(rx, ry, this.frameWidth, this.frameHeight), new Point);
		}
		
	}
}