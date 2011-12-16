package com.thaumaturgistgames.display
{
	internal final class Anim 
	{
		public var name:String;
		public var framerate:uint;
		public var frames:Array;
		public var loop:Boolean;
		public var hold:Boolean;
		
		/**
		 * This is a utility class used by Animation to store data. It cannot be extended.
		 * @param	name		The name of the animation
		 * @param	framerate	How many frames per second the animation runs at
		 * @param	frames		An arbitrary array denoting frames
		 * @param	loop		Whether the animation returns to the beginning after finishing
		 * @param	hold		Whether to hold the animation on the last frame when finished
		 */
		public function Anim(name:String, framerate:uint, frames:Array, loop:Boolean, hold:Boolean) 
		{
			this.name = name;
			this.framerate = framerate
			this.frames = frames;
			this.loop = loop;
			this.hold = hold;
		}
		
	}

}